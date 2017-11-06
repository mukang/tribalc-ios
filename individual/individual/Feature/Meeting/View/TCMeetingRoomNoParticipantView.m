//
//  TCMeetingRoomNoParticipantView.m
//  individual
//
//  Created by 穆康 on 2017/11/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomNoParticipantView.h"

@implementation TCMeetingRoomNoParticipantView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meeting_room_no_participant"]];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无参会人";
    label.textColor = TCBlackColor;
    label.font = [UIFont systemFontOfSize:16];
    [self addSubview:label];
    
    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.text = @"点击下方按钮即可添加";
    subLabel.textColor = TCGrayColor;
    subLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:subLabel];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(91), TCRealValue(95)));
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(TCRealValue(157));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(imageView.mas_bottom).offset(10);
    }];
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(label.mas_bottom).offset(10);
    }];
}

@end
