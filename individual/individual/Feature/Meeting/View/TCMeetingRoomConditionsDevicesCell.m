//
//  TCMeetingRoomConditionsDevicesCell.m
//  individual
//
//  Created by 王帅锋 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomConditionsDevicesCell.h"

@interface TCMeetingRoomConditionsDevicesCell ()

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSMutableArray *btns;

@end

@implementation TCMeetingRoomConditionsDevicesCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)click:(UIButton *)btn {
    BOOL isDelete;
    if (btn.selected) {
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:TCBlackColor forState:UIControlStateNormal];
        btn.selected = NO;
        isDelete = YES;
    }else {
        [btn setBackgroundColor:TCRGBColor(151, 171, 234)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.selected = YES;
        isDelete = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(devicesCellDidClickDeviceBtn:isDelete:)]) {
        [self.delegate devicesCellDidClickDeviceBtn:btn.titleLabel.text isDelete:isDelete];
    }
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView);
        make.height.equalTo(@30);
//        make.bottom.equalTo(self.contentView).offset(-20);
    }];
}

- (void)setDevices:(NSArray *)devices {
    _devices = devices;
    if (self.devices && self.devices.count > 0) {
        CGFloat margin = 10;
        UIButton *previousBtn = nil;
        CGFloat currentX = 15;
        [self.btns removeAllObjects];
        for (int i = 0;i < self.devices.count; i++) {
            NSString *str = self.devices[i];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.btns addObject:btn];
            btn.selected = NO;
            btn.layer.borderWidth = 0.5;
            btn.layer.borderColor = TCBlackColor.CGColor;
            [btn setTitleColor:TCBlackColor forState:UIControlStateNormal];
            [btn setTitle:str forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            CGSize size = [str boundingRectWithSize:CGSizeMake(9999.0, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            CGFloat width = size.width + 15;
            if (!previousBtn) {
                if (self.devices.count == 1) {
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.contentView).offset(15);
                        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
                        make.width.equalTo(@(width));
                        make.height.equalTo(@25);
                        make.bottom.equalTo(self.contentView).offset(-20);
                    }];
                }else {
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.contentView).offset(15);
                        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
                        make.width.equalTo(@(width));
                        make.height.equalTo(@25);
                    }];
                    currentX += (width+margin);
                    previousBtn = btn;
                }
                
            }else {
                if (i == self.devices.count-1) {
                    if ((currentX + width + margin) <= (TCScreenWidth-15)) {
                        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(previousBtn.mas_right).offset(margin);
                            make.height.top.equalTo(previousBtn);
                            make.width.equalTo(@(width));
                            make.bottom.equalTo(self.contentView).offset(-20);
                        }];
                    }else {
                        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.contentView).offset(15);
                            make.height.equalTo(previousBtn);
                            make.width.equalTo(@(width));
                            make.top.equalTo(previousBtn.mas_bottom).offset(margin);
                            make.bottom.equalTo(self.contentView).offset(-20);
                        }];
                    }
                }else {
                    if ((currentX + width + margin) <= (TCScreenWidth-15)) {
                        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(previousBtn.mas_right).offset(margin);
                            make.height.top.equalTo(previousBtn);
                            make.width.equalTo(@(width));
                        }];
                        currentX += (width+margin);
                    }else {
                        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.contentView).offset(15);
                            make.height.equalTo(previousBtn);
                            make.width.equalTo(@(width));
                            make.top.equalTo(previousBtn.mas_bottom).offset(margin);
                        }];
                        currentX = 15;
                    }
                    previousBtn = btn;
                }
            }
        }
    }
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = TCBlackColor;
        _titleLabel.text = @"会议室设备";
    }
    return _titleLabel;
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
