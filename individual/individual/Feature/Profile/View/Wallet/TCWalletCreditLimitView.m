//
//  TCWalletCreditLimitView.m
//  individual
//
//  Created by 穆康 on 2017/7/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletCreditLimitView.h"
#import "TCWalletAccount.h"

@interface TCWalletCreditLimitView ()

@property (weak, nonatomic) UILabel *limitLabel;
@property (weak, nonatomic) UILabel *validLimitLabel;

@end

@implementation TCWalletCreditLimitView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 7.5;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowRadius = 10;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self addSubview:lineView];
    
    UIImageView *creditIcon = [[UIImageView alloc] init];
    [self addSubview:creditIcon];
    self.creditIcon = creditIcon;
    
    UILabel *creditLabel = [[UILabel alloc] init];
    creditLabel.text = @"授信额度";
    creditLabel.textColor = TCBlackColor;
    creditLabel.font = [UIFont systemFontOfSize:TCRealValue(14)];
    [self addSubview:creditLabel];
    
    UILabel *limitLabel = [[UILabel alloc] init];
    limitLabel.textColor = TCBlackColor;
    limitLabel.textAlignment = NSTextAlignmentRight;
    limitLabel.font = [UIFont systemFontOfSize:TCRealValue(14)];
    [self addSubview:limitLabel];
    
    UIImageView *validIcon = [[UIImageView alloc] init];
    [self addSubview:validIcon];
    self.validIcon = validIcon;
    
    UILabel *validLabel = [[UILabel alloc] init];
    validLabel.text = @"可用额度";
    validLabel.textColor = TCBlackColor;
    validLabel.font = [UIFont systemFontOfSize:TCRealValue(14)];
    [self addSubview:validLabel];
    
    UILabel *validLimitLabel = [[UILabel alloc] init];
    validLimitLabel.textColor = TCBlackColor;
    validLimitLabel.textAlignment = NSTextAlignmentRight;
    validLimitLabel.font = [UIFont systemFontOfSize:TCRealValue(14)];
    [self addSubview:validLimitLabel];
    
    self.limitLabel = limitLabel;
    self.validLimitLabel = validLimitLabel;
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self.mas_centerY);
    }];
    [creditIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(24), TCRealValue(24)));
        make.left.equalTo(self).offset(TCRealValue(13));
        make.centerY.equalTo(self.mas_bottom).multipliedBy(0.25);
    }];
    [creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(creditIcon.mas_right).offset(TCRealValue(10));
        make.centerY.equalTo(creditIcon);
    }];
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(TCRealValue(-13));
        make.centerY.equalTo(creditIcon);
    }];
    [validIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.left.equalTo(creditIcon);
        make.centerY.equalTo(self.mas_bottom).multipliedBy(0.75);
    }];
    [validLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(creditLabel);
        make.centerY.equalTo(validIcon);
    }];
    [validLimitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(limitLabel);
        make.centerY.equalTo(validIcon);
    }];
}

- (void)setWalletAccount:(TCWalletAccount *)walletAccount {
    _walletAccount = walletAccount;
    
    self.limitLabel.text = [NSString stringWithFormat:@"¥ %0.2f", walletAccount.creditLimit];
    self.validLimitLabel.text = [NSString stringWithFormat:@"¥ %0.2f", (walletAccount.creditLimit - walletAccount.creditBalance)];
}


@end
