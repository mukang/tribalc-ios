//
//  TCGoodsStandard.m
//  individual
//
//  Created by 穆康 on 2017/9/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandard.h"

@implementation TCGoodsStandard

+ (NSDictionary *)objectClassInDictionary {
    return @{
             @"descriptions": [TCGoodsStandardDescriptions class]
             };
}

@end
