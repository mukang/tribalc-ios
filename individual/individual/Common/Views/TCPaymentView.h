//
//  TCPaymentView.h
//  individual
//
//  Created by 穆康 on 2016/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCPaymentView : UIView

/**
 指定初始化方法

 @param amount 付款金额
 @param controller 源控制器
 @return 返回TCPhotoPicker对象
 */
- (instancetype)initWithAmount:(CGFloat)amount fromController:(UIViewController *)controller;

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

@end
