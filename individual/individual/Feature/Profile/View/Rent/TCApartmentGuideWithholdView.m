//
//  TCApartmentGuideWithholdView.m
//  individual
//
//  Created by 穆康 on 2017/6/29.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCApartmentGuideWithholdView.h"

@implementation TCApartmentGuideWithholdView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:bottomLine];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"添加代扣信息";
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:TCRealValue(14)];
    [self addSubview:titleLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"indicating_arrow"]];
    [self addSubview:arrowImageView];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.left.right.equalTo(self);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.bottom.left.right.equalTo(self);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(10.5), TCRealValue(18.5)));
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
    }];
}

@end
