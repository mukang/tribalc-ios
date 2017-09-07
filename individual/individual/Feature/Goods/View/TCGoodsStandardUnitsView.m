//
//  TCGoodsStandardUnitsView.m
//  individual
//
//  Created by 穆康 on 2017/9/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandardUnitsView.h"
#import "TCGoodsStandardUnitView.h"
#import "TCGoodsDetail.h"

@interface TCGoodsStandardUnitsView ()

@property (strong, nonatomic) TCGoodsStandard *goodsStandard;
@property (strong, nonatomic) NSMutableArray *views;

@property (weak, nonatomic) TCGoodsStandardUnitView *selectedUnitView;

@end

@implementation TCGoodsStandardUnitsView

- (instancetype)initWithUnitsLevel:(TCGoodsStandardUnitsLevel)level goodsStandard:(TCGoodsStandard *)goodsStandard {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _unitsLevel = level;
        _goodsStandard = goodsStandard;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    TCGoodsStandardUnits *units = (_unitsLevel == TCGoodsStandardUnitsLevelPrimary) ? _goodsStandard.descriptions.primary : _goodsStandard.descriptions.secondary;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = units.label;
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self addSubview:lineView];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(20);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self);
    }];
    
    CGFloat padding = 20.0, marginH = 12.0, marginV = 12.0, tempMaxX = 0;
    TCGoodsStandardUnitView *lastView = nil;
    
    for (int i=0; i<units.types.count; i++) {
        TCGoodsStandardUnitView *unitView = [[TCGoodsStandardUnitView alloc] init];
        unitView.title = units.types[i];
        [self addSubview:unitView];
        [self.views addObject:unitView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapStandardUnitView:)];
        [unitView addGestureRecognizer:tap];
        
        if (lastView == nil) {
            tempMaxX = padding + unitView.realWidth;
            [unitView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(padding);
                make.top.equalTo(titleLabel.mas_bottom).offset(padding);
            }];
        } else {
            tempMaxX += (marginH + unitView.realWidth);
            if (tempMaxX <= TCScreenWidth - padding) {
                [unitView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView);
                    make.left.equalTo(lastView.mas_right).offset(marginH);
                }];
            } else {
                tempMaxX = padding + unitView.realWidth;
                [unitView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastView.mas_bottom).offset(marginV);
                    make.left.equalTo(self).offset(padding);
                }];
            }
        }
        
        lastView = unitView;
    }
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineView.mas_top).offset(-20);
    }];
}

- (void)reloadStandardDataWithAnotherKey:(NSString *)anotherKey {
    for (int i=0; i<self.views.count; i++) {
        TCGoodsStandardUnitView *unitView = self.views[i];
        NSString *key = nil;
        if (anotherKey) {
            if (self.unitsLevel == TCGoodsStandardUnitsLevelPrimary) {
                key = [NSString stringWithFormat:@"%@^%@", unitView.title, anotherKey];
            } else {
                key = [NSString stringWithFormat:@"%@^%@", anotherKey, unitView.title];
            }
        } else {
            key = unitView.title;
        }
        
        TCGoodsDetail *goodsDetail = [self.goodsStandard.goodsIndexes objectForKey:key];
        NSInteger repertory = goodsDetail.repertory;
        if (repertory) {
            if ([unitView.title isEqualToString:self.currentKey]) {
                unitView.type = TCGoodsStandardUnitViewTypeSelected;
                self.selectedUnitView = unitView;
            } else {
                unitView.type = TCGoodsStandardUnitViewTypeNormal;
            }
        } else {
            unitView.type = TCGoodsStandardUnitViewTypeDisabled;
        }
    }
}

- (void)handleTapStandardUnitView:(UITapGestureRecognizer *)gesture {
    TCGoodsStandardUnitView *unitView = (TCGoodsStandardUnitView *)gesture.view;
    if (unitView.type == TCGoodsStandardUnitViewTypeNormal) {
        self.selectedUnitView.type = TCGoodsStandardUnitViewTypeNormal;
        unitView.type = TCGoodsStandardUnitViewTypeSelected;
        self.selectedUnitView = unitView;
        self.currentKey = unitView.title;
        if ([self.delegate respondsToSelector:@selector(goodsStandardUnitsView:didSelectUnitWithKey:)]) {
            [self.delegate goodsStandardUnitsView:self didSelectUnitWithKey:unitView.title];
        }
    }
}

- (NSMutableArray *)views {
    if (_views == nil) {
        _views = [NSMutableArray array];
    }
    return _views;
}

@end
