//
//  TCPaymentAddBankCardViewCell.m
//  individual
//
//  Created by 穆康 on 2017/9/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPaymentAddBankCardViewCell.h"

@interface TCPaymentAddBankCardViewCell ()

@property (weak, nonatomic) UIImageView *logoImageView;
@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation TCPaymentAddBankCardViewCell

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
    logoImageView.image = [UIImage imageNamed:@"payment_add_bank_card"];
    [self.contentView addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"添加银行卡付款";
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_gray"]];
    [self.contentView addSubview:arrowView];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17.5, 17.5));
        make.left.equalTo(self.contentView).with.offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logoImageView.mas_right).offset(11);
        make.right.equalTo(arrowView.mas_left).offset(-11);
        make.centerY.equalTo(self.contentView);
    }];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 16.5));
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
}

@end
