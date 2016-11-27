//
//  TCClientRequest.h
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const TCClientHTTPMethodGet;
extern NSString *const TCClientHTTPMethodPost;
extern NSString *const TCClientHTTPMethodPut;
extern NSString *const TCClientHTTPMethodDelete;

@protocol TCClientRequest <NSObject>

@required

- (void)setValue:(id)value forParam:(NSString *)name;

- (id)valueForParam:(NSString *)name;

- (NSDictionary *)params;

@end


@interface TCClientRequest : NSObject <TCClientRequest>

@property (copy, nonatomic, readonly) NSString *apiName;
@property (copy, nonatomic, readonly) NSString *HTTPMethod;
@property (copy, nonatomic, readonly) NSString *requestIdentifier;

@property (strong, nonatomic) NSData *imageData;

+ (instancetype)requestWithApi:(NSString *)apiName;
+ (instancetype)requestWithHTTPMethod:(NSString *)HTTPMethod apiName:(NSString *)apiName;

@end


