//
//  TCGoodsStandard.h
//  individual
//
//  Created by 穆康 on 2017/9/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCGoodsStandardDescriptions.h"

@interface TCGoodsStandard : NSObject

/** 商品规格ID */
@property (copy, nonatomic) NSString *ID;
/** 规格描述信息 */
@property (strong, nonatomic) TCGoodsStandardDescriptions *descriptions;
/** 规格索引信息 */
@property (copy, nonatomic) NSDictionary *goodsIndexes;

@end
