//
//  TCShoppingCartBaseInfoView.h
//  individual
//
//  Created by WYH on 16/12/8.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCShoppingCartBaseInfoView : UIView

@property (retain, nonatomic) UILabel *titleLab;

@property (retain, nonatomic) UILabel *primaryStandardLab;

@property (retain, nonatomic) UILabel *sendondaryStandardLab;

@property (retain, nonatomic) UILabel *amountLab;

@property (retain, nonatomic) UILabel *priceLab;

@property (copy, nonatomic) NSString *goodsId;

@property (copy, nonatomic) NSString *shoppingCartGoodsId;

- (instancetype)initNormalViewWithFrame:(CGRect)frame AndSelectTag:(NSString *)selectTag AndGoodsId:(NSString *)goodsId;
- (instancetype)initEditViewWithFrame:(CGRect)frame AndSelectTag:(NSString *)selectTag AndGoodsId:(NSString *)goodsId;

- (void)setupAmountLab:(NSInteger)amount;
- (void)setupEditPriceLab:(CGFloat)price;
- (void)setupEditAmount:(NSInteger)amount;
- (void)setupNormalPriceLab:(CGFloat)price;
- (void)setupStandard:(NSString *)standard;

@end
