//
//  TCApartmentWithholdInfoView.m
//  individual
//
//  Created by 穆康 on 2017/6/29.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCApartmentWithholdInfoView.h"
#import <TCCommonLibs/TCExtendButton.h>
#import "TCRentProtocolWithholdInfo.h"

@interface TCApartmentWithholdInfoView ()

@property (weak, nonatomic) UIView *topLine;
@property (weak, nonatomic) UIView *separaterLine;
@property (weak, nonatomic) UIView *bottomLine;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) TCExtendButton *editButton;
@property (weak, nonatomic) UIImageView *bankCardBgView;
@property (weak, nonatomic) UIImageView *bankCardLogoView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *typeLabel;
@property (weak, nonatomic) UILabel *numLabel;

@property (strong, nonatomic) NSArray *bankInfoList;

@end

@implementation TCApartmentWithholdInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:topLine];
    
    UIView *separaterLine = [[UIView alloc] init];
    separaterLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:separaterLine];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:bottomLine];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"代扣银行卡";
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:TCRealValue(14)];
    [self addSubview:titleLabel];
    
    TCExtendButton *editButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [editButton setBackgroundImage:[UIImage imageNamed:@"apartment_withhold_edit"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(handleClickEditButton:) forControlEvents:UIControlEventTouchUpInside];
    editButton.hitTestSlop = UIEdgeInsetsMake(-10, -20, -10, -20);
    [self addSubview:editButton];
    
    UIImageView *bankCardBgView = [[UIImageView alloc] init];
    [self addSubview:bankCardBgView];
    
    UIImageView *bankCardLogoView = [[UIImageView alloc] init];
    [bankCardBgView addSubview:bankCardLogoView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:TCRealValue(16)];
    [bankCardBgView addSubview:nameLabel];
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.text = @"储蓄卡";
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.font = [UIFont systemFontOfSize:TCRealValue(12)];
    [bankCardBgView addSubview:typeLabel];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.textColor = [UIColor whiteColor];
    numLabel.font = [UIFont systemFontOfSize:TCRealValue(20)];
    [bankCardBgView addSubview:numLabel];
    
    self.topLine = topLine;
    self.separaterLine = separaterLine;
    self.bottomLine = bottomLine;
    self.titleLabel = titleLabel;
    self.editButton = editButton;
    self.bankCardBgView = bankCardBgView;
    self.bankCardLogoView = bankCardLogoView;
    self.nameLabel = nameLabel;
    self.typeLabel = typeLabel;
    self.numLabel = numLabel;
}

- (void)setupConstraints {
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.left.right.equalTo(self);
    }];
    [self.separaterLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.topLine.mas_bottom).offset(TCRealValue(41));
        make.left.right.equalTo(self);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.bottom.left.right.equalTo(self);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self.topLine.mas_bottom).offset(TCRealValue(20.5));
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(15.5), TCRealValue(15.5)));
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self).offset(-20);
    }];
    [self.bankCardBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(334.5), TCRealValue(107)));
        make.top.equalTo(self.separaterLine.mas_bottom).offset(TCRealValue(8));
        make.centerX.equalTo(self);
    }];
    [self.bankCardLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(45), TCRealValue(45)));
        make.left.equalTo(self.bankCardBgView).offset(TCRealValue(13));
        make.top.equalTo(self.bankCardBgView).offset(TCRealValue(14));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bankCardLogoView.mas_right).offset(TCRealValue(13));
        make.top.equalTo(self.bankCardBgView).offset(TCRealValue(20));
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.bankCardBgView).offset(TCRealValue(42));
    }];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.bottom.equalTo(self.bankCardBgView).offset(TCRealValue(-15));
    }];
}

- (void)handleClickEditButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickEditButtonInApartmentWithholdInfoView:)]) {
        [self.delegate didClickEditButtonInApartmentWithholdInfoView:self];
    }
}

#pragma mark - Override Methods

- (void)setWithholdInfo:(TCRentProtocolWithholdInfo *)withholdInfo {
    _withholdInfo = withholdInfo;
    
    NSString *logo = nil, *bgImage = nil;
    for (NSDictionary *bankInfo in self.bankInfoList) {
        if ([bankInfo[@"code"] isEqualToString:withholdInfo.bankCode]) {
            logo = bankInfo[@"logo"];
            bgImage = bankInfo[@"bgImage"];
            break;
        }
    }
    
    self.bankCardBgView.image = [UIImage imageNamed:bgImage];
    self.bankCardLogoView.image = [UIImage imageNamed:logo];
    self.nameLabel.text = withholdInfo.bankName;
    NSInteger index = withholdInfo.bankCardNum.length;
    if (index > 4) {
        index = index - 4;
    }
    NSString *lastNum = [withholdInfo.bankCardNum substringFromIndex:index];
    self.numLabel.text = [NSString stringWithFormat:@"**** **** **** %@", lastNum];
}

- (NSArray *)bankInfoList {
    if (_bankInfoList == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TCBankInfoList" ofType:@"plist"];
        _bankInfoList = [NSArray arrayWithContentsOfFile:path];
    }
    return _bankInfoList;
}

@end
