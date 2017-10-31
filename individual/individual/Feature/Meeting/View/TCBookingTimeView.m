//
//  TCBookingTimeView.m
//  individual
//
//  Created by 穆康 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBookingTimeView.h"
#import "TCBookingTimeViewCell.h"
#import "TCBookingTime.h"

#define cellCount 30

@interface TCBookingTimeView ()

@property (strong, nonatomic) NSMutableArray *cells;

@end

@implementation TCBookingTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    UILabel *forenoonLabel = [self createLabelWithTitle:@"上午"];
    [contentView addSubview:forenoonLabel];
    
    UILabel *afternoonLabel = [self createLabelWithTitle:@"下午"];
    [contentView addSubview:afternoonLabel];
    
    UILabel *nightLabel = [self createLabelWithTitle:@"晚上"];
    [contentView addSubview:nightLabel];
    
    UIView *firstLineView = [self createLineView];
    [contentView addSubview:firstLineView];
    
    UIView *secondLineView = [self createLineView];
    [contentView addSubview:secondLineView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.mas_equalTo(TCScreenWidth);
    }];
    [forenoonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(15);
        make.top.equalTo(contentView).offset(15);
    }];
    
    self.cells = [NSMutableArray arrayWithCapacity:cellCount];
    TCBookingTimeViewCell *lastCell = nil;
    int column = 4;
    CGFloat padding = 15, top = 15, bottom = 20, marginH = 6, marginV = 15;
    CGFloat width = (TCScreenWidth - padding * 2.0 - marginH * (column - 1)) / 4.0;
    CGFloat height = 25;
    for (int i=0; i<cellCount; i++) {
        TCBookingTimeViewCell *cell = [[TCBookingTimeViewCell alloc] init];
        cell.layer.cornerRadius = height / 2.0;
        cell.layer.borderWidth = 0.5;
        cell.layer.masksToBounds = YES;
        [contentView addSubview:cell];
        [self.cells addObject:cell];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBookingTimeCell:)];
        [cell addGestureRecognizer:tap];
        
        [cell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
        }];
        
        if (!lastCell) {
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(forenoonLabel.mas_bottom).offset(top);
                make.left.equalTo(contentView).offset(padding);
            }];
        } else {
            if (i == 8) {
                [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(contentView);
                    make.top.equalTo(lastCell.mas_bottom).offset(bottom);
                    make.height.mas_equalTo(0.5);
                }];
                [afternoonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(forenoonLabel);
                    make.top.equalTo(firstLineView.mas_bottom).offset(top);
                }];
                [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(afternoonLabel);
                    make.top.equalTo(afternoonLabel.mas_bottom).offset(top);
                }];
            } else if (i == 20) {
                [secondLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(contentView);
                    make.top.equalTo(lastCell.mas_bottom).offset(bottom);
                    make.height.mas_equalTo(0.5);
                }];
                [nightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(forenoonLabel);
                    make.top.equalTo(secondLineView.mas_bottom).offset(top);
                }];
                [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(nightLabel);
                    make.top.equalTo(nightLabel.mas_bottom).offset(top);
                }];
            } else if (i % column == 0) {
                [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(contentView).offset(padding);
                    make.top.equalTo(lastCell.mas_bottom).offset(marginV);
                }];
            } else {
                [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(lastCell.mas_right).offset(marginH);
                    make.top.equalTo(lastCell);
                }];
            }
        }
        
        lastCell = cell;
    }
    
    [lastCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(contentView.mas_bottom).offset(-bottom);
    }];
}

- (void)reloadDataWithBookingTimeArray:(NSArray *)bookingTimeArray {
    for (int i=0; i<cellCount; i++) {
        TCBookingTimeViewCell *cell = self.cells[i];
        TCBookingTime *bookingTime = bookingTimeArray[i];
        cell.bookingTime = bookingTime;
    }
}

- (void)handleTapBookingTimeCell:(UITapGestureRecognizer *)tapGesture {
    if ([self.bookingTimedelegate respondsToSelector:@selector(bookingTimeView:didTapBookingTimeCellWithBookingTime:)]) {
        TCBookingTimeViewCell *cell = (TCBookingTimeViewCell *)tapGesture.view;
        [self.bookingTimedelegate bookingTimeView:self didTapBookingTimeCellWithBookingTime:cell.bookingTime];
    }
}

- (UILabel *)createLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textColor = TCBlackColor;
    label.font = [UIFont systemFontOfSize:12];
    return label;
}

- (UIView *)createLineView {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    return lineView;
}

@end
