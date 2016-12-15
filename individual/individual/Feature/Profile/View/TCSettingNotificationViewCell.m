//
//  TCSettingNotificationViewCell.m
//  individual
//
//  Created by 穆康 on 2016/12/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSettingNotificationViewCell.h"
#import <Masonry.h>

@interface TCSettingNotificationViewCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UISwitch *switchButton;

@end

@implementation TCSettingNotificationViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"消息通知";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = TCRGBColor(42, 42, 42);
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UISwitch *switchButton = [[UISwitch alloc] init];
    [switchButton addTarget:self action:@selector(handleChangeSwitchButton:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:switchButton];
    self.switchButton = switchButton;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.width.mas_equalTo(100);
        make.top.bottom.equalTo(weakSelf.contentView);
    }];
    
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.centerY.equalTo(weakSelf.contentView.mas_centerY);
    }];
}

- (void)handleChangeSwitchButton:(UISwitch *)sender {
    
}

@end
