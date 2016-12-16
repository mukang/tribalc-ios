//
//  TCShoppingCartBaseInfoView.h
//  individual
//
//  Created by WYH on 16/12/8.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//
#import "TCModelImport.h"
#import <UIKit/UIKit.h>

@interface TCShoppingCartBaseInfoView : UIView

@property (retain, nonatomic) UILabel *titleLab;

@property (retain, nonatomic) UILabel *primaryStandardLab;

@property (retain, nonatomic) UILabel *sendondaryStandardLab;

@property (retain, nonatomic) UILabel *amountLab;

@property (retain, nonatomic) UILabel *priceLab;

@property (retain, nonatomic) TCCartItem *mCartItem;

@property (copy, nonatomic) NSString *shoppingCartGoodsId;

- (instancetype)initNormalViewWithFrame:(CGRect)frame AndSelectTag:(NSString *)selectTag AndCartItem:(TCCartItem *)cartItem;
- (instancetype)initEditViewWithFrame:(CGRect)frame AndSelectTag:(NSString *)selectTag AndCartItem:(TCCartItem *)cartItem;

- (void)setupAmountLab:(NSInteger)amount;
- (void)setupEditPriceLab:(CGFloat)price;
- (void)setupEditAmount:(NSInteger)amount;
- (void)setupNormalPriceLab:(CGFloat)price;
- (void)setupStandard:(NSString *)standard;

@end
