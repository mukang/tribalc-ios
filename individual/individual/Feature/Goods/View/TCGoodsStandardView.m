//
//  TCGoodsStandardView.m
//  individual
//
//  Created by 穆康 on 2017/9/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandardView.h"
#import "TCGoodsStandardUnitsView.h"

@interface TCGoodsStandardView ()

@property (strong, nonatomic) TCGoodsStandard *goodsStandard;

@property (weak, nonatomic) TCGoodsStandardUnitsView *primaryView;
@property (weak, nonatomic) TCGoodsStandardUnitsView *secondaryView;

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
    
    TCGoodsStandardDescriptions *descriptions = self.goodsStandard.descriptions;
    if (descriptions.primary) {
        TCGoodsStandardUnitsView *primaryView = [[TCGoodsStandardUnitsView alloc] initWithUnitsLevel:TCGoodsStandardUnitsLevelPrimary goodsStandard:self.goodsStandard];
        [containerView addSubview:primaryView];
        self.primaryView = primaryView;
        
        [primaryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(containerView);
        }];
    }
    
    if (descriptions.secondary) {
        TCGoodsStandardUnitsView *secondaryView = [[TCGoodsStandardUnitsView alloc] initWithUnitsLevel:TCGoodsStandardUnitsLevelSecondary goodsStandard:self.goodsStandard];
        [containerView addSubview:secondaryView];
        self.secondaryView = secondaryView;
        
        [secondaryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.primaryView.mas_bottom);
            make.left.right.bottom.equalTo(containerView);
        }];
    } else {
        [self.primaryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(containerView);
        }];
    }
}

- (void)reloadStandarDataWithCurrentStandardKey:(NSString *)currentStandardKey {
    if (self.primaryView) {
        [self.primaryView reloadDataWithCurrentStandardKey:currentStandardKey];
        
        if (self.secondaryView) {
            [self.secondaryView reloadDataWithCurrentStandardKey:currentStandardKey];
        }
    }
}

@end
