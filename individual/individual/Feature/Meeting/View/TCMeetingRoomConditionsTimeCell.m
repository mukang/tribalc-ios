//
//  TCMeetingRoomConditionsTimeCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomConditionsTimeCell.h"

@interface TCMeetingRoomConditionsTimeCell () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UITextField *startFloorTextField;

@property (strong, nonatomic) UILabel *unitLabel;

@end

@implementation TCMeetingRoomConditionsTimeCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeCellDidEndEditingWithTextField:)]) {
        [self.delegate timeCellDidEndEditingWithTextField:textField];
    }
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.startFloorTextField];
    [self.contentView addSubview:self.unitLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.startFloorTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(15);
        make.top.bottom.equalTo(self.titleLabel);
        make.width.equalTo(@150);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startFloorTextField.mas_right).offset(15);
        make.top.bottom.equalTo(self.titleLabel);
    }];
    
}

- (UILabel *)unitLabel {
    if (_unitLabel == nil) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = [UIFont systemFontOfSize:14];
        _unitLabel.textColor = TCBlackColor;
        _unitLabel.text = @"小时";
    }
    return _unitLabel;
}

- (UITextField *)startFloorTextField {
    if (_startFloorTextField == nil) {
        _startFloorTextField = [[UITextField alloc] init];
        _startFloorTextField.placeholder = @"请输入会议时长";
        _startFloorTextField.delegate = self;
        _startFloorTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _startFloorTextField;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = TCBlackColor;
        _titleLabel.text = @"会议时长:";
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
