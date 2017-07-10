//
//  TCContractViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/6/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCContractViewController.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <UIImageView+WebCache.h>
#import <UIImage+Category.h>

@interface TCContractViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (copy, nonatomic) NSString *picturesStr;

@property (copy, nonatomic) NSArray *pictures;


@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval lastTimerTick;
@property (nonatomic, assign) CGFloat animationPointsPerSecond;
@property (nonatomic, assign) CGPoint finalContentOffset;
@property (nonatomic, assign) BOOL scrollToLeft;

@end

@implementation TCContractViewController

- (instancetype)initWithPictures:(NSString *)picturesStr {
    if (self = [super init]) {
        if ([picturesStr isKindOfClass:[NSString class]]) {
            self.picturesStr = picturesStr;
            [self setUpViews];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的合同";
    self.view.backgroundColor = TCRGBColor(113, 114, 115);
}

- (void)setUpViews {
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(@(TCRealValue(559)));
    }];
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(TCRealValue(50)));
        make.top.equalTo(self.scrollView.mas_bottom).offset(TCRealValue(10));
        make.height.equalTo(@10);
    }];
}

- (void)setPicturesStr:(NSString *)picturesStr {
    if (_picturesStr != picturesStr) {
        _picturesStr = picturesStr;
        self.pictures = [picturesStr componentsSeparatedByString:@","];
    }
}

#pragma maek UIScrollViewDelegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    
    if (contentOffsetX < 0 || contentOffsetX > scrollView.contentSize.width - scrollView.frame.size.width) {
        return;
    }
    
    NSInteger MAX_INDEX = (scrollView.contentSize.width + TCRealValue(20))/(self.view.frame.size.width + TCRealValue(20));
    NSInteger MIN_INDEX = 0;
    
    NSInteger index = contentOffsetX/(self.view.frame.size.width + TCRealValue(20));
    
    if (velocity.x > 0.4 && contentOffsetX < (*targetContentOffset).x) {
        index = index + 1;
    }
    else if (velocity.x < -0.4 && contentOffsetX > (*targetContentOffset).x) {
        index = index;
    }
    else if (contentOffsetX > (index + 0.5) * (self.view.frame.size.width + TCRealValue(20))) {
        index = index + 1;
    }
    
    if (index > MAX_INDEX) index = MAX_INDEX;
    if (index < MIN_INDEX) index = MIN_INDEX;
    
    CGPoint newTargetContentOffset= CGPointMake(index * (self.view.frame.size.width + TCRealValue(20)), 0);
    *targetContentOffset = CGPointMake(scrollView.contentOffset.x, 0);
    [self scrollToPoint:newTargetContentOffset];
    
}

-(void)scrollToPoint:(CGPoint) point {
    [self endAnimation];
    self.lastTimerTick = 0;
    self.animationPointsPerSecond = [UIScreen mainScreen].bounds.size.width * 4;
    self.finalContentOffset = point;
    self.scrollToLeft = point.x > self.scrollView.contentOffset.x;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkTick)];
    [self.displayLink setFrameInterval:1];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)endAnimation {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

-(void)displayLinkTick {
    if (self.lastTimerTick == 0) {
        self.lastTimerTick = self.displayLink.timestamp;
        return;
    }
    CFTimeInterval currentTimestamp = self.displayLink.timestamp;
    CGPoint newContentOffset = self.scrollView.contentOffset;
    if (_scrollToLeft) {
        newContentOffset.x += self.animationPointsPerSecond * (currentTimestamp - self.lastTimerTick);
        newContentOffset.x = newContentOffset.x > self.finalContentOffset.x ? self.finalContentOffset.x : newContentOffset.x;
    } else {
        newContentOffset.x -= self.animationPointsPerSecond * (currentTimestamp - self.lastTimerTick);
        newContentOffset.x = newContentOffset.x < self.finalContentOffset.x ? self.finalContentOffset.x : newContentOffset.x;
    }
    self.scrollView.contentOffset = newContentOffset;
    self.lastTimerTick = currentTimestamp;
    
    if (newContentOffset.x == self.finalContentOffset.x) {
        [self endAnimation];
    }
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
//        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO; 
        
        UIView *contentView = [[UIView alloc] init];
        [_scrollView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_scrollView);
            make.height.equalTo(@(TCRealValue(559)));
        }];
        
        UIView *currentView = self.view;
        for (int i = 0; i < self.pictures.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.clipsToBounds = YES;
            [contentView addSubview:imageView];
            NSString *str = self.pictures[i];
            NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:str];
            UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(self.view.size.width, TCRealValue(559))];
            [imageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
            
            if (i == 0) {
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.bottom.equalTo(contentView);
                    make.width.equalTo(@(TCScreenWidth));
                }];
            }else if (i == (self.pictures.count - 1)) {
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(currentView.mas_right).offset(TCRealValue(20));
                    make.top.bottom.equalTo(contentView);
                    make.width.equalTo(currentView);
                    make.right.equalTo(contentView);
                }];
            }else {
                [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(currentView.mas_right).offset(TCRealValue(20));
                    make.top.bottom.equalTo(contentView);
                    make.width.equalTo(currentView);
                }];
            }
            
            currentView = imageView;
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.numberOfPages = self.pictures.count;
    }
    return _pageControl;
}

@end
