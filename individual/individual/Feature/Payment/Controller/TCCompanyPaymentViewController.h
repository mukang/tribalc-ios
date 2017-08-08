//
//  TCCompanyPaymentViewController.h
//  individual
//
//  Created by 穆康 on 2017/8/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#import "TCBuluoApi.h"
@class TCCompanyPaymentViewController;

@protocol TCCompanyPaymentViewControllerDelegate <NSObject>

@optional
- (void)companyPaymentViewController:(TCCompanyPaymentViewController *)controller didFinishedPaymentWithPayment:(TCUserPayment *)payment;
- (void)didClickCloseButtonInCompanyPaymentViewController:(TCCompanyPaymentViewController *)controller;

@end

@interface TCCompanyPaymentViewController : TCBaseViewController

/** 总金额 */
@property (nonatomic, readonly) double totalFee;
/** 付款目的 */
@property (nonatomic, readonly) TCPayPurpose payPurpose;
/** 目标商户ID
 （payPurpose为TCPayPurposeFace2Face和TCPayPurposeRent时，必填；
 当为TCPayPurposeRent时，targetID是租赁协议ID） */
@property (copy, nonatomic) NSString *targetID;
/** 传企业id */
@property (copy, nonatomic) NSString *companyID;

@property (weak, nonatomic) id<TCCompanyPaymentViewControllerDelegate> delegate;

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
