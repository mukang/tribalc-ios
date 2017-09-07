//
//  TCGoodsStandardDescriptions.m
//  individual
//
//  Created by 穆康 on 2017/9/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandardDescriptions.h"

@implementation TCGoodsStandardDescriptions

+ (NSDictionary *)objectClassInDictionary {
    return @{
             @"primary": [TCGoodsStandardUnits class],
             @"secondary": [TCGoodsStandardUnits class]
             };
}

@end
