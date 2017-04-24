//
//  TCPaymentBankCardView.h
//  individual
//
//  Created by 穆康 on 2017/4/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCBankCard;
@protocol TCPaymentBankCardViewDelegate;

@interface TCPaymentBankCardView : UIView

@property (strong, nonatomic, readonly) TCBankCard *bankCard;
@property (weak, nonatomic) id<TCPaymentBankCardViewDelegate> delegate;

- (instancetype)initWithBankCard:(TCBankCard *)bankCard;

@end


@protocol TCPaymentBankCardViewDelegate <NSObject>

@optional
- (void)didClickBackButtonInBankCardView:(TCPaymentBankCardView *)view;


@end
