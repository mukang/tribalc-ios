//
//  TCCommonPaymentMethodView.h
//  individual
//
//  Created by 穆康 on 2017/9/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCPaymentEnum.h"
#import "TCPaymentMethodModel.h"

@interface TCCommonPaymentMethodView : UIView

@property (nonatomic, readonly) TCCommonPaymentPurpose paymentPurpose;
@property (strong, nonatomic) TCPaymentMethodModel *methodModel;

- (instancetype)initWithPaymentPurpose:(TCCommonPaymentPurpose)paymentPurpose;

@end
