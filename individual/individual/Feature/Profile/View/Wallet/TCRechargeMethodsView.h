//
//  TCRechargeMethodsView.h
//  individual
//
//  Created by 穆康 on 2016/12/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCBankCard;
@protocol TCRechargeMethodsViewDelegate;

typedef NS_ENUM(NSInteger, TCRechargeMethod) {
//    TCRechargeMethodWechat,
//    TCRechargeMethodAlipay
    TCRechargeMethodBankCard = 0,
};

@interface TCRechargeMethodsView : UIView

@property (nonatomic) TCRechargeMethod rechargeMethod;

@property (strong, nonatomic) TCBankCard *currentBankCard;
@property (copy, nonatomic) NSArray *bankCardList;

@property (weak, nonatomic) id<TCRechargeMethodsViewDelegate> delegate;

- (void)reloadBankCardList;

@end


@protocol TCRechargeMethodsViewDelegate <NSObject>

@optional
- (void)didSelectedAddBankCardInRechargeMethodsView:(TCRechargeMethodsView *)view;

@end
