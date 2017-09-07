//
//  TCGoodsStandardViewController.h
//  individual
//
//  Created by 穆康 on 2017/9/5.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#import "TCGoodsDetail.h"
#import "TCGoodsStandard.h"

typedef NS_ENUM(NSInteger, TCGoodsStandardViewMode) {
    TCGoodsStandardViewModeConfirm = 0, // 底部是确定按钮
    TCGoodsStandardViewModeSelect       // 底部是加入购物车和立即购买按钮
};

typedef NS_ENUM(NSInteger, TCGoodsStandardConfirmType) {
    TCGoodsStandardConfirmTypeAddShoppingCart = 0, // 点击确定执行加入购物车操作
    TCGoodsStandardConfirmTypeBuyNow               // 点击确定执行立即购买操作
};

@interface TCGoodsStandardViewController : TCBaseViewController

@property (copy, nonatomic) NSString *currentStandardKey;
@property (strong, nonatomic) TCGoodsDetail *goodsDetail;
@property (strong, nonatomic) TCGoodsStandard *goodsStandard;
/** 规格页面风格（分为“确定”和“选择加入购物车或立即购买”） */
@property (nonatomic, readonly) TCGoodsStandardViewMode standardViewMode;
/** 点击确认按钮后需执行的操作（standardViewMode为TCGoodsStandardViewModeConfirm时有效） */
@property (nonatomic) TCGoodsStandardConfirmType comfirmType;

/**
 指定初始化方法

 @param mode 规格页面风格（分为“确定”和“选择加入购物车或立即购买”）
 @param controller 来自于哪个控制器
 @return 选择规格控制器
 */
- (instancetype)initWithStandardViewMode:(TCGoodsStandardViewMode)mode fromController:(UIViewController *)controller;

/**
 显示页面
 
 @param animated 是否需要动画
 */
- (void)show:(BOOL)animated;

/**
 退出页面
 
 @param animated 是否需要动画
 @param completion 完成退出后的回调
 */
- (void)dismiss:(BOOL)animated completion:(void (^)())completion;

@end
