//
//  TCWalletBalanceView.m
//  individual
//
//  Created by 穆康 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletBalanceView.h"
#import "TCWalletCreditLimitView.h"
#import "TCWalletAccount.h"

@interface TCWalletBalanceView ()

@property (weak, nonatomic) UILabel *balanceLabel;
@property (weak, nonatomic) TCWalletCreditLimitView *creditLimitView;

@end

@implementation TCWalletBalanceView

- (instancetype)initWithType:(TCWalletBalanceViewType)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _type = type;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *balanceBgView = [[UIImageView alloc] init];
    [self addSubview:balanceBgView];
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:balanceLabel];
    
    TCWalletCreditLimitView *creditLimitView = [[TCWalletCreditLimitView alloc] init];
    [self addSubview:creditLimitView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self addSubview:lineView];
    
    self.balanceLabel = balanceLabel;
    self.creditLimitView = creditLimitView;
    
    CGFloat balanceBgViewH = 0;
    CGFloat balanceLabelOffset = 0;
    if (_type == TCWalletBalanceViewTypeIndividual) {
        balanceBgView.image = [UIImage imageNamed:@"wallet_balance_bg_image"];
        balanceBgViewH = TCRealValue(216);
        balanceLabelOffset = TCRealValue(112);
        creditLimitView.creditIcon.image = [UIImage imageNamed:@"wallet_credit_icon"];
        creditLimitView.validIcon.image = [UIImage imageNamed:@"wallet_vaild_credit_icon"];
    } else {
        balanceBgView.image = [UIImage imageNamed:@"company_balance_bg_image"];
        balanceBgViewH = TCRealValue(156);
        balanceLabelOffset = TCRealValue(56);
        creditLimitView.creditIcon.image = [UIImage imageNamed:@"company_credit_icon"];
        creditLimitView.validIcon.image = [UIImage imageNamed:@"company_vaild_credit_icon"];
        
        UILabel *companyLabel = [[UILabel alloc] init];
        companyLabel.text = @"公司余额";
        companyLabel.textColor = [UIColor whiteColor];
        companyLabel.textAlignment = NSTextAlignmentRight;
        companyLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:companyLabel];
        
        [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(TCRealValue(-30));
            make.top.equalTo(balanceBgView).offset(7);
        }];
    }
    
    [balanceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(balanceBgViewH);
    }];
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(balanceBgView);
        make.centerY.equalTo(balanceBgView.mas_top).offset(balanceLabelOffset);
    }];
    [creditLimitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(TCRealValue(88));
        make.centerY.equalTo(balanceBgView.mas_bottom);
        make.left.equalTo(self).offset(TCRealValue(19));
        make.right.equalTo(self).offset(TCRealValue(-19));
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.bottom.right.equalTo(self);
    }];
}

- (void)setWalletAccount:(TCWalletAccount *)walletAccount {
    _walletAccount = walletAccount;
    
    NSString *title = (_type == TCWalletBalanceViewTypeIndividual) ? @"余额  ¥" : @"¥";
    NSString *balance = [NSString stringWithFormat:@"%0.2f", walletAccount.balance];
    NSString *str = [NSString stringWithFormat:@"%@%@", title, balance];
    NSRange titleRange = [str rangeOfString:title];
    NSRange balanceRange = [str rangeOfString:balance];
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:str];
    [attText addAttributes:@{
                             NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(16)],
                             NSForegroundColorAttributeName: [UIColor whiteColor]
                             }
                     range:titleRange];
    [attText addAttributes:@{
                             NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(41.5)],
                             NSForegroundColorAttributeName: [UIColor whiteColor]
                             }
                     range:balanceRange];
    self.balanceLabel.attributedText = attText;
    
    self.creditLimitView.walletAccount = walletAccount;
}

@end
