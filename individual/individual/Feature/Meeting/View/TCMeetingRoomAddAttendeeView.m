//
//  TCMeetingRoomAddAttendeeView.m
//  individual
//
//  Created by 穆康 on 2017/11/29.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomAddAttendeeView.h"

@implementation TCMeetingRoomAddAttendeeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *topLine = [self createLineView];
    UIView *middleLine = [self createLineView];
    UIView *bottomLine = [self createLineView];
    
    UILabel *nameLabel = [self createTitleLabelWithTitle:@"姓名"];
    UILabel *phoneLabel = [self createTitleLabelWithTitle:@"电话"];
    
    TCNumberTextField *nameTextField = [self createTextFieldWithPlaceholder:@"请您填写姓名"];
    TCNumberTextField *phoneTextField = [self createTextFieldWithPlaceholder:@"请您填写电话号码"];
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.nameTextField = nameTextField;
    self.phoneTextField = phoneTextField;
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
    }];
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_top).offset(22.5);
    }];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_bottom).offset(-22.5);
    }];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(20);
        make.top.equalTo(topLine.mas_bottom).offset(5);
        make.bottom.equalTo(middleLine.mas_top).offset(-5);
    }];
    [phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLabel.mas_right).offset(20);
        make.top.equalTo(middleLine.mas_bottom).offset(5);
        make.bottom.equalTo(bottomLine.mas_top).offset(-5);
    }];
}

- (UIView *)createLineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.equalTo(self);
    }];
    
    return lineView;
}

- (UILabel *)createTitleLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = TCBlackColor;
    label.font = [UIFont systemFontOfSize:16];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
    }];
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    return label;
}

- (TCNumberTextField *)createTextFieldWithPlaceholder:(NSString *)placeholder {
    TCNumberTextField *textField = [[TCNumberTextField alloc] init];
    textField.textColor = TCBlackColor;
    textField.font = [UIFont systemFontOfSize:16];
    textField.textAlignment = NSTextAlignmentRight;
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:placeholder
                                                                 attributes:@{
                                                                              NSForegroundColorAttributeName: TCLightGrayColor,
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:16]
                                                                              }];
    textField.attributedPlaceholder = attStr;
    [self addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
    }];
    
    return textField;
}

@end
