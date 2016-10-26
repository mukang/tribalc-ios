//
//  TCClientRequest.h
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TCClientRequest <NSObject>

@required

- (void)setValue:(id)value forParam:(NSString *)name;

- (id)valueForParam:(NSString *)name;

- (NSDictionary *)params;

- (void)addFile:(NSURL *)fileURL;

- (NSArray *)files;

- (NSString *)httpMethod;

- (NSTimeInterval)timeout;

@end


@interface TCClientRequest : NSObject <TCClientRequest>

+ (instancetype)requestWithApi:(NSString *)apiName;

- (NSString *)requestIdentifier;

- (NSString *)apiName;

@end


