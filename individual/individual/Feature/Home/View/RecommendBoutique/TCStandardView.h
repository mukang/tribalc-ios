//
//  TCStandardView.h
//  individual
//
//  Created by WYH on 16/11/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCComponent.h"

@interface TCStandardView : UIView

@property UILabel *priceLab;
@property UIImageView *selectedImgView;
@property UILabel *selectedGoodStyleLab;
@property UILabel *selectedGoodSizeLab;
@property UILabel *inventoryLab;
@property UILabel *numberLab;

- (void)startSelectStandard;
- (void)endSelectStandard ;
- (void)modifyInventoryLabel;

- (instancetype)initWithData:(NSDictionary *)data AndTarget:(id)target AndStyleAction:(SEL)styleAction AndSizeAction:(SEL)sizeAction AndCloseAction:(SEL)closeAction AndNumberAddAction:(SEL)addAction AndNumberSubAction:(SEL)subAction AndAddShoppingCartAction:(SEL)addCartAction AndBuyAction:(SEL)buyAction;
- (void)setGoodStyle:(NSString *)style;
- (void)setGoodSize:(NSString *)goodSize;

@end
