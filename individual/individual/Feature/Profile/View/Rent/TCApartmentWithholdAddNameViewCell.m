//
//  TCApartmentWithholdAddNameViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCApartmentWithholdAddNameViewCell.h"
#import <TCCommonLibs/TCExtendButton.h>

@implementation TCApartmentWithholdAddNameViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"开户名";
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLabel];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = TCBlackColor;
    textField.font = [UIFont systemFontOfSize:14];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写开户名称"
                                                                      attributes:@{
                                                                                   NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                   NSForegroundColorAttributeName: TCGrayColor
                                                                                   }];
    [self.contentView addSubview:textField];
    self.textField = textField;
    
    TCExtendButton *button = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"apartment_withhold_card"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(70).priority(500);
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(21, 14.5));
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(10);
        make.right.equalTo(button.mas_left).offset(-10);
        make.top.bottom.equalTo(self.contentView);
    }];
}

- (void)handleClickButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickBankCardButtonInApartmentWithholdAddNameViewCell:)]) {
        [self.delegate didClickBankCardButtonInApartmentWithholdAddNameViewCell:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
