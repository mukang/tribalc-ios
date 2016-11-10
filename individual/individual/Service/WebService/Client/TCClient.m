//
//  TCClient.m
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCClient.h"
#import "TCFunctions.h"
#import "TCClientConfig.h"
#import "TCClientRequest.h"
#import "TCClientResponse.h"
#import "TCClientRequestError.h"

#import <AFNetworking.h>

@interface TCClient ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) AFJSONRequestSerializer *requestSerializer;
@property (strong, nonatomic) AFHTTPResponseSerializer *responseSerializer;

@end

@implementation TCClient

+ (instancetype)client {
    static TCClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc] initPrivate];
    });
    return client;
}

- (instancetype)initPrivate {
    if (self = [super init]) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURL *baseURL = [NSURL URLWithString:TCCLIENT_BASE_URL];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
        _requestSerializer = [AFJSONRequestSerializer serializer];
        [_requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        _responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.requestSerializer = _requestSerializer;
        _sessionManager.responseSerializer = _responseSerializer;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Ues +[TCClient client]"
                                 userInfo:nil];
    return nil;
}

- (void)send:(TCClientRequest *)clientRequest finish:(void (^)(TCClientResponse *))responseBlock {
    
    NSString *method = clientRequest.HTTPMethod;
    NSString *URLString = clientRequest.apiName;
    NSDictionary *parameters = clientRequest.params;
    
    __block NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[self.sessionManager.baseURL absoluteString] stringByAppendingString:URLString] parameters:parameters error:&serializationError];
    if (serializationError) {
        TCClientRequestError *error = [TCClientRequestError errorWithCode:TCClientRequestErrorRequestSerializationError
                                                           andDescription:serializationError.localizedDescription];
        TCClientResponse *response = [TCClientResponse responseWithStatusCode:0 data:nil orError:error];
        if (responseBlock) {
            TC_CALL_ASYNC_MQ(responseBlock(response));
        }
        return;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        NSDictionary *dataInResponse = nil;
        NSInteger codeInResponse = 0;
        if (!error) {
            serializationError = nil;
            NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                         options:NSJSONReadingMutableLeaves
                                                                           error:&serializationError];
            if (serializationError) {
                NSString *dataString = [[NSString alloc] initWithData:responseObject
                                                             encoding:NSUTF8StringEncoding];
                NSLog(@"服务器响应解析出错，响应文本为: %@, 状态码为: %zd", dataString, [(NSHTTPURLResponse *)response statusCode]);
                error = [TCClientRequestError errorWithCode:TCClientRequestErrorServerResponseNotJSON
                                             andDescription:serializationError.localizedDescription];
            } else {
                NSNumber *code = responseData[@"code"];
                codeInResponse = code.integerValue;
                if (codeInResponse >= 400) {
                    error = [TCClientRequestError errorWithCode:codeInResponse andDescription:responseData[@"message"]];
                } else {
                    dataInResponse = responseData[@"data"];
                }
            }
        } else {
            if ([error.domain isEqualToString:NSURLErrorDomain]) {
                TCClientRequestErrorCode errorCode = [TCClientRequestError codeFromNSURLErrorCode:error.code];
                error = [TCClientRequestError errorWithCode:errorCode andDescription:error.localizedDescription];
            } else {
                error = [TCClientRequestError errorWithCode:TCClientRequestErrorNetworkError andDescription:error.localizedDescription];
            }
        }
        TCClientResponse *clientResponse = [TCClientResponse responseWithStatusCode:codeInResponse data:dataInResponse orError:error];
        if (responseBlock) {
            responseBlock(clientResponse);
        }
    }];
    [dataTask resume];
}

@end
