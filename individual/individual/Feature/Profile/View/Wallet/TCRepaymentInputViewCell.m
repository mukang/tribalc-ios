//
//  TCRepaymentInputViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRepaymentInputViewCell.h"

@implementation TCRepaymentInputViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"金额";
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.textColor = TCGrayColor;
    subTitleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:subTitleLabel];
    self.subTitleLabel = subTitleLabel;
    
    TCNumberTextField *textField = [[TCNumberTextField alloc] init];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = TCBlackColor;
    textField.font = [UIFont systemFontOfSize:16];
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入还款金额"
                                                                      attributes:@{
                                                                                   NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                   NSForegroundColorAttributeName: TCLightGrayColor
                                                                                   }];
    [self.contentView addSubview:textField];
    self.textField = textField;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.top.equalTo(self.contentView).offset(14);
    }];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(7);
    }];
    [subTitleLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
        make.right.equalTo(self.contentView).offset(-20);
        make.left.equalTo(subTitleLabel.mas_right).offset(20);
    }];
}

@end
