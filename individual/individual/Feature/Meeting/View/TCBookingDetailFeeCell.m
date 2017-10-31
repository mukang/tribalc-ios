//
//  TCBookingDetailFeeCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingDetailFeeCell.h"

@interface TCBookingDetailFeeCell ()

@property (strong, nonatomic) UILabel *feeTitleLabel;

@property (strong, nonatomic) UILabel *feeLabel;

@end

@implementation TCBookingDetailFeeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    [self.contentView addSubview:self.feeTitleLabel];
    [self.contentView addSubview:self.feeLabel];
    
    [self.feeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.bottom.equalTo(self.contentView);
    }];
    
    [self.feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.bottom.equalTo(self.feeTitleLabel);
    }];
}

- (UILabel *)feeLabel {
    if (_feeLabel == nil) {
        _feeLabel = [[UILabel alloc] init];
        _feeLabel.textColor = TCBlackColor;
        _feeLabel.font = [UIFont systemFontOfSize:14];
        _feeLabel.text = @"¥30";
    }
    return _feeLabel;
}

- (UILabel *)feeTitleLabel {
    if (_feeTitleLabel == nil) {
        _feeTitleLabel = [[UILabel alloc] init];
        _feeTitleLabel.font = [UIFont systemFontOfSize:14];
        _feeTitleLabel.textColor = TCGrayColor;
        _feeTitleLabel.text = @"费用估计：";
    }
    return _feeTitleLabel;
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
