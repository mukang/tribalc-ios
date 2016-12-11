//
//  TCOrderItem.m
//  individual
//
//  Created by WYH on 16/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCOrderItem.h"
#import "TCGoods.h"

@implementation TCOrderItem

+ (NSDictionary *)objectClassInDictionary {
    return @{
             @"goods": [TCGoods class]
             };
}

@end
