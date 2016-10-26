//
//  TCClientRequest.m
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCClientRequest.h"
#import "TCFunctions.h"
#import "TCClientConfig.h"

@interface TCClientRequest ()

@property (nonatomic, copy) NSString *requestIdentifier;
@property (nonatomic, copy) NSString *apiName;
@property (nonatomic, strong) NSMutableDictionary *requestParams;
@property (nonatomic, strong) NSMutableArray *requestFiles;

@end

@implementation TCClientRequest

#pragma mark - Protocol DXClientRequest

- (void)setValue:(id)value forParam:(NSString *)name {
    if (name != nil && value != nil) {
        [self.requestParams setObject:value forKey:name];
    }
}

- (id)valueForParam:(NSString *)name {
    return [self.requestParams objectForKey:name];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    [self setValue:value forParam:key];
}

- (id)valueForKey:(NSString *)key {
    return [self valueForParam:key];
}

- (NSDictionary *)params {
    return [self.requestParams copy];
}

- (void)addFile:(NSURL *)fileURL {
    NSAssert([fileURL isFileURL], @"只能添加本地文件");
    [self.requestFiles addObject:fileURL];
}

- (NSArray *)files {
    return [self.requestFiles copy];
}

- (NSString *)httpMethod {
    return @"GET";
}

- (NSTimeInterval)timeout {
    return 20;
}

#pragma mark - Public Methods

+ (instancetype)requestWithApi:(NSString *)apiName {
    NSParameterAssert(apiName != nil);
    
    NSString *requestClassName = [[self class] requestClassNameForApi:apiName];
    Class requestClass = NSClassFromString(requestClassName);
    NSAssert(requestClass != nil, @"未找到名为%@的类", requestClassName);
    
    return [[requestClass alloc] initWithApiName:apiName];
}

#pragma mark - Private Methods

- (instancetype)initWithApiName:(NSString *)apiName {
    if (self = [super init]) {
        _apiName = apiName;
        _requestIdentifier = [[self class] createIdentifier];
    }
    return self;
}

+ (NSString *)createIdentifier {
    NSDate *now = [NSDate date];
    int random = arc4random() % 1000;
    NSString *randomString = [NSString stringWithFormat:@"%lu%03d", (unsigned long)[now timeIntervalSince1970], random];
    return TCDigestMD5(randomString);
}

+ (NSString *)requestClassNameForApi:(NSString *)apiName {
    NSArray *nameParts = [apiName componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/_"]];
    NSMutableArray *caramelizedNameParts = [NSMutableArray array];
    for (NSString *part in nameParts) {
        [caramelizedNameParts addObject:part];
    }
    return [NSString stringWithFormat:TCCLIENT_REQUEST_CLASS_FORMAT, [caramelizedNameParts componentsJoinedByString:@""]];
}

#pragma mark - Override Methods

- (NSMutableDictionary *)requestParams {
    if (_requestParams == nil) {
        _requestParams = [NSMutableDictionary dictionary];
    }
    return _requestParams;
}

- (NSMutableArray *)requestFiles {
    if (_requestFiles == nil) {
        _requestFiles = [NSMutableArray array];
    }
    return _requestFiles;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"request: %@, files: %@", self.params, self.files];
}

@end
