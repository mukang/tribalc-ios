//
//  TCBookingDetailNameAndTimeCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingDetailNameAndTimeCell.h"

@interface TCBookingDetailNameAndTimeCell ()

@property (strong, nonatomic) UILabel *meetingRoomNameTitleLabel;

@property (strong, nonatomic) UILabel *meetingRoomNameLabel;

@property (strong, nonatomic) UILabel *bookingTimeTitleLabel;

@property (strong, nonatomic) UILabel *bookingTimeLabel;

@property (strong, nonatomic) UILabel *timesLabel;

@end

@implementation TCBookingDetailNameAndTimeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
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
    }];
    
    [self.bookingTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.meetingRoomNameLabel.mas_bottom).offset(10);
    }];
    
    [self.bookingTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookingTimeTitleLabel.mas_right);
        make.top.equalTo(self.bookingTimeTitleLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.timesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bookingTimeLabel);
        make.top.equalTo(self.bookingTimeLabel.mas_bottom).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
}

- (UILabel *)timesLabel {
    if (_timesLabel == nil) {
        _timesLabel = [[UILabel alloc] init];
        _timesLabel.textColor = TCBlackColor;
        _timesLabel.font = [UIFont systemFontOfSize:14];
        _timesLabel.text = @"12:30-1:30（一小时）";
    }
    return _timesLabel;
}

- (UILabel *)bookingTimeLabel {
    if (_bookingTimeLabel == nil) {
        _bookingTimeLabel = [[UILabel alloc] init];
        _bookingTimeLabel.font = [UIFont systemFontOfSize:14];
        _bookingTimeLabel.textColor = TCBlackColor;
        _bookingTimeLabel.text = @"2017-09-29（周四）";
    }
    return _bookingTimeLabel;
}

- (UILabel *)bookingTimeTitleLabel {
    if (_bookingTimeTitleLabel == nil) {
        _bookingTimeTitleLabel = [[UILabel alloc] init];
    }
    return _bookingTimeTitleLabel;
}

- (UILabel *)meetingRoomNameLabel {
    if (_meetingRoomNameLabel == nil) {
        _meetingRoomNameLabel = [[UILabel alloc] init];
        _meetingRoomNameLabel.font = [UIFont systemFontOfSize:14];
        _meetingRoomNameLabel.textColor = TCBlackColor;
        _meetingRoomNameLabel.text = @"星光时代UDC 会议室";
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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
