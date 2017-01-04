//
//  TCPaymentMethodView.h
//  individual
//
//  Created by 穆康 on 2017/1/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCPaymentMethodViewDelegate;

typedef NS_ENUM(NSInteger, TCPaymentMethod) {
    TCPaymentMethodBalance = 0,
    TCPaymentMethodWechat,
    TCPaymentMethodAlipay
};



@interface TCPaymentMethodView : UIView

@property (nonatomic, readonly) TCPaymentMethod paymentMethod;
@property (weak, nonatomic) id<TCPaymentMethodViewDelegate> delegate;

- (instancetype)initWithPaymentMethod:(TCPaymentMethod)paymentMethod;

@end




@protocol TCPaymentMethodViewDelegate <NSObject>

@optional
- (void)paymentMethodView:(TCPaymentMethodView *)view didSlectedPaymentMethod:(TCPaymentMethod)paymentMethod;
- (void)didClickBackButtonInPaymentMethodView:(TCPaymentMethodView *)view;

@end
