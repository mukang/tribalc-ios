//
//  TCMeetingRoomBookingRecordCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomBookingRecordCell.h"
#import "TCMeetingRoomReservation.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <UIImageView+WebCache.h>

@interface TCMeetingRoomBookingRecordCell ()

@property (strong, nonatomic) UILabel *orderNumLabel;

@property (strong, nonatomic) UILabel *orderStatusLabel;

@property (strong, nonatomic) UIView *meetingRoomInfoView;

@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *moneyLabel;

@property (strong, nonatomic) UIImageView *meetingRoomImageView;

@property (strong, nonatomic) UILabel *meetingRoomTitleLabel;

@property (strong, nonatomic) UILabel *meetingRoomInfoLabel;

@property (strong, nonatomic) UILabel *meetingRoomFloorLabel;

@property (strong, nonatomic) UILabel *dateLabel;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TCMeetingRoomBookingRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setMeetingRoomReservation:(TCMeetingRoomReservation *)meetingRoomReservation {
    _meetingRoomReservation = meetingRoomReservation;
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (((meetingRoomReservation.conferenceBeginTime/1000) < now) && (now < (meetingRoomReservation.conferenceEndTime/1000))) {
        self.orderStatusLabel.text = @"已开始";
    }else if ((meetingRoomReservation.conferenceEndTime/1000) <= now) {
        self.orderStatusLabel.text = @"已结束";
    }else {
        self.orderStatusLabel.text = @"预定成功";
    }
    
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单号:%@",meetingRoomReservation.reservationNum];
    if ([meetingRoomReservation.status isKindOfClass:[NSString class]]) {
        if ([meetingRoomReservation.status isEqualToString:@"CANCEL"]) {
            self.orderStatusLabel.text = @"已取消";
        }else if ([meetingRoomReservation.status isEqualToString:@"PUTOFF_AND_PAYED"] || [meetingRoomReservation.status isEqualToString:@"PAYED"]) {
            self.orderStatusLabel.text = @"已完成";
        }
    }
    
    if ([meetingRoomReservation.picture isKindOfClass:[NSString class]]) {
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:meetingRoomReservation.picture];
        UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(97, 75)];
        [self.meetingRoomImageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    }
    
    self.meetingRoomTitleLabel.text = meetingRoomReservation.name;
    self.meetingRoomInfoLabel.text = meetingRoomReservation.subject;
    self.meetingRoomFloorLabel.text = [NSString stringWithFormat:@"%ld层",(long)meetingRoomReservation.floor];
    
    int64_t second = (meetingRoomReservation.conferenceEndTime - meetingRoomReservation.conferenceBeginTime)/1000;
    CGFloat hour = second/3600.0;
    int h = (int)hour;
    if (hour > h) {
        hour = h + 0.5;
    }
    
    NSString *startDateStr = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:meetingRoomReservation.conferenceBeginTime/1000]];
    NSString *endDateStr = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:meetingRoomReservation.conferenceEndTime/1000]];
    NSArray *startDateArr = [startDateStr componentsSeparatedByString:@" "];
    NSArray *endDateArr = [endDateStr componentsSeparatedByString:@" "];
    NSString *startStr = startDateArr[0];
    NSString *endStr = endDateArr[0];
    NSString *end = endDateStr;
    if ([startStr isEqualToString:endStr]) {
        if (endDateArr.count == 2) {
            end = endDateArr[1];
        }
    }
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@（%@小时）",startDateStr,end,@(hour)];
    self.dateLabel.text = dateStr;
    
    self.timeLabel.text = [NSString stringWithFormat:@"共计%@小时",@(hour)];
    
    NSString *moneyStr = [NSString stringWithFormat:@"实付：¥%@",@(meetingRoomReservation.totalFee)];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    [attStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, 3)];
    self.moneyLabel.attributedText = attStr;
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.orderNumLabel];
    [self.contentView addSubview:self.orderStatusLabel];
    [self.contentView addSubview:self.meetingRoomInfoView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.meetingRoomInfoView addSubview:self.meetingRoomImageView];
    [self.meetingRoomInfoView addSubview:self.meetingRoomTitleLabel];
    [self.meetingRoomInfoView addSubview:self.meetingRoomInfoLabel];
    [self.meetingRoomInfoView addSubview:self.meetingRoomFloorLabel];
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
        make.left.equalTo(self.orderNumLabel);
        make.right.equalTo(self.contentView).offset(-15);
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
        make.left.equalTo(self.meetingRoomTitleLabel);
        make.top.equalTo(self.meetingRoomTitleLabel.mas_bottom);
        make.height.equalTo(@25);
    }];
    
    [self.meetingRoomFloorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.meetingRoomTitleLabel);
        make.top.height.equalTo(self.meetingRoomInfoLabel);
        make.left.equalTo(self.meetingRoomInfoLabel.mas_right).offset(10);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.meetingRoomInfoLabel);
        make.right.equalTo(self.meetingRoomInfoView);
        make.top.equalTo(self.meetingRoomInfoLabel.mas_bottom).offset(4);
        make.height.equalTo(@20);
    }];
}

- (UILabel *)dateLabel {
    if (_dateLabel == nil) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:11];
        _dateLabel.textColor = TCGrayColor;
        _dateLabel.text = @"共计一小时";
    }
    return _dateLabel;
}

- (UILabel *)meetingRoomFloorLabel {
    if (_meetingRoomFloorLabel == nil) {
        _meetingRoomFloorLabel = [[UILabel alloc] init];
        _meetingRoomFloorLabel.font = [UIFont systemFontOfSize:12];
        _meetingRoomFloorLabel.textColor = TCGrayColor;
        _meetingRoomFloorLabel.textAlignment = NSTextAlignmentRight;
    }
    return _meetingRoomFloorLabel;
}

- (UILabel *)meetingRoomInfoLabel {
    if (_meetingRoomInfoLabel == nil) {
        _meetingRoomInfoLabel = [[UILabel alloc] init];
        _meetingRoomInfoLabel.font = [UIFont systemFontOfSize:12];
        _meetingRoomInfoLabel.textColor = TCGrayColor;
        [_meetingRoomInfoLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
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
        _meetingRoomImageView.contentMode = UIViewContentModeScaleAspectFill;
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
        _meetingRoomInfoView.backgroundColor = TCRGBColor(243, 243, 243);
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
