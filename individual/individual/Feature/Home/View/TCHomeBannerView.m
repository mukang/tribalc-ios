//
//  TCHomeBannerView.m
//  individual
//
//  Created by 穆康 on 2017/7/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeBannerView.h"
#import <TCCommonLibs/TCImagePlayerView.h>

@interface TCHomeBannerView () <TCImagePlayerViewDelegate>

@property (weak, nonatomic) TCImagePlayerView *playerView;

@end

@implementation TCHomeBannerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = TCRGBColor(242, 242, 242);
        [self setupSubviewsWithFrame:frame];
    }
    return self;
}

- (void)setupSubviewsWithFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake(0, 7.5, frame.size.width, frame.size.height - 7.5);
    TCImagePlayerView *playerView = [[TCImagePlayerView alloc] initWithFrame:newFrame];
    [playerView setPictures:@[@"home_banner"] isLocal:YES];
    playerView.delegate = self;
    [playerView hidePageControl];
    [self addSubview:playerView];
    self.playerView = playerView;
}

- (void)imagePlayerStartPlaying {
    [self.playerView startPlaying];
}

- (void)imagePlayerStopPlaying {
    [self.playerView stopPlaying];
}

- (void)didScrollToIndex:(NSInteger)index {
    
}

- (void)imagePlayerView:(TCImagePlayerView *)view didSelectedImageWithIndex:(NSInteger)index {
    
}

@end
