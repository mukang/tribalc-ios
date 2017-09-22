//
//  TCPaymentMethodsSelectView.h
//  individual
//
//  Created by 穆康 on 2017/9/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCPaymentMethodModel.h"

typedef NS_ENUM(NSInteger, TCBackButtonStyle) {
    TCBackButtonStyleLeftArrow,  // 向左的箭头
    TCBackButtonStyleClose       // 叉号
};

@protocol TCPaymentMethodsSelectViewDelegate;
@interface TCPaymentMethodsSelectView : UIView

@property (nonatomic) BOOL hideAddBankCardItem;
@property (weak, nonatomic) id<TCPaymentMethodsSelectViewDelegate> delegate;

- (instancetype)initWithPaymentMethodModels:(NSArray *)methodModels backButtonStyle:(TCBackButtonStyle)backButtonStyle;

@end

@protocol TCPaymentMethodsSelectViewDelegate <NSObject>

@optional
- (void)paymentMethodsSelectView:(TCPaymentMethodsSelectView *)view didSlectedMethod:(TCPaymentMethodModel *)methodModel;
- (void)didClickBackButtonInPaymentMethodsSelectView:(TCPaymentMethodsSelectView *)view;
- (void)didClickAddBankCardInPaymentMethodsSelectView:(TCPaymentMethodsSelectView *)view;

@end

