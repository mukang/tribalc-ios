//
//  TCMeetingRoomBookingRecordCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomBookingRecordCell.h"

@interface TCMeetingRoomBookingRecordCell ()

@property (strong, nonatomic) UILabel *orderNumLabel;

@property (strong, nonatomic) UILabel *orderStatusLabel;

@property (strong, nonatomic) UIView *meetingRoomInfoView;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *moneyLabel;

@property (strong, nonatomic) UIImageView *meetingRoomImageView;

@property (strong, nonatomic) UILabel *meetingRoomTitleLabel;

@property (strong, nonatomic) UILabel *meetingRoomInfoLabel;

@property (strong, nonatomic) UILabel *dateLabel;

@end

@implementation TCMeetingRoomBookingRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setUpViews {
    [self.contentView addSubview:self.orderNumLabel];
    [self.contentView addSubview:self.orderStatusLabel];
    [self.contentView addSubview:self.meetingRoomInfoView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.meetingRoomInfoView addSubview:self.meetingRoomImageView];
    [self.meetingRoomInfoView addSubview:self.meetingRoomTitleLabel];
    [self.meetingRoomInfoView addSubview:self.meetingRoomInfoLabel];
    [self.meetingRoomInfoView addSubview:self.dateLabel];
    
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView);
        make.height.equalTo(@42);
    }];
    
    [self.orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.height.equalTo(self.orderNumLabel);
    }];
    
    [self.meetingRoomInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.orderNumLabel);
        make.top.equalTo(self.orderNumLabel.mas_bottom);
        make.height.equalTo(@75);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.orderStatusLabel);
        make.top.equalTo(self.meetingRoomInfoView.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLabel.mas_left).offset(-20);
        make.height.top.equalTo(self.moneyLabel);
    }];
    
    [self.meetingRoomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.meetingRoomInfoView);
        make.width.equalTo(@97);
    }];
    
    [self.meetingRoomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.meetingRoomImageView.mas_right).offset(15);
        make.top.equalTo(self.meetingRoomImageView);
        make.right.equalTo(self.meetingRoomInfoView).offset(-15);
        make.height.equalTo(@26);
    }];
    
    [self.meetingRoomInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.meetingRoomTitleLabel);
        make.top.equalTo(self.meetingRoomTitleLabel.mas_bottom);
        make.height.equalTo(@25);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.meetingRoomInfoLabel);
        make.top.equalTo(self.meetingRoomInfoLabel.mas_bottom).offset(4);
        make.height.equalTo(@20);
    }];
}

- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:11];
        _dateLabel.textColor = TCGrayColor;
    }
    return _dateLabel;
}

- (UILabel *)meetingRoomInfoLabel {
    if (_meetingRoomInfoLabel == nil) {
        _meetingRoomInfoLabel = [[UILabel alloc] init];
        _meetingRoomInfoLabel.font = [UIFont systemFontOfSize:12];
        _meetingRoomInfoLabel.textColor = TCGrayColor;
    }
    return _meetingRoomInfoLabel;
}

- (UILabel *)meetingRoomTitleLabel {
    if (_meetingRoomTitleLabel == nil) {
        _meetingRoomTitleLabel = [[UILabel alloc] init];
        _meetingRoomTitleLabel.font = [UIFont systemFontOfSize:16];
        _meetingRoomTitleLabel.textColor = TCBlackColor;
    }
    return _meetingRoomTitleLabel;
}

- (UIImageView *)meetingRoomImageView {
    if (_meetingRoomImageView == nil) {
        _meetingRoomImageView = [[UIImageView alloc] init];
    }
    return _meetingRoomImageView;
}

- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = TCBlackColor;
        _moneyLabel.font = [UIFont systemFontOfSize:16];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = TCGrayColor;
    }
    return _timeLabel;
}

- (UIView *)meetingRoomInfoView {
    if (_meetingRoomInfoView == nil) {
        _meetingRoomInfoView = [[UIView alloc] init];
        _meetingRoomInfoView.backgroundColor = TCRGBColor(242, 243, 244);
    }
    return _meetingRoomInfoView;
}

- (UILabel *)orderStatusLabel {
    if (_orderStatusLabel == nil) {
        _orderStatusLabel = [[UILabel alloc] init];
        _orderStatusLabel.font = [UIFont systemFontOfSize:14];
        _orderStatusLabel.textAlignment = NSTextAlignmentRight;
        _orderStatusLabel.textColor = TCRGBColor(151, 171, 234);
    }
    return _orderStatusLabel;
}

- (UILabel *)orderNumLabel {
    if (_orderNumLabel == nil) {
        _orderNumLabel = [[UILabel alloc] init];
        _orderNumLabel.textColor = TCBlackColor;
        _orderNumLabel.font = [UIFont systemFontOfSize:14];
    }
    return _orderNumLabel;
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
