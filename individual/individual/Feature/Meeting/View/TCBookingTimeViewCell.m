//
//  TCBookingTimeViewCell.m
//  individual
//
//  Created by 穆康 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingTimeViewCell.h"

@interface TCBookingTimeViewCell ()

@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation TCBookingTimeViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}

- (void)setBookingTime:(TCBookingTime *)bookingTime {
    _bookingTime = bookingTime;
    
    self.titleLabel.text = bookingTime.startTimeStr;
    
    switch (bookingTime.status) {
        case TCBookingTimeStatusNormal:
            self.layer.borderColor = TCSeparatorLineColor.CGColor;
            self.backgroundColor = [UIColor whiteColor];
            self.titleLabel.textColor = TCBlackColor;
            break;
        case TCBookingTimeStatusSelected:
            self.layer.borderColor = [UIColor clearColor].CGColor;
            self.backgroundColor = TCRGBColor(151, 171, 234);
            self.titleLabel.textColor = [UIColor whiteColor];
            break;
        case TCBookingTimeStatusDisabled:
            self.layer.borderColor = [UIColor clearColor].CGColor;
            self.backgroundColor = TCSeparatorLineColor;
            self.titleLabel.textColor = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
}

@end
