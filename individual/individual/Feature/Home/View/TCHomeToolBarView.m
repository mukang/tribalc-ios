//
//  TCHomeToolBarView.m
//  individual
//
//  Created by 穆康 on 2017/7/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeToolBarView.h"

#define defaultTag 1000

@implementation TCHomeToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = TCRGBColor(151, 171, 234);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIButton *scanButton = [self createButtonWithImageName:@"home_scan_button_small"];
    scanButton.tag = defaultTag + 1;
    [self addSubview:scanButton];
    
    UIButton *unlockButton = [self createButtonWithImageName:@"home_unlocking_button_small"];
    unlockButton.tag = defaultTag + 2;
    [self addSubview:unlockButton];
    
    UIButton *maintainButton = [self createButtonWithImageName:@"home_maintain_button_small"];
    maintainButton.tag = defaultTag + 3;
    [self addSubview:maintainButton];
    
    UIButton *searchButton = [self createButtonWithImageName:@"home_search_button_small"];
    searchButton.tag = defaultTag + 4;
    [self addSubview:searchButton];
    
    CGSize buttonSize = CGSizeMake(24.5, 24.5);
    [scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self.mas_top).offset(42);
    }];
    [unlockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.left.equalTo(scanButton.mas_right).offset(TCRealValue(30));
        make.centerY.equalTo(scanButton);
    }];
    [maintainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.left.equalTo(unlockButton.mas_right).offset(TCRealValue(30));
        make.centerY.equalTo(scanButton);
    }];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(buttonSize);
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(scanButton);
    }];
}

- (UIButton *)createButtonWithImageName:(NSString *)imageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleClickButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)handleClickButton:(UIButton *)sender {
    NSInteger tag = sender.tag - defaultTag;
    switch (tag) {
        case 1:
            if ([self.delegate respondsToSelector:@selector(didClickScanButtonInHomeToolBarView:)]) {
                [self.delegate didClickScanButtonInHomeToolBarView:self];
            }
            break;
        case 2:
            if ([self.delegate respondsToSelector:@selector(didClickUnlockButtonInHomeToolBarView:)]) {
                [self.delegate didClickUnlockButtonInHomeToolBarView:self];
            }
            break;
        case 3:
            if ([self.delegate respondsToSelector:@selector(didClickMaintainButtonInHomeToolBarView:)]) {
                [self.delegate didClickMaintainButtonInHomeToolBarView:self];
            }
            break;
        case 4:
            if ([self.delegate respondsToSelector:@selector(didClickSearchButtonInHomeToolBarView:)]) {
                [self.delegate didClickSearchButtonInHomeToolBarView:self];
            }
            break;
            
        default:
            break;
    }
}

@end
