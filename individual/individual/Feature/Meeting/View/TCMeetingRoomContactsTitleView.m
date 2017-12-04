//
//  TCMeetingRoomContactsTitleView.m
//  individual
//
//  Created by 穆康 on 2017/12/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomContactsTitleView.h"

@interface TCMeetingRoomContactsTitleView ()

@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation TCMeetingRoomContactsTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = TCBackgroundColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCGrayColor;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

@end
