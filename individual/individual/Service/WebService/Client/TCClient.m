//
//  TCClient.m
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCClient.h"
#import "TCFunctions.h"

#import <AFNetworking.h>

@interface TCClient ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation TCClient

+ (instancetype)client {
    static TCClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[self alloc] init];
    });
    return client;
}

#pragma mark - lazy

- (AFHTTPSessionManager *)sessionManager {
    if (_sessionManager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURL *baseURL = [NSURL URLWithString:@"https://www.baidu.com/"];
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:configuration];
    }
    return _sessionManager;
}

@end
