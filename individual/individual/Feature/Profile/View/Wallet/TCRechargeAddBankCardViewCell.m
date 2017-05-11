//
//  TCRechargeAddBankCardViewCell.m
//  individual
//
//  Created by 穆康 on 2017/5/11.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRechargeAddBankCardViewCell.h"

@implementation TCRechargeAddBankCardViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 20);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"添加银行卡";
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLabel];
    
    UIImageView *addImageView = [[UIImageView alloc] init];
    addImageView.image = [UIImage imageNamed:@"recharge_add_bank_card"];
    [self.contentView addSubview:addImageView];
    
    __weak typeof(self) weakSelf = self;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(20);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17.5, 17.5));
        make.right.equalTo(weakSelf.contentView).offset(-20);
        make.centerY.equalTo(weakSelf.contentView);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
