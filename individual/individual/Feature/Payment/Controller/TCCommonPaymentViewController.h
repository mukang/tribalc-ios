//
//  TCCommonPaymentViewController.h
//  individual
//
//  Created by 穆康 on 2017/9/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//


#import <TCCommonLibs/TCBaseViewController.h>

typedef NS_ENUM(NSInteger, TCCommonPaymentMode) {
    TCCommonPaymentModeRecharge = 0,
    TCCommonPaymentModeRepayment,
    TCCommonPaymentModeCompanyRepayment
};

@interface TCCommonPaymentViewController : TCBaseViewController

@property (nonatomic, readonly) TCCommonPaymentMode paymentMode;

- (instancetype)initWithPaymentMode:(TCCommonPaymentMode)paymentMode;

@end
