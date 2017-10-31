//
//  TCBookingDetailPayTypeCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingDetailPayTypeCell.h"

@interface TCBookingDetailPayTypeCell ()

@property (strong, nonatomic) UILabel *payTypeTitleLabel;

@property (strong, nonatomic) UILabel *payTypeLabel;

@end

@implementation TCBookingDetailPayTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    [self.contentView addSubview:self.payTypeTitleLabel];
    [self.contentView addSubview:self.payTypeLabel];
    
    [self.payTypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.bottom.equalTo(self.payTypeTitleLabel);
    }];
}

- (UILabel *)payTypeLabel {
    if (_payTypeLabel == nil) {
        _payTypeLabel = [[UILabel alloc] init];
        _payTypeLabel.textColor = TCBlackColor;
        _payTypeLabel.font = [UIFont systemFontOfSize:14];
        _payTypeLabel.text = @"企业支付";
    }
    return _payTypeLabel;
}

- (UILabel *)payTypeTitleLabel {
    if (_payTypeTitleLabel == nil) {
        _payTypeTitleLabel = [[UILabel alloc] init];
        _payTypeTitleLabel.font = [UIFont systemFontOfSize:14];
        _payTypeTitleLabel.textColor = TCGrayColor;
        _payTypeTitleLabel.text = @"支付类型：";
    }
    return _payTypeTitleLabel;
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
