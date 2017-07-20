//
//  TCStoreTagView.m
//  individual
//
//  Created by 穆康 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreTagView.h"

@implementation TCStoreTagView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self setupConstraints];
    }
    return self;
}

- (void)setup {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = TCSeparatorLineColor.CGColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCGrayColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}


- (CGSize)intrinsicContentSize {
    CGFloat minWidth = 45;
    CGFloat padding = 10;
    if (self.titleLabel.text.length && self.titleLabel.width > minWidth) {
        return CGSizeMake(self.titleLabel.width + padding * 2.0, 20.5);
    } else {
        return CGSizeMake(minWidth + padding * 2.0, 20.5);
    }
}

@end
