//
//  TCOrderDetailViewController.h
//  individual
//
//  Created by 穆康 on 2017/2/15.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBaseViewController.h"
@class TCOrder;

typedef void(^TCOrderStatusChangeBlock)(TCOrder *goodsOrder);

@interface TCOrderDetailViewController : TCBaseViewController

@property (strong, nonatomic) TCOrder *goodsOrder;
@property (copy, nonatomic) TCOrderStatusChangeBlock statusChangeBlock;

@end
