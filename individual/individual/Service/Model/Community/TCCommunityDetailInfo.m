//
//  TCCommunityDetailInfo.m
//  individual
//
//  Created by 穆康 on 2016/11/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunityDetailInfo.h"
#import "TCStoreInfo.h"

@implementation TCCommunityDetailInfo

+ (NSDictionary *)objectClassInArray {
    return @{
             @"repastList": [TCStoreInfo class],
             @"entertainmentList": [TCStoreInfo class]
             };
}

@end
