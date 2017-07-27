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
@property (copy, nonatomic) NSArray *materialsOfIndividual;
@property (copy, nonatomic) NSArray *materialsOfCompany;

@property (strong, nonatomic) NSMutableArray *buttons;

@end

@implementation TCWalletFeaturesView

- (instancetype)initWithType:(TCWalletFeaturesViewType)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _type = type;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    CGFloat padding = TCRealValue(15);
    CGFloat bottomPadding = TCRealValue(12);
    
    UIView *containerView = [[UIView alloc] init];
    [self addSubview:containerView];
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(padding, padding, bottomPadding, padding));
    }];
    
    NSUInteger buttonCount = 0;
    NSArray *materials = nil;
    UIButton *lastButton = nil;
    if (_type == TCWalletFeaturesViewTypeIndividual) {
        buttonCount = self.materialsOfIndividual.count;
        materials = self.materialsOfIndividual;
    } else {
        buttonCount = self.materialsOfCompany.count;
        materials = self.materialsOfCompany;
    }
    
    for (int i=0; i<buttonCount; i++) {
        NSDictionary *dic = materials[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:dic[@"title"] forState:UIControlStateNormal];
        [button setTitleColor:TCBlackColor forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setImage:[UIImage imageNamed:dic[@"imageName"]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleClickFeatureButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = defaultTag + i;
        [self addSubview:button];
        [self.buttons addObject:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(containerView).multipliedBy(1/3.0f);
            make.height.equalTo(containerView).multipliedBy(1/3.0f);
        }];
        
        if (lastButton) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i % 3 == 0) {
                    make.left.equalTo(containerView);
                    make.top.equalTo(lastButton.mas_bottom);
                } else {
                    make.left.equalTo(lastButton.mas_right);
                    make.top.equalTo(lastButton);
                }
            }];
        } else {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(containerView);
            }];
        }
        lastButton = button;
    }
    
    UIView *topLine = [self creatLineView];
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.left.right.equalTo(self);
    }];
    
    UIView *firstVerticalLine = [self creatLineView];
    [containerView addSubview:firstVerticalLine];
    [firstVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0.5);
        make.top.bottom.equalTo(containerView);
        make.centerX.equalTo(containerView.mas_right).multipliedBy(1/3.0f);
    }];
    
    UIView *secondVerticalLine = [self creatLineView];
    [self addSubview:secondVerticalLine];
    [secondVerticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.top.bottom.equalTo(firstVerticalLine);
        make.centerX.equalTo(containerView.mas_right).multipliedBy(2/3.0f);
    }];
    
    UIView *firstHorizontalLine = [self creatLineView];
    [self addSubview:firstHorizontalLine];
    [firstHorizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(containerView);
        make.centerY.equalTo(containerView.mas_bottom).multipliedBy(1/3.0f);
    }];
    
    UIView *secondHorizontalLine = [self creatLineView];
    [self addSubview:secondHorizontalLine];
    [secondHorizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.right.equalTo(firstHorizontalLine);
        make.centerY.equalTo(containerView.mas_bottom).multipliedBy(2/3.0f);
    }];
    
    
    if (_type == TCWalletFeaturesViewTypeCompany) {
        UIButton *button = [self.buttons lastObject];
        button.hidden = YES;
        firstVerticalLine.hidden = YES;
        secondVerticalLine.hidden = YES;
        firstHorizontalLine.hidden = YES;
        secondHorizontalLine.hidden = YES;
    }
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
    if ([self.delegate respondsToSelector:@selector(walletFeaturesView:didClickFeatureButtonWithIndex:)]) {
        NSInteger index = button.tag - defaultTag;
        [self.delegate walletFeaturesView:self didClickFeatureButtonWithIndex:index];
    }
}

- (NSArray *)materialsOfIndividual {
    if (_materialsOfIndividual == nil) {
        _materialsOfIndividual = @[
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
    return _materialsOfIndividual;
}

- (NSArray *)materialsOfCompany {
    if (_materialsOfCompany == nil) {
        _materialsOfCompany = @[
                                @{@"title": @"充值", @"imageName": @"company_recharge_button"},
                                @{@"title": @"对账单", @"imageName": @"company_statement_button"},
                                @{@"title": @"企业授信", @"imageName": @"company_credit_button"},
                                @{@"title": @"企业缴租", @"imageName": @"company_rent_button"}
                                ];
    }
    return _materialsOfCompany;
}

- (NSMutableArray *)buttons {
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end
