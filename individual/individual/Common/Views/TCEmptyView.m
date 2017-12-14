//
//  TCEmptyView.m
//  individual
//
//  Created by 王帅锋 on 2017/12/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCEmptyView.h"

#import <TCCommonLibs/TCCommonButton.h>

@interface TCEmptyView ()

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *desLabel;

@property (strong, nonatomic) TCCommonButton *commonBtn;

@end

@implementation TCEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpViews];
    }
    return self;
}

- (void)setDes:(NSString *)des {
    _des = des;

    self.desLabel.text = des;
}

- (void)setType:(TCEmptyType)type {
    _type = type;
    
    NSString *imageName;
    NSString *des;
    if (type == TCEmptyTypeNoCertify) {
        imageName = @"no_certify_record";
        des = @"暂未身份认证";
        self.commonBtn.hidden = NO;
        [self.commonBtn setTitle:@"身份认证" forState:UIControlStateNormal];
    }else if (type == TCEmptyTypeNoBillResult) {
        imageName = @"no_bill_result";
        des = @"暂无对账单";
    }else if (type == TCEmptyTypeNoBindCompany) {
        imageName = @"no_bind_company";
        des = @"暂未绑定公司";
        self.commonBtn.hidden = NO;
        [self.commonBtn setTitle:@"绑定公司" forState:UIControlStateNormal];
    }else if (type == TCEmptyTypeNoMeetingRoom) {
        imageName = @"no_meetingRoom_result";
        des = @"暂无会议室预定记录";
    }else if (type == TCEmptyTypeNoRepairRecord) {
        imageName = @"no_repair_record";
        des = @"暂无报修单记录";
    }else if (type == TCEmptyTypeNoSearchResult) {
        imageName = @"no_search_result";
        des = @"找不到任何与“xxxx”匹配的内容";
    }else if (type == TCEmptyTypeNoBankCardResult) {
        imageName = @"no_bandCard_result";
        des = @"暂无银行卡";
    }else if (type == TCEmptyTypeNoMaintainRecord) {
        imageName = @"no_maintain_record";
        des = @"暂无物业维修记录";
    }else if (type == TCEmptyTypeNoHistoryBillRecord) {
        imageName = @"no_history_bill";
        des = @"暂无历史账单";
    }
    self.imageView.image = [UIImage imageNamed:imageName];
    self.desLabel.text = des;
}

- (void)setUpViews {
    self.backgroundColor = TCRGBColor(239, 245, 245);
    [self addSubview:self.imageView];
    [self addSubview:self.desLabel];
    [self addSubview:self.commonBtn];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-50);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.imageView.mas_bottom).offset(15);
    }];
    
    [self.commonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.desLabel.mas_bottom).offset(40);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
    }];
}

- (void)btnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(emptyViewBtnDidClick)]) {
        [self.delegate emptyViewBtnDidClick];
    }
}

#pragma mark getter
- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:16];
        _desLabel.textColor = TCRGBColor(186, 186, 186);
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}

- (TCCommonButton *)commonBtn {
    if (_commonBtn == nil) {
        _commonBtn = [TCCommonButton buttonWithTitle:@"" color:TCCommonButtonColorPurple target:self action:@selector(btnClick)];
        _commonBtn.hidden = YES;
    }
    return _commonBtn;
}

@end
