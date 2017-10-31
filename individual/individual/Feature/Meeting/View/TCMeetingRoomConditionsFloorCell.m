//
//  TCMeetingRoomConditionsFloorCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomConditionsFloorCell.h"

@interface TCMeetingRoomConditionsFloorCell () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UITextField *startFloorTextField;

@property (strong, nonatomic) UILabel *intervalLabel;

@property (strong, nonatomic) UITextField *endFloorTextField;

@end

@implementation TCMeetingRoomConditionsFloorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(floorCellDidEndEditingWithTextField:)]) {
        [self.delegate floorCellDidEndEditingWithTextField:textField];
    }
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.startFloorTextField];
    [self.contentView addSubview:self.intervalLabel];
    [self.contentView addSubview:self.endFloorTextField];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.startFloorTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(15);
        make.top.bottom.equalTo(self.titleLabel);
        make.right.equalTo(self.intervalLabel.mas_left).offset(-15);
    }];
    
    [self.intervalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startFloorTextField.mas_right).offset(15);
        make.top.bottom.equalTo(self.titleLabel);
    }];
    
    [self.endFloorTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.intervalLabel.mas_right).offset(15);
        make.top.bottom.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(self.startFloorTextField);
    }];
}

- (UITextField *)endFloorTextField {
    if (_endFloorTextField == nil) {
        _endFloorTextField = [[UITextField alloc] init];
        _endFloorTextField.keyboardType = UIKeyboardTypeNumberPad;
        _endFloorTextField.placeholder = @"请输入楼层范围";
        _endFloorTextField.delegate = self;
        _endFloorTextField.tag = 11112;
        _endFloorTextField.font = [UIFont systemFontOfSize:14];
    }
    return _endFloorTextField;
}

- (UILabel *)intervalLabel {
    if (_intervalLabel == nil) {
        _intervalLabel = [[UILabel alloc] init];
        _intervalLabel.font = [UIFont systemFontOfSize:14];
        _intervalLabel.textColor = TCBlackColor;
        _intervalLabel.text = @"-";
    }
    return _intervalLabel;
}

- (UITextField *)startFloorTextField {
    if (_startFloorTextField == nil) {
        _startFloorTextField = [[UITextField alloc] init];
        _startFloorTextField.placeholder = @"请输入楼层范围";
        _startFloorTextField.keyboardType = UIKeyboardTypeNumberPad;
        _startFloorTextField.tag = 11111;
        _startFloorTextField.delegate = self;
        _startFloorTextField.font = [UIFont systemFontOfSize:14];
    }
    return _startFloorTextField;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = TCBlackColor;
        _titleLabel.text = @"楼层:";
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
