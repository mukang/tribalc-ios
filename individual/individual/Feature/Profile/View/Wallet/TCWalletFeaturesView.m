//
//  TCWalletFeaturesView.m
//  individual
//
//  Created by 穆康 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletFeaturesView.h"

#define defaultTag 666

@interface TCWalletFeaturesView ()

@property (copy, nonatomic) NSArray *materialArray;
@property (strong, nonatomic) NSMutableArray *buttons;

@end

@implementation TCWalletFeaturesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    CGFloat padding = TCRealValue(15);
    CGFloat bottomPadding = TCRealValue(12);
    CGFloat margin = 0.5;
    UIButton *lastButton = nil;
    
    for (int i=0; i<9; i++) {
        NSDictionary *dic = self.materialArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:dic[@"title"] forState:UIControlStateNormal];
        [button setTitleColor:TCBlackColor forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setImage:[UIImage imageNamed:dic[@"imageName"]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleClickFeatureButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = defaultTag + i;
        [self addSubview:button];
        [self.buttons addObject:button];
        
        if (lastButton) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(lastButton);
                if (i % 3 == 0) {
                    make.left.equalTo(self).offset(padding);
                    make.top.equalTo(lastButton.mas_bottom).offset(margin);
                } else if (i % 3 == 1) {
                    make.left.equalTo(lastButton.mas_right).offset(margin);
                    make.top.equalTo(lastButton);
                } else {
                    make.left.equalTo(lastButton.mas_right).offset(margin);
                    make.right.equalTo(self).offset(-padding);
                    make.top.equalTo(lastButton);
                }
            }];
        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(padding);
                make.left.equalTo(self).offset(padding);
            }];
        }
        lastButton = button;
    }
    
    [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-bottomPadding);
    }];
    
    UIView *topLine = [self creatLineView];
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.left.right.equalTo(self);
    }];
    
    UIView *firstVerticalLine = [self creatLineView];
    [self addSubview:firstVerticalLine];
    UIButton *button01 = self.buttons[0];
    UIButton *button02 = self.buttons[6];
    [firstVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.left.equalTo(button01.mas_right);
        make.top.equalTo(button01);
        make.bottom.equalTo(button02);
    }];
    
    UIView *secondVerticalLine = [self creatLineView];
    [self addSubview:secondVerticalLine];
    button01 = self.buttons[2];
    button02 = self.buttons[8];
    [secondVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.right.equalTo(button01.mas_left);
        make.top.equalTo(button01);
        make.bottom.equalTo(button02);
    }];
    
    UIView *firstHorizontalLine = [self creatLineView];
    [self addSubview:firstHorizontalLine];
    button01 = self.buttons[0];
    button02 = self.buttons[2];
    [firstHorizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(button01);
        make.right.equalTo(button02);
        make.top.equalTo(button01.mas_bottom);
    }];
    
    UIView *secondHorizontalLine = [self creatLineView];
    [self addSubview:secondHorizontalLine];
    button01 = self.buttons[3];
    button02 = self.buttons[5];
    [secondHorizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(button01);
        make.right.equalTo(button02);
        make.top.equalTo(button01.mas_bottom);
    }];
}

- (UIView *)creatLineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    return lineView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 13;
    for (UIButton *button in self.buttons) {
        CGSize imageViewSize, labelSize;
        imageViewSize = button.imageView.size;
        labelSize = button.titleLabel.size;
        //        NSLog(@"%@ -- %@", NSStringFromCGSize(imageViewSize), NSStringFromCGSize(labelSize));
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, labelSize.height + space, -labelSize.width);
        button.titleEdgeInsets = UIEdgeInsetsMake(imageViewSize.height + space, -imageViewSize.width, 0, 0);
    }
}

- (void)handleClickFeatureButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(walletFeaturesView:didClickFeatureButtonWithType:)]) {
        NSInteger type = button.tag - defaultTag;
        [self.delegate walletFeaturesView:self didClickFeatureButtonWithType:type];
    }
}

- (NSArray *)materialArray {
    if (_materialArray == nil) {
        _materialArray = @[
                           @{@"title": @"充值", @"imageName": @"wallet_recharge_button"},
                           @{@"title": @"提现", @"imageName": @"wallet_withdraw_button"},
                           @{@"title": @"授信", @"imageName": @"wallet_credit_button"},
                           @{@"title": @"我的银行卡", @"imageName": @"wallet_bank_card_button"},
                           @{@"title": @"扫码付款", @"imageName": @"wallet_sweep_code_button"},
                           @{@"title": @"对账单", @"imageName": @"wallet_statement_button"},
                           @{@"title": @"优惠券", @"imageName": @"wallet_coupon_button"},
                           @{@"title": @"个人金融", @"imageName": @"wallet_finance_button"},
                           @{@"title": @"支付密码", @"imageName": @"wallet_password_button"}
                           ];
    }
    return _materialArray;
}

- (NSMutableArray *)buttons {
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end
