//
//  TCMeetingRoomConditionsDurationCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomConditionsDurationCell.h"

@interface TCMeetingRoomConditionsDurationCell () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UITextField *startTimeTextField;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UITextField *endTimeTextField;

@end

@implementation TCMeetingRoomConditionsDurationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(durationCellshouldBeginEditingWithTextField:)]) {
        [self.delegate durationCellshouldBeginEditingWithTextField:textField];
    }
    return NO;
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.startTimeTextField];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.endTimeTextField];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView);
        make.height.equalTo(@30);
    }];
    
    [self.startTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@35);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.startTimeTextField.mas_bottom);
        make.right.equalTo(self.startTimeTextField);
        make.height.equalTo(@0.5);
    }];
    
    [self.endTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.startTimeTextField);
        make.top.equalTo(self.lineView.mas_bottom);
    }];
    
}

- (UITextField *)endTimeTextField {
    if (_endTimeTextField == nil) {
        _endTimeTextField = [[UITextField alloc] init];
        _endTimeTextField.placeholder = @"请选择结束日期";
        _endTimeTextField.delegate = self;
        _endTimeTextField.tag = 10002;
        _endTimeTextField.font = [UIFont systemFontOfSize:14];
    }
    return _endTimeTextField;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = TCBackgroundColor;
    }
    return _lineView;
}

- (UITextField *)startTimeTextField {
    if (_startTimeTextField == nil) {
        _startTimeTextField = [[UITextField alloc] init];
        _startTimeTextField.placeholder = @"请选择开始日期";
        _startTimeTextField.tag = 10001;
        _startTimeTextField.delegate = self;
        _startTimeTextField.font = [UIFont systemFontOfSize:14];
    }
    return _startTimeTextField;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = TCBlackColor;
        _titleLabel.text = @"搜索时间段";
    }
    return _titleLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
