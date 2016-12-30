//
//  TCRechargeMethodsView.h
//  individual
//
//  Created by 穆康 on 2016/12/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCRechargeMethodsViewDelegate;

typedef NS_ENUM(NSInteger, TCRechargeMethod) {
    TCRechargeMethodWechat,
    TCRechargeMethodAlipay
};

@interface TCRechargeMethodsView : UIView

@property (nonatomic) TCRechargeMethod rechargeMethod;
@property (weak, nonatomic) id<TCRechargeMethodsViewDelegate> delegate;

@end

@protocol TCRechargeMethodsViewDelegate <NSObject>

@optional
- (void)rechargeMethodsView:(TCRechargeMethodsView *)view didSelectedMethodButtonWithMethod:(TCRechargeMethod)rechargeMethod;

@end
