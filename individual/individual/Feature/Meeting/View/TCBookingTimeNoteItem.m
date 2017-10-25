//
//  TCBookingTimeNoteItem.m
//  individual
//
//  Created by 穆康 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingTimeNoteItem.h"

@interface TCBookingTimeNoteItem ()

@property (weak, nonatomic) UIView *noteView;
@property (weak, nonatomic) UILabel *noteLabel;

@end

@implementation TCBookingTimeNoteItem

- (instancetype)initWithStyle:(TCBookingTimeNoteItemStyle)style {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _style = style;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIView *noteView = [[UIView alloc] init];
    [self addSubview:noteView];
    
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.textColor = TCGrayColor;
    noteLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:noteLabel];
    
    switch (_style) {
        case TCBookingTimeNoteItemStyleNormal:
            noteView.layer.borderColor = TCGrayColor.CGColor;
            noteView.layer.borderWidth = 0.5;
            noteView.backgroundColor = [UIColor whiteColor];
            noteLabel.text = @"可预订";
            break;
        case TCBookingTimeNoteItemStyleSelected:
            noteView.backgroundColor = TCRGBColor(151, 171, 234);
            noteLabel.text = @"已选中";
            break;
        case TCBookingTimeNoteItemStyleDisabled:
            noteView.backgroundColor = TCSeparatorLineColor;
            noteLabel.text = @"不可预订";
            break;
            
        default:
            break;
    }
    
    self.noteView = noteView;
    self.noteLabel = noteLabel;
}

- (void)setupConstraints {
    [self.noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(9, 9));
        make.centerY.equalTo(self);
        make.left.equalTo(self);
    }];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.noteView.mas_right).offset(5);
        make.right.equalTo(self);
    }];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
    }];
}

@end
