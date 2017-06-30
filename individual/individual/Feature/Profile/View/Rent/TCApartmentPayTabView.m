//
//  TCApartmentPayTabView.m
//  individual
//
//  Created by 穆康 on 2017/6/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCApartmentPayTabView.h"

@interface TCApartmentPayTabView ()

@property (weak, nonatomic) UIView *verticalLine;
@property (weak, nonatomic) UIView *bottomLine;
@property (weak, nonatomic) UIButton *rentPayButton;
@property (weak, nonatomic) UIButton *lifePayButton;

@end

@implementation TCApartmentPayTabView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:verticalLine];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:bottomLine];
    
    UIButton *rentPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rentPayButton setTitle:@"房租缴费" forState:UIControlStateNormal];
    [rentPayButton.titleLabel setFont:[UIFont systemFontOfSize:TCRealValue(14)]];
    [rentPayButton setTitleColor:TCLightGrayColor forState:UIControlStateNormal];
    [rentPayButton setTitleColor:TCBlackColor forState:UIControlStateSelected];
    [rentPayButton addTarget:self action:@selector(handleClickRentPayButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:rentPayButton];
    
    UIButton *lifePayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [lifePayButton setTitle:@"生活缴费" forState:UIControlStateNormal];
    [lifePayButton.titleLabel setFont:[UIFont systemFontOfSize:TCRealValue(14)]];
    [lifePayButton setTitleColor:TCLightGrayColor forState:UIControlStateNormal];
    [lifePayButton setTitleColor:TCBlackColor forState:UIControlStateSelected];
    [lifePayButton addTarget:self action:@selector(handleClickLifePayButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:lifePayButton];
    
    self.verticalLine = verticalLine;
    self.bottomLine = bottomLine;
    self.rentPayButton = rentPayButton;
    self.lifePayButton = lifePayButton;
}

- (void)setupConstraints {
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(2);
        make.bottom.equalTo(self).offset(-2);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.bottom.right.equalTo(self);
    }];
    [self.rentPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self.bottomLine.mas_top);
        make.right.equalTo(self.verticalLine.mas_left).offset(-20);
    }];
    [self.lifePayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.verticalLine.mas_right).offset(20);
        make.bottom.equalTo(self.bottomLine.mas_top);
        make.right.equalTo(self).offset(-20);
    }];
}

- (void)clickApartmentPayTabWithType:(TCApartmentPayType)type {
    if (type == TCApartmentPayTypeRent) {
        [self handleClickRentPayButton:nil];
    } else {
        [self handleClickLifePayButton:nil];
    }
}

- (void)handleClickRentPayButton:(id)sender {
    if (self.rentPayButton.selected) return;
    
    self.rentPayButton.selected = YES;
    self.lifePayButton.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(apartmentPayTabView:didClickTabWithType:)]) {
        [self.delegate apartmentPayTabView:self didClickTabWithType:TCApartmentPayTypeRent];
    }
}

- (void)handleClickLifePayButton:(id)sender {
    if (self.lifePayButton.selected) return;
    
    self.lifePayButton.selected = YES;
    self.rentPayButton.selected = NO;
    
    if ([self.delegate respondsToSelector:@selector(apartmentPayTabView:didClickTabWithType:)]) {
        [self.delegate apartmentPayTabView:self didClickTabWithType:TCApartmentPayTypeLife];
    }
}

@end
