//
//  TCRechargeMethodViewCell.m
//  individual
//
//  Created by 穆康 on 2017/4/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRechargeMethodViewCell.h"
#import <TCCommonLibs/TCExtendButton.h>

#define NormalImage   [UIImage imageNamed:@"profile_common_address_button_normal"]
#define SelectedImage [UIImage imageNamed:@"profile_common_address_button_selected"]

@interface TCRechargeMethodViewCell ()

@property (weak, nonatomic) UIImageView *markImageView;
@property (weak, nonatomic) TCExtendButton *rechargeButton;

@end

@implementation TCRechargeMethodViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _hideMarkIcon = NO;
        _showRechargeButton = NO;
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
    promptLabel.text = @"该银行卡不支持当前交易";
    promptLabel.textColor = TCSeparatorLineColor;
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.hidden = YES;
    [self.contentView addSubview:promptLabel];
    self.promptLabel = promptLabel;
    
    UIImageView *markImageView = [[UIImageView alloc] init];
    markImageView.image = NormalImage;
    markImageView.hidden = _hideMarkIcon;
    [self.contentView addSubview:markImageView];
    self.markImageView = markImageView;
    
    TCExtendButton *rechargeButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [rechargeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"充值"
                                                                       attributes:@{
                                                                                    NSFontAttributeName: [UIFont systemFontOfSize:11],
                                                                                    NSForegroundColorAttributeName: TCRGBColor(39, 65, 201),
                                                                                    NSUnderlineStyleAttributeName: @(1)
                                                                                    }]
                              forState:UIControlStateNormal];
    [rechargeButton addTarget:self action:@selector(handleClickRechargeButton:) forControlEvents:UIControlEventTouchUpInside];
    rechargeButton.hitTestSlop = UIEdgeInsetsMake(-5, -10, -5, -10);
    rechargeButton.hidden = !_showRechargeButton;
    [self.contentView addSubview:rechargeButton];
    self.rechargeButton = rechargeButton;
    
    __weak typeof(self) weakSelf = self;
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17.5, 17.5));
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoImageView.mas_right).offset(11);
        make.right.equalTo(markImageView.mas_left).offset(-11);
        make.centerY.equalTo(self.contentView);
    }];
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleLabel);
        make.centerY.equalTo(self.contentView).offset(10);
    }];
    [markImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
    [rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

- (void)handleClickRechargeButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickRechargeButtonInRechargeMethodViewCell:)]) {
        [self.delegate didClickRechargeButtonInRechargeMethodViewCell:self];
    }
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

- (void)setHideMarkIcon:(BOOL)hideMarkIcon {
    _hideMarkIcon = hideMarkIcon;
    
    self.markImageView.hidden = hideMarkIcon;
}

- (void)setShowRechargeButton:(BOOL)showRechargeButton {
    _showRechargeButton = showRechargeButton;
    
    self.rechargeButton.hidden = !showRechargeButton;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (self.isBankCardMode && self.bankCard.type == TCBankCardTypeWithdraw) {
        return;
    }
    
    if (selected) {
        self.markImageView.image = SelectedImage;
    } else {
        self.markImageView.image = NormalImage;
    }
}

@end
