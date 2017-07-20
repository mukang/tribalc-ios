//
//  TCStoreHeaderView.m
//  individual
//
//  Created by 穆康 on 2017/7/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreHeaderView.h"

@interface TCStoreHeaderView () <TCPicturesHeaderViewDelegate>

@property (weak, nonatomic) TCPicturesHeaderView *picturesView;
@property (weak, nonatomic) UIView *indexView;
@property (weak, nonatomic) UILabel *indexLabel;

@end

@implementation TCStoreHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    TCPicturesHeaderView *picturesView = [[TCPicturesHeaderView alloc] init];
    picturesView.delegate = self;
    [self addSubview:picturesView];
    self.picturesView = picturesView;
    
    UIView *indexView = [[UIView alloc] init];
    indexView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    indexView.layer.cornerRadius = 7;
    indexView.layer.masksToBounds = YES;
    indexView.hidden = YES;
    [self addSubview:indexView];
    self.indexView = indexView;
    
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.font = [UIFont systemFontOfSize:11];
    [indexView addSubview:indexLabel];
    self.indexLabel = indexLabel;
}

- (void)setupConstraints {
    [self.picturesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.indexView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(39, 14));
        make.right.bottom.equalTo(self).offset(-8);
    }];
    [self.indexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.indexView);
    }];
}

#pragma mark - Override Methods

- (void)setPictures:(NSArray *)pictures {
    _pictures = pictures;
    
    self.picturesView.pictures = pictures;
    
    if (self.pictures.count > 1) {
        self.indexView.hidden = NO;
        self.indexLabel.text = [NSString stringWithFormat:@"1/%zd", pictures.count];
    } else {
        self.indexView.hidden = YES;
    }
}

#pragma mark - TCPicturesHeaderViewDelegate

- (void)picturesHeaderView:(TCPicturesHeaderView *)view didScrollToIndex:(NSInteger)index {
    if (self.pictures.count > 1) {
        self.indexLabel.text = [NSString stringWithFormat:@"%zd/%zd", index+1, self.pictures.count];
    }
}

@end
