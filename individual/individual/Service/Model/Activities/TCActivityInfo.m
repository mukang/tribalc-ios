//
//  TCActivityInfo.m
//  individual
//
//  Created by 穆康 on 2017/5/22.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCActivityInfo.h"
#import "TCSigninRecordDay.h"

@implementation TCActivityInfo

+ (NSDictionary *)objectClassInDictionary {
    return @{
             @"signin": [TCSigninRecordDay class]
             };
}

@end
