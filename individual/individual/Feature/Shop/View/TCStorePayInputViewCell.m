//
//  TCStorePayInputViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStorePayInputViewCell.h"

@implementation TCStorePayInputViewCell

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
    titleLabel.text = @"消费总额：";
    titleLabel.textColor = TCBlackColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    
    TCNumberTextField *textField = [[TCNumberTextField alloc] init];
    textField.textAlignment = NSTextAlignmentRight;
    textField.textColor = TCBlackColor;
    textField.font = [UIFont systemFontOfSize:22.5];
//    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"询问服务员后输入"
//                                                                      attributes:@{
//                                                                                   NSFontAttributeName: [UIFont systemFontOfSize:12],
//                                                                                   NSForegroundColorAttributeName: TCGrayColor
//                                                                                   }];
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:textField];
    self.textField = textField;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    [titleLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
}

@end
