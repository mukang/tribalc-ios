//
//  TCClientResponse.h
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCClientResponse : NSObject

@property (copy, nonatomic, readonly) NSDictionary *data;
@property (strong, nonatomic, readonly) NSError *error;

+ (instancetype)responseWithData:(NSDictionary *)data orError:(NSError *)error;

@end
