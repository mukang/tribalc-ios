//
//  TCMeetingRoomContactsView.m
//  individual
//
//  Created by 穆康 on 2017/11/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomContactsView.h"



@implementation TCMeetingRoomContactsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCBlackColor;
    nameLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = TCBlackColor;
    phoneLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:phoneLabel];
    self.phoneLabel = phoneLabel;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self addSubview:lineView];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self.mas_top).offset(22.5);
    }];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self.mas_bottom).offset(-22.5);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.right.centerY.equalTo(self);
    }];
}



@end
