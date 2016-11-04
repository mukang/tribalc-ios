//
//  TCClientResponse.m
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCClientResponse.h"
#import <objc/runtime.h>

@implementation TCClientResponse

#pragma mark - Public Methods

+ (instancetype)responseWithData:(NSDictionary *)data orError:(NSError *)error {
    if (!error) {
        return [[self alloc] initWithData:data];
    } else {
        return [[self alloc] initWithError:error];
    }
}

#pragma mark - Private Methods

- (instancetype)initWithData:(NSDictionary *)data {
    if (self = [super init]) {
        _data = data;
    }
    return self;
}

- (instancetype)initWithError:(NSError *)error {
    if (self = [super init]) {
        _error = error;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"TCClientResponse初始化错误"
                                   reason:@"请使用接口文件提供的类方法"
                                 userInfo:nil];
    return nil;
}

#pragma mark - Override Methods

- (NSString *)description {
    id info = self.error ?: self.data;
    return [NSString stringWithFormat:@"%@ : %@", [self class], info];
}

@end
