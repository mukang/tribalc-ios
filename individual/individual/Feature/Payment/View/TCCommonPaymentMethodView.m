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

@end

@implementation TCCommonPaymentMethodView

- (instancetype)initWithPaymentPurpose:(TCCommonPaymentPurpose)paymentPurpose {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _paymentPurpose = paymentPurpose;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
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
    self.arrowView = arrowView;
}

- (void)setupConstraints {
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27, 27));
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
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
    }];
}

- (void)setMethodModel:(TCPaymentMethodModel *)methodModel {
    _methodModel = methodModel;
    
    self.arrowView.hidden = (self.paymentPurpose == TCCommonPaymentPurposeCompanyRepayment);
    
    if (methodModel.isSingleRow) {
        self.subtitleLabel.hidden = YES;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImageView.mas_right).offset(10);
            make.centerY.equalTo(self);
        }];
    } else {
        self.subtitleLabel.hidden = NO;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImageView.mas_right).offset(10);
            make.top.equalTo(self).offset(10);
        }];
    }
    
    switch (methodModel.paymentMethod) {
        case TCPaymentMethodNone:
            self.titleLabel.text = @"添加银行卡付款";
            self.logoImageView.image = [UIImage imageNamed:@"payment_add_bank_card"];
            break;
        case TCPaymentMethodBalance:
            self.titleLabel.text = @"余额支付";
            self.subtitleLabel.text = methodModel.prompt;
            self.logoImageView.image = [UIImage imageNamed:@"payment_common_balance"];
            if (self.paymentPurpose == TCCommonPaymentPurposeCompanyRepayment) {
                self.arrowView.hidden = YES;
                self.titleLabel.text = @"企业余额";
            }
            break;
        case TCPaymentMethodWechat:
            self.titleLabel.text = @"微信支付";
            self.logoImageView.image = [UIImage imageNamed:@"payment_common_wechat"];
            break;
        case TCPaymentMethodBankCard:
        {
            TCBankCard *bankCard = methodModel.bankCard;
            NSString *bankCardNum = bankCard.bankCardNum;
            NSString *lastNum = nil;
            if (bankCardNum.length >= 4) {
                lastNum = [bankCardNum substringFromIndex:(bankCardNum.length - 4)];
            }
            self.logoImageView.image = [UIImage imageNamed:bankCard.logo];
            self.titleLabel.text = [NSString stringWithFormat:@"%@储蓄卡(%@)", bankCard.bankName, lastNum];
            self.subtitleLabel.text = [NSString stringWithFormat:@"银行单笔限额%lld元", bankCard.maxPaymentAmount];
        }
            break;
            
        default:
            break;
    }
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

@end
