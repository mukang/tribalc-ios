//
//  TCGoodsStandardDescriptions.h
//  individual
//
//  Created by 穆康 on 2017/9/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCGoodsStandardUnits.h"

@interface TCGoodsStandardDescriptions : NSObject

/** 一级规格 */
@property (strong, nonatomic) TCGoodsStandardUnits *primary;
/** 二级规格 */
@property (strong, nonatomic) TCGoodsStandardUnits *secondary;

@end
