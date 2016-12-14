//
//  TCOrderItem.h
//  individual
//
//  Created by WYH on 16/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCGoods.h"

@interface TCOrderItem : NSObject

/** 产品数量 */
@property (nonatomic) NSInteger amount;
/** 产品信息 */
@property (retain, nonatomic) TCGoods *goods;
/** 购物车商品ID */
@property (retain, nonatomic) NSString *ID;


@end
