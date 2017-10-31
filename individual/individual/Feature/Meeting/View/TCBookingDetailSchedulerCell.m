//
//  TCBookingDetailSchedulerCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingDetailSchedulerCell.h"

@interface TCBookingDetailSchedulerCell ()

@property (strong, nonatomic) UILabel *schedulerTitleLabel;

@property (strong, nonatomic) UILabel *schedulerLabel;

@end

@implementation TCBookingDetailSchedulerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    [self.contentView addSubview:self.schedulerTitleLabel];
    [self.contentView addSubview:self.schedulerLabel];
    
    [self.schedulerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView);
    }];
    
    [self.schedulerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.schedulerTitleLabel.mas_right);
        make.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

- (UILabel *)schedulerLabel {
    if (_schedulerLabel == nil) {
        _schedulerLabel = [[UILabel alloc] init];
        _schedulerLabel.font = [UIFont systemFontOfSize:14];
        _schedulerLabel.textColor = TCBlackColor;
        _schedulerLabel.text = @"小雨 1567890000";
    }
    return _schedulerLabel;
}

- (UILabel *)schedulerTitleLabel {
    if (_schedulerTitleLabel == nil) {
        _schedulerTitleLabel = [[UILabel alloc] init];
        _schedulerTitleLabel.textColor = TCGrayColor;
        _schedulerTitleLabel.font = [UIFont systemFontOfSize:14];
        _schedulerTitleLabel.text = @"预订人：";
    }
    return _schedulerTitleLabel;
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
