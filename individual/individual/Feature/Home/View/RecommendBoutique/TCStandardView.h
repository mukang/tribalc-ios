//
//  TCStandardView.h
//  individual
//
//  Created by WYH on 16/11/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCModelImport.h"
#import "TCComponent.h"
#import "TCClientConfig.h"
#import "UIImageView+WebCache.h"

@interface TCStandardView : UIView <SDWebImageManagerDelegate>

@property UILabel *priceLab;
@property UIImageView *selectedImgView;
@property UILabel *selectedGoodStyleLab;
@property UILabel *selectedGoodSizeLab;
@property UILabel *inventoryLab;
@property UILabel *numberLab;


- (void)startSelectStandard;
- (void)endSelectStandard;


- (instancetype)initWithTarget:(id)target AndNumberAddAction:(SEL)addAction AndNumberSubAction:(SEL)subAction AndAddShopCarAction:(SEL)addShoppngCartAction AndGoCartAction:(SEL)addCartAction AndBuyAction:(SEL)buyAction AndCloseAction:(SEL)closeAction;

- (void)setSalePriceAndInventoryWithSalePrice:(float)salePrice AndInventory:(NSInteger)inventory AndImgUrlStr:(NSString *)urlStr;
- (void)setStandardSelectViewWithStandard:(TCGoodStandards *)standard AndPrimaryAction:(SEL)primaryAction AndSeconedAction:(SEL)seconedAction AndTarget:(id)target;

- (void)setSelectedPrimaryStandardWithText:(NSString *)text;
- (void)setSelectedSeconedStandardWithText:(NSString *)text;
- (void)setGoodStyle:(NSString *)style;
- (void)setGoodSize:(NSString *)goodSize;

@end
