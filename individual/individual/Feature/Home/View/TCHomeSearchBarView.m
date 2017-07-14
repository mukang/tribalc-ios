//
//  TCHomeSearchBarView.m
//  individual
//
//  Created by 穆康 on 2017/7/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeSearchBarView.h"

@implementation TCHomeSearchBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = TCRGBColor(123, 146, 216);
    [self addSubview:bgView];
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    searchIcon.image = [UIImage imageNamed:@"home_search_icon"];
    [bgView addSubview:searchIcon];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [bgView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.mas_top).offset(42);
    }];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 12.5));
        make.left.equalTo(bgView).offset(11);
        make.centerY.equalTo(bgView);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIcon.mas_right).offset(6);
        make.centerY.equalTo(bgView);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClickSearchBar)];
    [bgView addGestureRecognizer:tap];
}

- (void)handleClickSearchBar {
    if ([self.delegate respondsToSelector:@selector(didClickSearchBarInHomeSearchBarView:)]) {
        [self.delegate didClickSearchBarInHomeSearchBarView:self];
    }
}

@end
