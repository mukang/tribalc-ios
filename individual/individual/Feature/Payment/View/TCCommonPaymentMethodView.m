//
//  TCCommonPaymentMethodView.m
//  individual
//
//  Created by 穆康 on 2017/9/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommonPaymentMethodView.h"

@interface TCCommonPaymentMethodView ()

@property (weak, nonatomic) UIImageView *logoImageView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *subtitleLabel;
@property (weak, nonatomic) UIImageView *arrowView;

/** 银行卡logo及背景图数据 */
@property (copy, nonatomic) NSArray *bankInfoList;

@end

@implementation TCCommonPaymentMethodView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *logoImageView = [[UIImageView alloc] init];
    [self addSubview:logoImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:titleLabel];
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.textColor = TCGrayColor;
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:subtitleLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_gray"]];
    [self addSubview:arrowView];
    
    self.logoImageView = logoImageView;
    self.titleLabel = titleLabel;
    self.subtitleLabel = subtitleLabel;
}

- (void)setupConstraints {
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40.5, 40.5));
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoImageView.mas_right).offset(10);
        make.top.equalTo(self).offset(10);
    }];
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self).offset(-10);
    }];
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 16.5));
        make.right.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];
}

- (void)setMethod:(TCCommonPaymentMethod)method {
    _method = method;
    
    if (method == TCCommonPaymentMethodWechat) {
        self.subtitleLabel.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImageView.mas_right).offset(10);
            make.centerY.equalTo(self);
        }];
        self.titleLabel.text = @"微信支付";
        self.logoImageView.image = [UIImage imageNamed:@"payment_common_wechat"];
    } else {
        self.subtitleLabel.hidden = NO;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImageView.mas_right).offset(10);
            make.top.equalTo(self).offset(10);
        }];
        if (method == TCCommonPaymentMethodBalance) {
            self.titleLabel.text = @"余额支付";
            self.logoImageView.image = [UIImage imageNamed:@"payment_common_balance"];
        }
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)setBalance:(double)balance {
    _balance = balance;
    
    self.subtitleLabel.text = [NSString stringWithFormat:@"可用余额%0.2f元", balance];
}

- (void)setBankCard:(TCBankCard *)bankCard {
    _bankCard = bankCard;
    
    bankCard.logo = @"bank_logo_Default";
    for (NSDictionary *bankInfo in self.bankInfoList) {
        if ([bankInfo[@"code"] isEqualToString:bankCard.bankCode]) {
            bankCard.logo = bankInfo[@"logo"];
            break;
        }
    }
    
    NSString *bankCardNum = bankCard.bankCardNum;
    NSString *lastNum;
    if (bankCardNum.length >= 4) {
        lastNum = [bankCardNum substringFromIndex:(bankCardNum.length - 4)];
    }
    
    self.logoImageView.image = [UIImage imageNamed:bankCard.logo];
    self.titleLabel.text = [NSString stringWithFormat:@"%@储蓄卡(%@)", bankCard.bankName, lastNum];
    self.subtitleLabel.text = [NSString stringWithFormat:@"单笔最高支付%lld元", bankCard.maxPaymentAmount];
}

- (NSArray *)bankInfoList {
    if (_bankInfoList == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TCBankInfoList" ofType:@"plist"];
        _bankInfoList = [NSArray arrayWithContentsOfFile:path];
    }
    return _bankInfoList;
}

@end
