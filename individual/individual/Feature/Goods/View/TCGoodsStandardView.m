//
//  TCGoodsStandardView.m
//  individual
//
//  Created by 穆康 on 2017/9/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandardView.h"

@interface TCGoodsStandardView ()

@property (strong, nonatomic) TCGoodsStandard *goodsStandard;

@end

@implementation TCGoodsStandardView

- (instancetype)initWithGoodsStandard:(TCGoodsStandard *)goodsStandard {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _goodsStandard = goodsStandard;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *containerView = [[UIView alloc] init];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(TCScreenWidth);
        make.edges.equalTo(self);
    }];
    
    if (!_goodsStandard) {
        
    } else {
        TCGoodsStandardDescriptions *descriptions = _goodsStandard.descriptions;
        
        TCGoodsStandardUnitsView *primaryView = [[TCGoodsStandardUnitsView alloc] initWithUnitsLevel:TCGoodsStandardUnitsLevelPrimary goodsStandard:_goodsStandard];
        [containerView addSubview:primaryView];
        self.primaryView = primaryView;
        
        [primaryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(containerView);
        }];
        
        if (descriptions.secondary) {
            TCGoodsStandardUnitsView *secondaryView = [[TCGoodsStandardUnitsView alloc] initWithUnitsLevel:TCGoodsStandardUnitsLevelSecondary goodsStandard:_goodsStandard];
            [containerView addSubview:secondaryView];
            self.secondaryView = secondaryView;
            
            [secondaryView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(primaryView.mas_bottom);
                make.left.right.bottom.equalTo(containerView);
            }];
        } else {
            [primaryView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(containerView);
            }];
        }
    }
}

@end
