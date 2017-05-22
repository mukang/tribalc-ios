//
//  TCUserSession.m
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUserSession.h"
#import <TCCommonLibs/NSObject+TCModel.h>
#import "TCActivityInfo.h"

@implementation TCUserSession

+ (NSDictionary *)objectClassInDictionary {
    return @{
             @"userInfo": [TCUserInfo class],
             @"activities": [TCActivityInfo class]
             };
}

@end
