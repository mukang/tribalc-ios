//
//  TCPaymentViewController.h
//  individual
//
//  Created by 穆康 on 2017/6/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBuluoApi.h"
@class TCPaymentViewController;

@protocol TCPaymentViewControllerDelegate <NSObject>

@optional
- (void)paymentViewController:(TCPaymentViewController *)controller didFinishedPaymentWithPayment:(TCUserPayment *)payment;
- (void)didClickCloseButtonInPaymentViewController:(TCPaymentViewController *)controller;

@end

/**
 付款页面
 */
@interface TCPaymentViewController : UIViewController

/** 总金额 */
@property (nonatomic, readonly) double totalFee;
/** 付款目的 */
@property (nonatomic, readonly) TCPayPurpose payPurpose;

/** 订单ID数组
 （payPurpose为TCPayPurposeOrder时，必填） */
@property (copy, nonatomic) NSArray *orderIDs;
/** 目标商户ID
 （payPurpose为TCPayPurposeFace2Face时，必填） */
@property (copy, nonatomic) NSString *targetID;

@property (weak, nonatomic) id<TCPaymentViewControllerDelegate> delegate;

/**
 指定初始化方法

 @param totalFee 总金额
 @param payPurpose 付款目的
 @param controller 来自于哪个控制器
 @return 付款页面控制器
 */
- (instancetype)initWithTotalFee:(double)totalFee payPurpose:(TCPayPurpose)payPurpose fromController:(UIViewController *)controller;

/**
 显示付款页面
 
 @param animated 是否需要动画
 */
- (void)show:(BOOL)animated;

/**
 退出付款页面
 
 @param animated 是否需要动画
 @param completion 完成退出后的回调
 */
- (void)dismiss:(BOOL)animated completion:(void (^)())completion;

@end
