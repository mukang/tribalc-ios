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
        make.height.mas_equalTo(21);
        make.left.equalTo(logoImageView.mas_right).with.offset(11);
        make.right.equalTo(markImageView.mas_left).with.offset(-11);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
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
    if (selected) {
        self.markImageView.image = SelectedImage;
    } else {
        self.markImageView.image = NormalImage;
    }
}

@end
