//
//  TCStorePayInputViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStorePayInputViewCell.h"

@interface TCStorePayInputViewCell ()

@property (weak, nonatomic) UILabel *placeholderLabel;

@end

@implementation TCStorePayInputViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self registerNotifications];
        [self setupSubviews];
    }
    return self;
}

- (void)dealloc {
    [self removeNotifications];
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
    textField.borderStyle = UITextBorderStyleNone;
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.contentView addSubview:textField];
    self.textField = textField;
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = @"询问服务员后输入";
    placeholderLabel.textColor = TCGrayColor;
    placeholderLabel.textAlignment = NSTextAlignmentRight;
    placeholderLabel.font = [UIFont systemFontOfSize:12];
    [textField addSubview:placeholderLabel];
    self.placeholderLabel = placeholderLabel;
    
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
    [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(textField).offset(-2);
        make.centerY.equalTo(textField);
    }];
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    TCNumberTextField *textField = (TCNumberTextField *)notification.object;
    if (![textField isEqual:self.textField]) {
        return;
    }
    
    if (textField.text.length) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

@end
