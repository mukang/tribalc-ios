//
//  TCBookingTimeNoteView.m
//  individual
//
//  Created by 穆康 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingTimeNoteView.h"
#import "TCBookingTimeNoteItem.h"

@implementation TCBookingTimeNoteView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = TCRGBColor(239, 245, 245);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *middleLine = [self createLineView];
    [self addSubview:middleLine];
    
    UIView *bottomLine = [self createLineView];
    [self addSubview:bottomLine];
    
    TCBookingTimeNoteItem *normalItem = [[TCBookingTimeNoteItem alloc] initWithStyle:TCBookingTimeNoteItemStyleNormal];
    [self addSubview:normalItem];
    
    TCBookingTimeNoteItem *selectedItem = [[TCBookingTimeNoteItem alloc] initWithStyle:TCBookingTimeNoteItemStyleSelected];
    [self addSubview:selectedItem];
    
    TCBookingTimeNoteItem *disabledItem = [[TCBookingTimeNoteItem alloc] initWithStyle:TCBookingTimeNoteItemStyleDisabled];
    [self addSubview:disabledItem];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.text = @"会议预定时间为开始时间，每格均为30分钟";
    noteLabel.textColor = TCGrayColor;
    noteLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:noteLabel];
    
    [middleLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(38);
        make.height.mas_equalTo(0.5);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    [normalItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_top).offset(19);
        make.centerX.equalTo(self).offset(-80);
    }];
    [selectedItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(normalItem);
        make.centerX.equalTo(self);
    }];
    [disabledItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(normalItem);
        make.centerX.equalTo(self).offset(80);
    }];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_bottom).offset(-15);
    }];
}

- (UIView *)createLineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    return lineView;
}

@end
