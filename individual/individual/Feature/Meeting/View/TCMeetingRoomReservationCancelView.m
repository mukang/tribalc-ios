//
//  TCMeetingRoomReservationCancelView.m
//  individual
//
//  Created by 王帅锋 on 2017/11/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomReservationCancelView.h"
#import <TCCommonLibs/TCCommonButton.h>

@interface TCMeetingRoomReservationCancelView ()

@property (strong, nonatomic) UIView *centerView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *messageLabel;

@property (strong, nonatomic) TCCommonButton *cancelBtn;

@property (strong, nonatomic) UIButton *deleteBtn;

@end

@implementation TCMeetingRoomReservationCancelView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)setUpViews {
    self.backgroundColor = TCARGBColor(0, 0, 0, 0.5);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delete)];
    [self addGestureRecognizer:tap];
    [self addSubview:self.centerView];
    [self.centerView addSubview:self.titleLabel];
    [self.centerView addSubview:self.deleteBtn];
    [self.centerView addSubview:self.messageLabel];
    [self.centerView addSubview:self.cancelBtn];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@226);
        make.height.equalTo(@157);
        make.centerY.equalTo(self).offset(-40);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView).offset(30);
        make.right.equalTo(self.centerView).offset(-30);
        make.top.equalTo(self.centerView).offset(15);
        make.height.equalTo(@24);
    }];
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.centerView);
        make.width.height.equalTo(@30);
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.centerView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView).offset(20);
        make.bottom.equalTo(self.centerView).offset(-10);
        make.right.equalTo(self.centerView).offset(-20);
        make.height.equalTo(@40);
    }];
}

- (void)handleCilckCancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelViewDidClickCancelBtn)]) {
        [self.delegate cancelViewDidClickCancelBtn];
    }
}

- (void)delete {
    [self removeFromSuperview];
}

- (TCCommonButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [TCCommonButton buttonWithTitle:@"确  定" color:TCCommonButtonColorPurple target:self action:@selector(handleCilckCancel)];
        _cancelBtn.layer.cornerRadius = 4;
        _cancelBtn.clipsToBounds = YES;
    }
    return _cancelBtn;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = TCGrayColor;
        _messageLabel.text = @"是否确认取消该会议室的预定？";
        _messageLabel.font = [UIFont systemFontOfSize:13];
    }
    return _messageLabel;
}

- (UIButton *)deleteBtn {
    if (_deleteBtn == nil) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setImage:[UIImage imageNamed:@"editPhoneFailViewDelete"] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"取消订单";
        _titleLabel.textColor = TCBlackColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIView *)centerView {
    if (_centerView == nil) {
        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = [UIColor whiteColor];
        _centerView.layer.cornerRadius = 3;
        _centerView.clipsToBounds = YES;
    }
    return _centerView;
}

@end
