//
//  TCShippingAddressEditViewController.h
//  individual
//
//  Created by 穆康 on 2016/11/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCCommonLibs/TCBaseViewController.h>
@class TCUserShippingAddress;

typedef NS_ENUM(NSInteger, TCShippingAddressType) {
    TCShippingAddressTypeAdd,
    TCShippingAddressTypeEdit
};

typedef void(^TCShippingAddressBlock)(TCShippingAddressType shippingAddressType, TCUserShippingAddress *newShippingAddress);

@interface TCShippingAddressEditViewController : TCBaseViewController

@property (nonatomic) TCShippingAddressType shippingAddressType;
@property (strong, nonatomic) TCUserShippingAddress *shippingAddress;
@property (copy, nonatomic) TCShippingAddressBlock shippingAddressBlock;

@end
