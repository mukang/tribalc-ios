//
//  TCPaymentMethodView.h
//  individual
//
//  Created by 穆康 on 2017/1/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCBankCard;
@protocol TCPaymentMethodViewDelegate;

typedef NS_ENUM(NSInteger, TCPaymentMethod) {
    TCPaymentMethodBalance = 0,
//    TCPaymentMethodWechat,
//    TCPaymentMethodAlipay,
    TCPaymentMethodBankCard
};



@interface TCPaymentMethodView : UIView

@property (nonatomic, readonly) TCPaymentMethod paymentMethod;
@property (weak, nonatomic) id<TCPaymentMethodViewDelegate> delegate;

/** 当前的银行卡信息（付款方式为TCPaymentMethodBankCard时必传） */
@property (strong, nonatomic) TCBankCard *currentBankCard;
/** 银行卡列表(需要先设置currentBankCard) */
@property (copy, nonatomic) NSArray *bankCardList;

- (instancetype)initWithPaymentMethod:(TCPaymentMethod)paymentMethod;

@end




@protocol TCPaymentMethodViewDelegate <NSObject>

@optional
- (void)paymentMethodView:(TCPaymentMethodView *)view didSlectedPaymentMethod:(TCPaymentMethod)paymentMethod;
- (void)didClickBackButtonInPaymentMethodView:(TCPaymentMethodView *)view;

@end
