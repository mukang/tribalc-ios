//
//  TCOrderViewController.h
//  individual
//
//  Created by 穆康 on 2017/2/15.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBaseViewController.h"

typedef NS_ENUM(NSInteger, TCGoodsOrderStatus) {
    TCGoodsOrderStatusAll,
    TCGoodsOrderStatusWaitPayment,
    TCGoodsOrderStatusWaitGoods,
    TCGoodsOrderStatusCompletion,
};

@interface TCOrderViewController : TCBaseViewController

@property (weak, nonatomic) UIViewController *fromController;
@property (nonatomic, readonly) TCGoodsOrderStatus goodsOrderStatus;
- (instancetype)initWithGoodsOrderStatus:(TCGoodsOrderStatus)goodsOrderStatus;

@end
