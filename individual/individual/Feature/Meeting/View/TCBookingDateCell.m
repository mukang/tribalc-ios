//
//  TCBookingDateCell.m
//  individual
//
//  Created by 穆康 on 2017/10/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingDateCell.h"

@interface TCBookingDateCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIImageView *markView;

@end

@implementation TCBookingDateCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UIImageView *markView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meeting_room_booking_date_mark"]];
    markView.hidden = YES;
    [self.contentView addSubview:markView];
    self.markView = markView;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    [markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(11, 11));
        make.centerY.equalTo(titleLabel);
        make.right.equalTo(titleLabel.mas_left).offset(-3);
    }];
}

- (void)setBookingDate:(TCBookingDate *)bookingDate {
    _bookingDate = bookingDate;
    
    self.titleLabel.text = bookingDate.dateStr;
    self.markView.hidden = !bookingDate.isSelected;
}

@end
