//
//  TCHomeMessageWelfareCell.m
//  individual
//
//  Created by 王帅锋 on 2017/8/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeMessageWelfareCell.h"
#import "TCHomeMessage.h"

@interface TCHomeMessageWelfareCell ()

@property (strong, nonatomic) UILabel *moneyLabel;

@property (strong, nonatomic) UILabel *comLabel;

@property (strong, nonatomic) UILabel *desLabel;

@end

@implementation TCHomeMessageWelfareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpSubviews];
    }
    return self;
}

- (void)setHomeMessage:(TCHomeMessage *)homeMessage {
    [super setHomeMessage:homeMessage];
    
    self.moneyLabel.text = homeMessage.messageBody.body;
    self.comLabel.text = homeMessage.messageBody.desc;
    self.desLabel.text = homeMessage.messageBody.remark;
}

- (void)setUpSubviews {
    [self.middleView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(TCRealValue(174)-72));
    }];
    
    [self.middleView addSubview:self.moneyLabel];
    [self.middleView addSubview:self.comLabel];
    [self.middleView addSubview:self.desLabel];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView).offset(TCRealValue(15));
        make.left.right.equalTo(self.middleView);
        make.height.equalTo(@(TCRealValue(40)));
    }];
    
    [self.comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLabel.mas_bottom);
        make.left.right.equalTo(self.moneyLabel);
        make.height.equalTo(@(TCRealValue(18)));
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comLabel.mas_bottom);
        make.left.right.height.equalTo(self.comLabel);
    }];
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.textColor = TCBlackColor;
        _desLabel.font = [UIFont systemFontOfSize:12];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.backgroundColor = [UIColor clearColor];
    }
    return _desLabel;
}

- (UILabel *)comLabel {
    if (_comLabel == nil) {
        _comLabel = [[UILabel alloc] init];
        _comLabel.textColor = TCBlackColor;
        _comLabel.font = [UIFont systemFontOfSize:12];
        _comLabel.textAlignment = NSTextAlignmentCenter;
        _comLabel.backgroundColor = [UIColor clearColor];
    }
    return _comLabel;
}

- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor redColor];
        _moneyLabel.font = [UIFont systemFontOfSize:32];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.backgroundColor = [UIColor clearColor];
    }
    return _moneyLabel;
}

@end
