//
//  TCPaymentMethodViewCell.m
//  individual
//
//  Created by 穆康 on 2017/1/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPaymentMethodViewCell.h"

@interface TCPaymentMethodViewCell ()

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
    promptLabel.text = @"该付款方式不支持当前交易";
    promptLabel.textColor = TCSeparatorLineColor;
    promptLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:promptLabel];
    self.promptLabel = promptLabel;
    
    UIImageView *selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_common_address_button_selected"]];
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
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.right.equalTo(self.contentView).with.offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setIsBankCardMode:(BOOL)isBankCardMode {
    _isBankCardMode = isBankCardMode;
    
    if (!isBankCardMode) {
        self.logoImageView.alpha = 1.0;
        self.promptLabel.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
        }];
    }
}

- (void)setBankCard:(TCBankCard *)bankCard {
    _bankCard = bankCard;
    
    NSString *bankCardNum = bankCard.bankCardNum;
    NSString *lastNum;
    if (bankCardNum.length >= 4) {
        lastNum = [bankCardNum substringFromIndex:(bankCardNum.length - 4)];
    }
    self.logoImageView.image = [UIImage imageNamed:bankCard.logo];
    self.titleLabel.text = [NSString stringWithFormat:@"%@储蓄卡(%@)", bankCard.bankName, lastNum];
    
    if (bankCard.type == TCBankCardTypeWithdraw) {
        self.userInteractionEnabled = NO;
        self.logoImageView.alpha = 0.5;
        self.titleLabel.textColor = TCSeparatorLineColor;
        self.promptLabel.hidden = NO;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView).offset(-10);
        }];
    } else {
        self.userInteractionEnabled = YES;
        self.logoImageView.alpha = 1.0;
        self.titleLabel.textColor = TCBlackColor;
        self.promptLabel.hidden = YES;
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
        }];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (self.isBankCardMode && self.bankCard.type == TCBankCardTypeWithdraw) {
        return;
    }
    
    if (selected) {
        self.selectedImageView.hidden = NO;
    } else {
        self.selectedImageView.hidden = YES;
    }
}

@end
