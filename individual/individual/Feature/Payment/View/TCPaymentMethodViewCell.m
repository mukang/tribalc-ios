//
//  TCPaymentMethodViewCell.m
//  individual
//
//  Created by 穆康 on 2017/1/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPaymentMethodViewCell.h"

@interface TCPaymentMethodViewCell ()

@property (weak, nonatomic) UIImageView *logoImageView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *promptLabel;
@property (weak, nonatomic) UIImageView *selectedImageView;

@end

@implementation TCPaymentMethodViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *logoImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.textColor = TCGrayColor;
    promptLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:promptLabel];
    self.promptLabel = promptLabel;
    
    UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payment_method_selected"]];
    selectedImageView.hidden = YES;
    [self.contentView addSubview:selectedImageView];
    self.selectedImageView = selectedImageView;
    
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17.5, 17.5));
        make.left.equalTo(self.contentView).with.offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoImageView.mas_right).offset(11);
        make.right.equalTo(selectedImageView.mas_left).offset(-11);
        make.centerY.equalTo(self.contentView);
    }];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.centerY.equalTo(self.contentView).offset(10);
    }];
    [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.right.equalTo(self.contentView).with.offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setMethodModel:(TCPaymentMethodModel *)methodModel {
    _methodModel = methodModel;
    
    // 是否选中
    self.selectedImageView.hidden = !methodModel.isSelected;
    
    // 是否是单行
    if (methodModel.isSingleRow) {
        self.promptLabel.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
        }];
    } else {
        self.promptLabel.hidden = NO;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(-10);
        }];
    }
    
    // 是否不可用
    if (methodModel.isInvalid) {
        self.titleLabel.textColor = TCGrayColor;
        self.logoImageView.alpha = 0.65;
    } else {
        self.titleLabel.textColor = TCBlackColor;
        self.logoImageView.alpha = 1.0;
    }
    
    // 填充数据
    if (methodModel.paymentMethod == TCPaymentMethodBalance) {
        self.logoImageView.image = [UIImage imageNamed:@"balance_icon"];
        self.titleLabel.text = @"余额支付";
        self.promptLabel.text = methodModel.prompt;
    } else if (methodModel.paymentMethod == TCPaymentMethodWechat) {
        self.logoImageView.image = [UIImage imageNamed:@"wechat_icon"];
        self.titleLabel.text = @"微信支付";
    } else if (methodModel.paymentMethod == TCPaymentMethodBankCard) {
        TCBankCard *bankCard = methodModel.bankCard;
        NSString *bankCardNum = bankCard.bankCardNum;
        NSString *lastNum;
        if (bankCardNum.length >= 4) {
            lastNum = [bankCardNum substringFromIndex:(bankCardNum.length - 4)];
        }
        self.logoImageView.image = [UIImage imageNamed:bankCard.logo];
        self.titleLabel.text = [NSString stringWithFormat:@"%@储蓄卡(%@)", bankCard.bankName, lastNum];
        if (methodModel.isInvalid) {
            self.promptLabel.text = @"该付款方式不支持当前交易";
        } else {
            self.promptLabel.text = [NSString stringWithFormat:@"银行单笔限额%lld元", bankCard.maxPaymentAmount];
        }
    }
}

@end
