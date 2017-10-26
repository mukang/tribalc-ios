//
//  TCMeetingRoomSearchResultHeaderView.m
//  individual
//
//  Created by 王帅锋 on 2017/10/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomSearchResultHeaderView.h"
#import "TCMeetingRoomConditions.h"

@interface TCMeetingRoomSearchResultHeaderView ()

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UIButton *modifyBtn;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UILabel *floorTitleLabel;

@property (strong, nonatomic) UILabel *floorLabel;

@property (strong, nonatomic) UILabel *numberTitleLabel;

@property (strong, nonatomic) UILabel *numberLabel;

@property (strong, nonatomic) UILabel *timesTitleLabel;

@property (strong, nonatomic) UILabel *timesLabel;

@property (strong, nonatomic) UILabel *durationTitleLabel;

@property (strong, nonatomic) UILabel *durationLabel;

@property (strong, nonatomic) UILabel *devicesTitleLabel;

@property (strong, nonatomic) UILabel *devicesLabel;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end


@implementation TCMeetingRoomSearchResultHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)setCurrentConditions:(TCMeetingRoomConditions *)currentConditions {
    _currentConditions = currentConditions;
    
    if (currentConditions.startFloor && !currentConditions.endFloor) {
        self.floorLabel.text = [NSString stringWithFormat:@"%@层以上",currentConditions.startFloor];
    }else if (!currentConditions.startFloor && currentConditions.endFloor) {
        self.floorLabel.text = [NSString stringWithFormat:@"%@层以下",currentConditions.endFloor];
    }else if (currentConditions.startFloor && currentConditions.endFloor) {
        self.floorLabel.text = [NSString stringWithFormat:@"%@-%@",currentConditions.startFloor, currentConditions.endFloor];
    }else {
        self.floorLabel.text = @"";
    }
    
    self.numberLabel.text = currentConditions.number;
    if (self.currentConditions.startDateStr && self.currentConditions.endDateStr) {
        self.timesLabel.text = [NSString stringWithFormat:@"%@ 至 %@",self.currentConditions.startDateStr,self.currentConditions.endDateStr];
    }else if (self.currentConditions.startDateStr && !self.currentConditions.endDateStr) {
        NSString *endStr = self.currentConditions.startDate;
//        self.currentConditions.endDate = [NSString stringWithFormat:@"%f",([endStr floatValue] + (7 * 24 * 3600 *1000))];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:([endStr floatValue] + (7 * 24 * 3600 *1000))];
        self.currentConditions.endDateStr = [self.dateFormatter stringFromDate:endDate];
        self.timesLabel.text = [NSString stringWithFormat:@"%@ 至 %@",self.currentConditions.startDateStr,self.currentConditions.endDateStr];
    }else if (!self.currentConditions.startDateStr && self.currentConditions.endDateStr) {
        self.timesLabel.text = [NSString stringWithFormat:@"%@ 至 %@",[self.dateFormatter stringFromDate:[NSDate date]],self.currentConditions.endDateStr];
    }else {
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:(timeInterval + (7 * 24 * 3600))];
        self.timesLabel.text = [NSString stringWithFormat:@"%@ 至 %@",[self.dateFormatter stringFromDate:[NSDate date]],[self.dateFormatter stringFromDate:endDate]];
    }
    
    if (currentConditions.hours) {
        self.durationLabel.text = [NSString stringWithFormat:@"%@小时",currentConditions.hours];
    }else {
        self.durationLabel.text = @"";
    }
    
    if ([currentConditions.selectedDevices isKindOfClass:[NSMutableSet class]]) {
        NSMutableString *mutableStr = [[NSMutableString alloc] init];
        [currentConditions.selectedDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *str = (NSString *)obj;
            [mutableStr appendString:str];
        }];
        
        self.devicesLabel.text = mutableStr;
    }
}

- (void)setUpViews {
    self.backgroundColor = TCRGBColor(239, 245, 245);
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.modifyBtn];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.floorTitleLabel];
    [self.bgView addSubview:self.floorLabel];
    [self.bgView addSubview:self.numberTitleLabel];
    [self.bgView addSubview:self.numberLabel];
    [self.bgView addSubview:self.timesTitleLabel];
    [self.bgView addSubview:self.timesLabel];
    [self.bgView addSubview:self.durationTitleLabel];
    [self.bgView addSubview:self.durationLabel];
    [self.bgView addSubview:self.devicesTitleLabel];
    [self.bgView addSubview:self.devicesLabel];

    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(6);
        make.top.equalTo(self).offset(6);
        make.right.equalTo(self).offset(-6);
        make.bottom.equalTo(self).offset(-8);
    }];

    [self.modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.bgView);
        make.height.equalTo(@25);
        make.width.equalTo(@60);
    }];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.top.equalTo(self.modifyBtn.mas_bottom);
        make.height.equalTo(@0.5);
    }];

    [self.floorTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(25);
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
    }];

    [self.floorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.floorTitleLabel.mas_right).offset(15);
        make.top.equalTo(self.floorTitleLabel);
        make.right.lessThanOrEqualTo(self.bgView).offset(-15);
    }];

    [self.numberTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.floorTitleLabel);
        make.top.equalTo(self.floorTitleLabel.mas_bottom).offset(10);
    }];

    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberTitleLabel.mas_right).offset(15);
        make.top.equalTo(self.numberTitleLabel);
        make.right.lessThanOrEqualTo(self.bgView).offset(-15);
    }];

    [self.timesTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberTitleLabel);
        make.top.equalTo(self.numberTitleLabel.mas_bottom).offset(10);
    }];

    [self.timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timesTitleLabel.mas_right).offset(15);
        make.top.equalTo(self.timesTitleLabel);
        make.right.lessThanOrEqualTo(self.bgView).offset(-15);
    }];

    [self.durationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timesTitleLabel);
        make.top.equalTo(self.timesTitleLabel.mas_bottom).offset(10);
    }];

    [self.durationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.durationTitleLabel.mas_right).offset(15);
        make.top.equalTo(self.durationTitleLabel);
        make.right.lessThanOrEqualTo(self.bgView).offset(-15);
    }];

    [self.devicesTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.durationTitleLabel);
        make.top.equalTo(self.durationTitleLabel.mas_bottom).offset(10);
    }];

    [self.devicesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.devicesTitleLabel.mas_right).offset(15);
        make.top.equalTo(self.devicesTitleLabel);
        make.right.lessThanOrEqualTo(self.bgView).offset(-15);
    }];
}

#pragma mark getter

- (UILabel *)devicesLabel {
    if (_devicesLabel == nil) {
        _devicesLabel = [[UILabel alloc] init];
        _devicesLabel.font = [UIFont systemFontOfSize:14];
        _devicesLabel.textColor = TCBlackColor;
        _devicesLabel.text = @"有窗户，可吸烟，投影仪";
        _devicesLabel.numberOfLines = 0;
    }
    return _devicesLabel;
}

- (UILabel *)devicesTitleLabel {
    if (_devicesTitleLabel == nil) {
        _devicesTitleLabel = [[UILabel alloc] init];
        _devicesTitleLabel.textColor = TCRGBColor(154, 154, 154);
        _devicesTitleLabel.font = [UIFont systemFontOfSize:14];
        [_devicesTitleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _devicesTitleLabel.text = @"会议室设备：";
    }
    return _devicesTitleLabel;
}

- (UILabel *)durationLabel {
    if (_durationLabel == nil) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.textColor = TCBlackColor;
        _durationLabel.font = [UIFont systemFontOfSize:14];
        _durationLabel.text = @"一小时";
    }
    return _durationLabel;
}

- (UILabel *)durationTitleLabel {
    if (_durationTitleLabel == nil) {
        _durationTitleLabel = [[UILabel alloc] init];
        _durationTitleLabel.textColor = TCRGBColor(154, 154, 154);
        _durationTitleLabel.font = [UIFont systemFontOfSize:14];
        _durationTitleLabel.text = @"会 议 时 长 ：";
    }
    return _durationTitleLabel;
}

- (UILabel *)timesLabel {
    if (_timesLabel == nil) {
        _timesLabel = [[UILabel alloc] init];
        _timesLabel.font = [UIFont systemFontOfSize:14];
        _timesLabel.textColor = TCBlackColor;
        _timesLabel.text = @"2017-09-12 至 2017-09-18";
    }
    return _timesLabel;
}

- (UILabel *)timesTitleLabel {
    if (_timesTitleLabel == nil) {
        _timesTitleLabel = [[UILabel alloc] init];
        _timesTitleLabel.font = [UIFont systemFontOfSize:14];
        _timesTitleLabel.textColor = TCRGBColor(154, 154, 154);
        _timesTitleLabel.text = @"搜索时间段：";
    }
    return _timesTitleLabel;
}

- (UILabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.text = @"6-7";
        _numberLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel.textColor = TCBlackColor;
    }
    return _numberLabel;
}

- (UILabel *)numberTitleLabel {
    if (_numberTitleLabel == nil) {
        _numberTitleLabel = [[UILabel alloc] init];
        _numberTitleLabel.text = @"人           数：";
        _numberTitleLabel.textColor = TCRGBColor(154, 154, 154);
        _numberTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _numberTitleLabel;
}

- (UILabel *)floorLabel {
    if (_floorLabel == nil) {
        _floorLabel = [[UILabel alloc] init];
        _floorLabel.textColor = TCBlackColor;
        _floorLabel.font = [UIFont systemFontOfSize:14];
        _floorLabel.text = @"13-20";
    }
    return _floorLabel;
}

- (UILabel *)floorTitleLabel {
    if (_floorTitleLabel == nil) {
        _floorTitleLabel = [[UILabel alloc] init];
        _floorTitleLabel.font = [UIFont systemFontOfSize:14];
        _floorTitleLabel.textColor = TCRGBColor(154, 154, 154);
        _floorTitleLabel.text = @"楼           层：";
    }
    return _floorTitleLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = TCSeparatorLineColor;
    }
    return _lineView;
}

- (UIButton *)modifyBtn {
    if (_modifyBtn == nil) {
        _modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_modifyBtn setTitleColor:TCBlackColor forState:UIControlStateNormal];
    }
    return _modifyBtn;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.borderColor = TCSeparatorLineColor.CGColor;
        _bgView.layer.borderWidth = 0.5;
    }
    return _bgView;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

@end
