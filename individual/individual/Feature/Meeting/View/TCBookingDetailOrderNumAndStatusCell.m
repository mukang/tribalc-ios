//
//  TCBookingDetailOrderNumAndStatusCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingDetailOrderNumAndStatusCell.h"

@interface TCBookingDetailOrderNumAndStatusCell ()

@property (strong, nonatomic) UILabel *orderNumTitleLabel;

@property (strong, nonatomic) UILabel *orderNumLabel;

@property (strong, nonatomic) UILabel *statusLabel;

@end

@implementation TCBookingDetailOrderNumAndStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setReservationNum:(NSString *)reservationNum {
    _reservationNum = reservationNum;
    self.orderNumLabel.text = reservationNum;
}

- (void)setStatus:(NSString *)status {
    _status = status;
    if ([status isKindOfClass:[NSString class]]) {
        if ([status isEqualToString:@"RESERVED"]) {
            self.statusLabel.text = @"预定成功";
        }else if ([status isEqualToString:@"CANCEL"]) {
            self.statusLabel.text = @"已取消";
        }else if ([status isEqualToString:@"FINISHED"]) {
            self.statusLabel.text = @"已完成";
        }
    }
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.orderNumTitleLabel];
    [self.contentView addSubview:self.orderNumLabel];
    [self.contentView addSubview:self.statusLabel];
    
    [self.orderNumTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderNumTitleLabel.mas_right);
        make.top.bottom.equalTo(self.orderNumTitleLabel);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.bottom.equalTo(self.orderNumTitleLabel);
    }];
}

- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:14];
        _statusLabel.textColor = TCBlackColor;
        _statusLabel.text = @"预定成功";
    }
    return _statusLabel;
}

- (UILabel *)orderNumLabel {
    if (_orderNumLabel == nil) {
        _orderNumLabel = [[UILabel alloc] init];
        _orderNumLabel.textColor = TCBlackColor;
        _orderNumLabel.font = [UIFont systemFontOfSize:14];
        _orderNumLabel.text = @"12345678";
    }
    return _orderNumLabel;
}

- (UILabel *)orderNumTitleLabel {
    if (_orderNumTitleLabel == nil) {
        _orderNumTitleLabel = [[UILabel alloc] init];
        _orderNumTitleLabel.textColor = TCGrayColor;
        _orderNumTitleLabel.font = [UIFont systemFontOfSize:14];
        _orderNumTitleLabel.text = @"订单号：";
    }
    return _orderNumTitleLabel;
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
