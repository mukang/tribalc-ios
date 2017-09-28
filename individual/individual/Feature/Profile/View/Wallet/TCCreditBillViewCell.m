//
//  TCCreditBillViewCell.m
//  individual
//
//  Created by 王帅锋 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreditBillViewCell.h"
#import "TCCreditBill.h"

@interface TCCreditBillViewCell ()

@property (strong, nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *subTitleLabel;

@property (strong, nonatomic) UILabel *moneyLabel;

@property (strong, nonatomic) UILabel *overdueLabel;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) UIView *lineView;

@end

@implementation TCCreditBillViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setCreditBill:(TCCreditBill *)creditBill {
    _creditBill = creditBill;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@账单",creditBill.monthDate];
    self.subTitleLabel.text = [NSString stringWithFormat:@"%@-%@",[self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:creditBill.zeroDate/1000]],[self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:creditBill.billDate/1000]]];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",creditBill.amount];
    if ([creditBill.status isKindOfClass:[NSString class]] &&[creditBill.status isEqualToString:@"OVERDUE"]) {
        self.overdueLabel.hidden = NO;
    }else {
        self.overdueLabel.hidden = YES;
    }
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.overdueLabel];
    [self.contentView addSubview:self.lineView];
    
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(TCRealValue(15));
//        make.centerY.equalTo(self.contentView);
//        make.width.height.equalTo(@44);
//    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(TCRealValue(20));
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-TCRealValue(15));
        make.top.equalTo(self.titleLabel);
    }];

    [self.overdueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.moneyLabel);
        make.top.equalTo(self.subTitleLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(TCRealValue(20));
        make.right.equalTo(self.contentView).offset(-TCRealValue(20));
        make.bottom.equalTo(self.contentView).offset(-0.5);
        make.height.equalTo(@0.5);
    }];
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = TCSeparatorLineColor;
    }
    return _lineView;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy/MM/dd"];
    }
    return _dateFormatter;
}

- (UILabel *)overdueLabel {
    if (_overdueLabel == nil) {
        _overdueLabel = [[UILabel alloc] init];
        _overdueLabel.font = [UIFont systemFontOfSize:12];
        _overdueLabel.textAlignment = NSTextAlignmentRight;
        _overdueLabel.textColor = TCRGBColor(244, 55, 49);
        _overdueLabel.text = @"已逾期";
        _overdueLabel.hidden = YES;
    }
    return _overdueLabel;
}

- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:16];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.textColor = TCBlackColor;
        _moneyLabel.text = @"¥2099";
    }
    return _moneyLabel;
}

- (UILabel *)subTitleLabel {
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        _subTitleLabel.textColor = TCGrayColor;
        _subTitleLabel.text = @"2017/02/12-2017/03/11";
    }
    return _subTitleLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = TCBlackColor;
        _titleLabel.text = @"六月账单";
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = 22;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.image = [UIImage imageNamed:@"login_account_icon"];
    }
    return _iconImageView;
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
