//
//  TCShippingAddressViewController.h
//  individual
//
//  Created by 穆康 on 2016/11/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBaseViewController.h"

typedef void(^TCDefaultShippingAddressChangeBlock)(BOOL isChange);

@interface TCShippingAddressViewController : TCBaseViewController

@property (copy, nonatomic) TCDefaultShippingAddressChangeBlock defaultShippingAddressChangeBlock;

- (instancetype)initPlaceOrderAddressSelect;


@end
