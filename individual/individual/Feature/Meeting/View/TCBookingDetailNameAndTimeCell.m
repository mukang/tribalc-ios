//
//  TCBookingDetailNameAndTimeCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingDetailNameAndTimeCell.h"
#import "TCMeetingRoomReservationDetail.h"

@interface TCBookingDetailNameAndTimeCell ()

@property (strong, nonatomic) UILabel *meetingRoomNameTitleLabel;

@property (strong, nonatomic) UILabel *meetingRoomNameLabel;

@property (strong, nonatomic) UILabel *bookingTimeTitleLabel;

@property (strong, nonatomic) UILabel *bookingTimeLabel;

@property (strong, nonatomic) UILabel *timesLabel;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TCBookingDetailNameAndTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setMeetingRoomReservationDetail:(TCMeetingRoomReservationDetail *)meetingRoomReservationDetail {
    _meetingRoomReservationDetail = meetingRoomReservationDetail;
    
    self.meetingRoomNameLabel.text = meetingRoomReservationDetail.name;
    int64_t second = (meetingRoomReservationDetail.planEndTime - meetingRoomReservationDetail.conferenceBeginTime)/1000;
    CGFloat hour = second/3600.0;
    int h = (int)hour;
    if (hour > h) {
        hour = h + 0.5;
    }
    
    NSString *startDateStr = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:meetingRoomReservationDetail.conferenceBeginTime/1000]];
    NSString *endDateStr = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:meetingRoomReservationDetail.planEndTime/1000]];
    NSArray *startDateArr = [startDateStr componentsSeparatedByString:@" "];
    NSArray *endDateArr = [endDateStr componentsSeparatedByString:@" "];
    NSString *startStr = startDateArr[0];
    NSString *dateStr;
    if (endDateArr.count == 2 && startDateArr.count == 2) {
        dateStr = [NSString stringWithFormat:@"%@-%@（%@小时）",startDateArr[1],endDateArr[1],@(hour)];
    }
    self.bookingTimeLabel.text = startStr;
    
    self.timesLabel.text = dateStr;
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.meetingRoomNameTitleLabel];
    [self.contentView addSubview:self.meetingRoomNameLabel];
    [self.contentView addSubview:self.bookingTimeTitleLabel];
    [self.contentView addSubview:self.bookingTimeLabel];
    [self.contentView addSubview:self.timesLabel];
    
    [self.meetingRoomNameTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.meetingRoomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.meetingRoomNameTitleLabel.mas_right);
        make.top.equalTo(self.meetingRoomNameTitleLabel);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.greaterThanOrEqualTo(@20);
    }];
    
    [self.bookingTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.meetingRoomNameLabel.mas_bottom).offset(10);
    }];
    
    [self.bookingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookingTimeTitleLabel.mas_right);
        make.top.equalTo(self.bookingTimeTitleLabel);
    }];
    
    [self.timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookingTimeLabel);
        make.top.equalTo(self.bookingTimeLabel.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
}

- (UILabel *)timesLabel {
    if (_timesLabel == nil) {
        _timesLabel = [[UILabel alloc] init];
        _timesLabel.textColor = TCBlackColor;
        _timesLabel.font = [UIFont systemFontOfSize:14];
    }
    return _timesLabel;
}

- (UILabel *)bookingTimeLabel {
    if (_bookingTimeLabel == nil) {
        _bookingTimeLabel = [[UILabel alloc] init];
        _bookingTimeLabel.font = [UIFont systemFontOfSize:14];
        _bookingTimeLabel.textColor = TCBlackColor;
    }
    return _bookingTimeLabel;
}

- (UILabel *)bookingTimeTitleLabel {
    if (_bookingTimeTitleLabel == nil) {
        _bookingTimeTitleLabel = [[UILabel alloc] init];
        _bookingTimeTitleLabel.text = @"预 定 时 间：";
        _bookingTimeTitleLabel.font = [UIFont systemFontOfSize:14];
        _bookingTimeTitleLabel.textColor = TCGrayColor;
    }
    return _bookingTimeTitleLabel;
}

- (UILabel *)meetingRoomNameLabel {
    if (_meetingRoomNameLabel == nil) {
        _meetingRoomNameLabel = [[UILabel alloc] init];
        _meetingRoomNameLabel.font = [UIFont systemFontOfSize:14];
        _meetingRoomNameLabel.textColor = TCBlackColor;
        _meetingRoomNameLabel.numberOfLines = 0;
    }
    return _meetingRoomNameLabel;
}

- (UILabel *)meetingRoomNameTitleLabel {
    if (_meetingRoomNameTitleLabel == nil) {
        _meetingRoomNameTitleLabel = [[UILabel alloc] init];
        _meetingRoomNameTitleLabel.textColor =TCGrayColor;
        _meetingRoomNameTitleLabel.text = @"会议室预定：";
        _meetingRoomNameTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _meetingRoomNameTitleLabel;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    return _dateFormatter;
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
