//
//  TCListShoppingCart.m
//  individual
//
//  Created by WYH on 16/12/8.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCListShoppingCart.h"

@implementation TCListShoppingCart

+ (NSDictionary *)objectClassInArray {
    return @{@"goodsList": [TCOrderItem class]};
}

+ (NSDictionary *)objectClassInDictionary {
    return @{
             @"store": [TCMarkStore class]
             };
}



@end
