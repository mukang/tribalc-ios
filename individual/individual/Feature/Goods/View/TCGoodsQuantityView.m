//
//  TCGoodsQuantityView.m
//  individual
//
//  Created by 穆康 on 2017/9/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsQuantityView.h"

@interface TCGoodsQuantityView ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *quantityLabel;

@end

@implementation TCGoodsQuantityView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"数量";
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:titleLabel];
    
    UIButton *minusButton = [self createButtonWithTitle:@"-"];
    [self addSubview:minusButton];
    
    UIButton *addButton = [self createButtonWithTitle:@"+"];
    [self addSubview:addButton];
    
    UILabel *quantityLabel = [[UILabel alloc] init];
    quantityLabel.textColor = TCBlackColor;
    quantityLabel.textAlignment = NSTextAlignmentCenter;
    quantityLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:quantityLabel];
    
    self.titleLabel = titleLabel;
    self.minusButton = minusButton;
    self.addButton = addButton;
    self.quantityLabel = quantityLabel;
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
    }];
    [self.minusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.equalTo(self.addButton.mas_left).offset(-50);
        make.centerY.equalTo(self);
    }];
    [self.quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minusButton.mas_right);
        make.right.equalTo(self.addButton.mas_left);
        make.centerY.equalTo(self);
    }];
}

- (void)setQuantity:(NSInteger)quantity {
    _quantity = quantity;
    
    self.quantityLabel.text = [NSString stringWithFormat:@"%zd", quantity];
    
    if (quantity > 1) {
        self.minusButton.enabled = YES;
    } else {
        self.minusButton.enabled = NO;
    }
}

- (UIButton *)createButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:TCGrayColor forState:UIControlStateNormal];
    [button setTitleColor:TCLightGrayColor forState:UIControlStateHighlighted];
    [button setTitleColor:TCSeparatorLineColor forState:UIControlStateDisabled];
    button.backgroundColor = TCBackgroundColor;
    button.layer.cornerRadius = 2.5;
    button.layer.masksToBounds = YES;
    return button;
}


@end
