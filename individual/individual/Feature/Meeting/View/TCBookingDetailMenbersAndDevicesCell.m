//
//  TCBookingDetailMenbersAndDevicesCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingDetailMenbersAndDevicesCell.h"

@interface TCBookingDetailMenbersAndDevicesCell ()

@property (strong, nonatomic) UILabel *menbersTitleLabel;

@property (strong, nonatomic) UIView *menbersView;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UILabel *openTimeTitleLabel;

@property (strong, nonatomic) UILabel *openTimeLabel;

@property (strong, nonatomic) UILabel *deviceTitleLabel;

@property (strong, nonatomic) UILabel *devicesLabel;

@property (strong, nonatomic) UILabel *numberTitleLabel;

@property (strong, nonatomic) UILabel *numberLabel;

@end

@implementation TCBookingDetailMenbersAndDevicesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    [self.contentView addSubview:self.menbersTitleLabel];
    [self.contentView addSubview:self.menbersView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.openTimeTitleLabel];
    [self.contentView addSubview:self.openTimeLabel];
    [self.contentView addSubview:self.deviceTitleLabel];
    [self.contentView addSubview:self.devicesLabel];
    [self.contentView addSubview:self.numberTitleLabel];
    [self.contentView addSubview:self.numberLabel];
    
    [self.menbersTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.menbersView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menbersTitleLabel.mas_right);
        make.top.equalTo(self.menbersTitleLabel);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@50);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.menbersView.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    
    [self.openTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.lineView.mas_bottom).offset(15);
    }];
    
    [self.openTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.openTimeTitleLabel.mas_right);
        make.top.equalTo(self.openTimeTitleLabel);
    }];
    
    [self.deviceTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menbersTitleLabel);
        make.top.equalTo(self.openTimeTitleLabel.mas_bottom).offset(10);
    }];
    
    [self.devicesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.deviceTitleLabel.mas_right);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.deviceTitleLabel);
    }];
    
    [self.numberTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.menbersTitleLabel);
        make.top.equalTo(self.devicesLabel.mas_bottom).offset(10);
        make.height.equalTo(@15);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberTitleLabel.mas_right);
        make.top.equalTo(self.numberTitleLabel);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
}

- (UILabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.font = [UIFont systemFontOfSize:14];
        _numberLabel.textColor = TCBlackColor;
        _numberLabel.text = @"可容纳6-8人";
    }
    return _numberLabel;
}

- (UILabel *)numberTitleLabel {
    if (_numberTitleLabel == nil) {
        _numberTitleLabel = [[UILabel alloc] init];
        _numberTitleLabel.textColor = TCGrayColor;
        _numberTitleLabel.font = [UIFont systemFontOfSize:14];
        _numberTitleLabel.text = @"容纳人数：";
    }
    return _numberTitleLabel;
}

- (UILabel *)devicesLabel {
    if (_devicesLabel == nil) {
        _devicesLabel = [[UILabel alloc] init];
        _devicesLabel.textColor = TCBlackColor;
        _devicesLabel.font = [UIFont systemFontOfSize:14];
        _devicesLabel.numberOfLines = 0;
        _devicesLabel.text = @"投影仪  窗户  矿泉人  白板  桌子  椅子  纸笔  柠檬茶  玫瑰茶  无线网络";
    }
    return _devicesLabel;
}

- (UILabel *)deviceTitleLabel {
    if (_deviceTitleLabel == nil) {
        _deviceTitleLabel = [[UILabel alloc] init];
        _deviceTitleLabel.textColor = TCBlackColor;
        _deviceTitleLabel.font = [UIFont systemFontOfSize:14];
        _deviceTitleLabel.text = @"配套设施：";
    }
    return _deviceTitleLabel;
}

- (UILabel *)openTimeLabel {
    if (_openTimeLabel == nil) {
        _openTimeLabel = [[UILabel alloc] init];
        _openTimeLabel.textColor = TCBlackColor;
        _openTimeLabel.font = [UIFont systemFontOfSize:14];
        _openTimeLabel.text = @"9:00-20:00";
    }
    return _openTimeLabel;
}

- (UILabel *)openTimeTitleLabel {
    if (_openTimeTitleLabel == nil) {
        _openTimeTitleLabel = [[UILabel alloc] init];
        _openTimeTitleLabel.textColor = TCGrayColor;
        _openTimeTitleLabel.text = @"开放时间：";
        _openTimeTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _openTimeTitleLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = TCSeparatorLineColor;
    }
    return _lineView;
}

- (UIView *)menbersView {
    if (_menbersView == nil) {
        _menbersView = [[UIView alloc] init];
    }
    return _menbersView;
}

- (UILabel *)menbersTitleLabel {
    if (_menbersTitleLabel == nil) {
        _menbersTitleLabel = [[UILabel alloc] init];
        _menbersTitleLabel.textColor = TCGrayColor;
        _menbersTitleLabel.font = [UIFont systemFontOfSize:14];
        _menbersTitleLabel.text = @"参  会  人：";
    }
    return _menbersTitleLabel;
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
