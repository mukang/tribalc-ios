//
//  TCOrderCreateItem.h
//  individual
//
//  Created by 穆康 on 2017/9/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCOrderCreateItem : NSObject

/** 商品数量 */
@property (nonatomic) NSInteger amount;
/** 商品ID */
@property (copy, nonatomic) NSString *goodsId;
/** 购物车商品ID */
@property (copy, nonatomic) NSString *shoppingCartGoodsId;
/** 订单备注 */
@property (copy, nonatomic) NSString *note;

@end
