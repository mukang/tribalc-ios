//
//  TCMeetingRoomSearchResultCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomSearchResultCell.h"

@interface TCMeetingRoomSearchResultCell ()

@property (strong, nonatomic) UIImageView *leftImageView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *floorLabel;

@property (strong, nonatomic) UILabel *numLabel;

@property (strong, nonatomic) UILabel *priceLabel;

@property (strong, nonatomic) UIView *devicesView;

@end

@implementation TCMeetingRoomSearchResultCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.floorLabel];
    [self.contentView addSubview:self.numLabel];
    [self.contentView addSubview:self.priceLabel];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(12);
        make.width.equalTo(@143);
        make.height.equalTo(@108);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(15);
        make.top.equalTo(self.leftImageView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.floorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.width.equalTo(@55);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.floorLabel.mas_right);
        make.top.equalTo(self.floorLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.numLabel);
    }];
    
    [self.devicesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.floorLabel.mas_bottom).offset(20);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@45);
    }];
}

- (UIView *)devicesView {
    if (_devicesView == nil) {
        _devicesView = [[UIView alloc] init];
    }
    return _devicesView;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textColor = TCBlackColor;
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UILabel *)numLabel {
    if (_numLabel == nil) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont systemFontOfSize:12];
        _numLabel.textColor = TCBlackColor;
    }
    return _numLabel;
}

- (UILabel *)floorLabel {
    if (_floorLabel == nil) {
        _floorLabel = [[UILabel alloc] init];
        _floorLabel.font = [UIFont systemFontOfSize:12];
        _floorLabel.textColor = TCBlackColor;
    }
    return _floorLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = TCBlackColor;
    }
    return _titleLabel;
}

- (UIImageView *)leftImageView {
    if (_leftImageView == nil) {
        _leftImageView = [[UIImageView alloc] init];
    }
    return _leftImageView;
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
