//
//  TCBankPickerViewController.h
//  individual
//
//  Created by 穆康 on 2017/7/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#import "TCBankCard.h"

typedef NS_ENUM(NSInteger, TCBankPickerType) {
    TCBankPickerTypeAddBankCard, // 添加银行卡
    TCBankPickerTypeAddWithhold  // 添加代扣信息
};

@protocol TCBankPickerViewControllerDelegate;
@interface TCBankPickerViewController : TCBaseViewController

@property (nonatomic, readonly) TCBankPickerType bankPikerType;
@property (weak, nonatomic) id<TCBankPickerViewControllerDelegate> delegate;

@property (copy, nonatomic) NSArray *banks;

/**
 指定初始化方法

 @param type 银行选择器类型
 @param controller 来自于哪个控制器
 @return 银行选择器
 */
- (instancetype)initWithBankPickerType:(TCBankPickerType)type fromController:(UIViewController *)controller;

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


@protocol TCBankPickerViewControllerDelegate <NSObject>

@optional
- (void)bankPickerViewController:(TCBankPickerViewController *)controller didClickConfirmButtonWithBankCard:(TCBankCard *)bankCard;
- (void)didClickCancelButtonInBankPickerViewController:(TCBankPickerViewController *)controller;

@end
