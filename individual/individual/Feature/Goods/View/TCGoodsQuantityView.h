//
//  TCGoodsQuantityView.h
//  individual
//
//  Created by 穆康 on 2017/9/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCGoodsQuantityView : UIView

@property (weak, nonatomic) UIButton *minusButton;
@property (weak, nonatomic) UIButton *addButton;

@property (nonatomic) NSInteger quantity;

@end
