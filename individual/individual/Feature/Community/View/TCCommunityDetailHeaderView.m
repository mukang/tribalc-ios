//
//  TCCommunityDetailHeaderView.m
//  individual
//
//  Created by 穆康 on 2016/11/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunityDetailHeaderView.h"

#import "TCImageURLSynthesizer.h"

#import <SDWebImage/UIImageView+WebCache.h>

static NSInteger const plusNum = 2;  // 需要加上的数

@interface TCCommunityDetailHeaderView () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation TCCommunityDetailHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupImagePlayer];
}

- (void)setupImagePlayer {
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
}

- (void)setPictures:(NSArray *)pictures {
    _pictures = pictures;
    
    NSInteger imageCount = pictures.count;
    
    if (!imageCount) return;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * (imageCount + plusNum), 0);
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0) animated:NO];
    
    self.pageControl.numberOfPages = imageCount;
    
    for (int i=0; i<imageCount + plusNum; i++) {
        CGFloat imageW = self.scrollView.width;
        CGFloat imageH = self.scrollView.height;
        CGFloat imageX = imageW * i;
        NSInteger imageIndex;
        if (i == 0) {
            imageIndex = imageCount - 1;
        } else if (i == imageCount + 1) {
            imageIndex = 0;
        } else {
            imageIndex = i - 1;
        }
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        [imageView setTag:imageIndex];
        [imageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapImageView:)];
        [imageView addGestureRecognizer:tapGesture];
        [self.scrollView addSubview:imageView];
        
        NSString *URLString = pictures[imageIndex];
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:URLString];
        [imageView sd_setImageWithURL:URL placeholderImage:nil options:SDWebImageRetryFailed];
    }
    
    if (!self.timer) {
        [self addTimer];
    }
}

#pragma mark - Timer

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
}

- (void)removeTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - Actions

- (void)nextImage {
    
    NSInteger imageCount = self.pictures.count;
    NSInteger currentPage = self.scrollView.contentOffset.x / self.scrollView.width;
    
    if (currentPage == 0) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * imageCount, 0) animated:NO];
        currentPage = imageCount - 1;
    } else if (currentPage == imageCount + 1) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0) animated:NO];
        currentPage = 1;
    }
    
    currentPage ++;
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width * currentPage, 0) animated:YES];
}

- (void)handleTapImageView:(UITapGestureRecognizer *)sender {
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger imageCount = self.pictures.count;
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.width;
    
    if (currentPage == 0) {
        [scrollView setContentOffset:CGPointMake(scrollView.width * imageCount, 0) animated:NO];
        self.pageControl.currentPage = imageCount - 1;
    } else if (currentPage == imageCount + 1) {
        [scrollView setContentOffset:CGPointMake(scrollView.width, 0) animated:NO];
        self.pageControl.currentPage = 0;
    } else {
        self.pageControl.currentPage = currentPage - 1;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    NSInteger imageCount = self.pictures.count;
    NSInteger currentPage = self.scrollView.contentOffset.x / self.scrollView.width;
    
    if (currentPage == imageCount + 1) {
        currentPage = 1;
    }
    
    self.pageControl.currentPage = currentPage - 1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self removeTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (!self.timer) {
        [self addTimer];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
