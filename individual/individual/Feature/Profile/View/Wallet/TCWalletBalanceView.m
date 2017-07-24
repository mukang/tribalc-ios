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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *balanceBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_balance_bg_image"]];
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
    
    [balanceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(TCRealValue(216));
    }];
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(balanceBgView);
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
    
    NSString *title = @"余额  ¥";
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
