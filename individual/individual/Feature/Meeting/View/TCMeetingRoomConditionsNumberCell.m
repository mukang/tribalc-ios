//
//  TCMeetingRoomConditionsNumberCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomConditionsNumberCell.h"

@interface TCMeetingRoomConditionsNumberCell () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UITextField *numberTextField;

@end

@implementation TCMeetingRoomConditionsNumberCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberCelldidEndEditingWithTextField:)]) {
        [self.delegate numberCelldidEndEditingWithTextField:textField];
    }
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.numberTextField];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(15);
        make.top.bottom.equalTo(self.titleLabel);
        make.width.equalTo(@150);
    }];
}

- (UITextField *)numberTextField {
    if (_numberTextField == nil) {
        _numberTextField = [[UITextField alloc] init];
        _numberTextField.placeholder = @"请输入参会人数";
        _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _numberTextField.delegate = self;
    }
    return _numberTextField;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = TCBlackColor;
        _titleLabel.text = @"人数:";
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
