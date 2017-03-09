//
//  TCLockQRCodeView.m
//  individual
//
//  Created by 穆康 on 2017/3/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLockQRCodeView.h"

@implementation TCLockQRCodeView {
    __weak TCLockQRCodeView *weakSelf;
}

- (instancetype)initWithLockQRCodeType:(TCLockQRCodeType)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        weakSelf = self;
        _type = type;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 7.5;
        self.layer.masksToBounds = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *codeImageView = [[UIImageView alloc] init];
    codeImageView.backgroundColor = [UIColor orangeColor];
    [self addSubview:codeImageView];
    
    if (self.type == TCLockQRCodeTypeOneself) {
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = TCRGBColor(42, 42, 42);
        nameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:nameLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = TCRGBColor(221, 221, 221);
        [self addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(weakSelf);
            make.top.equalTo(weakSelf).offset(TCRealValue(50));
            make.height.mas_equalTo(0.5);
        }];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf).offset(10);
            make.trailing.equalTo(weakSelf).offset(-10);
            make.top.equalTo(weakSelf);
            make.bottom.equalTo(lineView.mas_top);
        }];
        [codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(TCRealValue(180), TCRealValue(180)));
            make.top.equalTo(lineView.mas_bottom).offset(TCRealValue(36));
            make.centerX.equalTo(weakSelf);
        }];
    } else {
        
    }
}

@end
