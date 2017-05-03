//
//  TCPaymentView.h
//  individual
//
//  Created by 穆康 on 2016/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCWalletAccount.h"
#import "TCBuluoApi.h"
@class TCPaymentView;

@protocol TCPaymentViewDelegate <NSObject>

@optional
- (void)paymentView:(TCPaymentView *)view didFinishedPaymentWithStatus:(NSString *)status;
- (void)didClickCloseButtonInPaymentView:(TCPaymentView *)view;

@end



/**
 支付页面，显示支付页面前需要先调用接口：获取用户钱包信息
 */
@interface TCPaymentView : UIView

/** 总金额 */
@property (nonatomic, readonly) double totalFee;
/** 订单ID数组（类型为商品时，必填） */
@property (copy, nonatomic) NSArray *orderIDs;
/** 付款目的 */
@property (nonatomic) TCPayPurpose payPurpose;

@property (weak, nonatomic) id<TCPaymentViewDelegate> delegate;

/**
 指定初始化方法

 @param totalFee 总金额
 @param controller 源控制器
 @return 返回TCPaymentView对象
 */
- (instancetype)initWithTotalFee:(double)totalFee fromController:(UIViewController *)controller;

/**
 显示付款页面

 @param animated 是否需要动画
 */
- (void)show:(BOOL)animated;

/**
 退出付款页面

 @param animated 是否需要动画
 */
- (void)dismiss:(BOOL)animated;

/**
 退出付款页面

 @param animated 是否需要动画
 @param completion 完成退出后的回调
 */
- (void)dismiss:(BOOL)animated completion:(void (^)())completion;

@end
