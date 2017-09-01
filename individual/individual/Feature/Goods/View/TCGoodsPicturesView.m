//
//  TCGoodsPicturesView.m
//  individual
//
//  Created by 穆康 on 2017/9/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsPicturesView.h"
#import <TCCommonLibs/TCPicturesHeaderView.h>

@interface TCGoodsPicturesView () <TCPicturesHeaderViewDelegate>

@property (copy, nonatomic) TCPicturesHeaderView *headerView;
@property (copy, nonatomic) UIPageControl *pageControl;

@end

@implementation TCGoodsPicturesView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    TCPicturesHeaderView *headerView = [[TCPicturesHeaderView alloc] init];
    headerView.delegate = self;
    [self addSubview:headerView];
    self.headerView = headerView;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.hidesForSinglePage = YES;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
}

- (void)setupConstraints {
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_bottom).offset(-20);
    }];
}

- (void)setPictures:(NSArray *)pictures {
    _pictures = pictures;
    
    self.headerView.pictures = pictures;
    self.pageControl.numberOfPages = pictures.count;
    self.pageControl.currentPage = 0;
}

- (void)picturesHeaderView:(TCPicturesHeaderView *)view didScrollToIndex:(NSInteger)index {
    self.pageControl.currentPage = index;
}

@end
