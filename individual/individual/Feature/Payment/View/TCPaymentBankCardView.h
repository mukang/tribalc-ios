//
//  TCPaymentBankCardView.h
//  individual
//
//  Created by 穆康 on 2017/4/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLBPasswordTextField.h"
@class TCBankCard;
@protocol TCPaymentBankCardViewDelegate;

@interface TCPaymentBankCardView : UIView

@property (weak, nonatomic) MLBPasswordTextField *codeTextField;
@property (strong, nonatomic, readonly) TCBankCard *bankCard;
@property (weak, nonatomic) id<TCPaymentBankCardViewDelegate> delegate;

- (instancetype)initWithBankCard:(TCBankCard *)bankCard;

- (void)startCountDown;
- (void)stopCountDown;

@end


@protocol TCPaymentBankCardViewDelegate <NSObject>

@optional
- (void)didClickBackButtonInBankCardView:(TCPaymentBankCardView *)view;
- (void)didClickFetchCodeButtonInBankCardView:(TCPaymentBankCardView *)view;
- (void)bankCardView:(TCPaymentBankCardView *)view didClickConfirmButtonWithCode:(NSString *)code;

@end
