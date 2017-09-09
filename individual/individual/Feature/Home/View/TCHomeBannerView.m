//
//  TCHomeBannerView.m
//  individual
//
//  Created by 穆康 on 2017/7/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeBannerView.h"
#import <TCCommonLibs/TCImagePlayerView.h>

@interface TCHomeBannerView ()<TCImagePlayerViewDelegate>


@property (weak, nonatomic) TCImagePlayerView *playerView;

@property (weak, nonatomic) UIImageView *bgImageView;

@property (weak, nonatomic) UIImageView *weatherImageView;

@property (weak, nonatomic) UILabel *temperatureLabel;

@property (weak, nonatomic) UILabel *weatherLabel;

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

- (void)setWeatherDic:(NSDictionary *)weatherDic {
    _weatherDic = weatherDic;
    
    NSDictionary *nowDic = weatherDic[@"now"];
    if ([nowDic isKindOfClass:[NSDictionary class]]) {
        self.weatherLabel.text = nowDic[@"text"];
        self.temperatureLabel.text = [NSString stringWithFormat:@"%@°",nowDic[@"temperature"]];
        self.weatherImageView.image = [UIImage imageNamed:nowDic[@"code"]];
    }
}

- (void)setupSubviewsWithFrame:(CGRect)frame {
    CGRect newFrame = CGRectMake(0, 7.5, frame.size.width, frame.size.height - 7.5);
    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:newFrame];
//    imageView.backgroundColor = TCRGBColor(113, 130, 220);
//    [self addSubview:imageView];
//    self.bgImageView = imageView;
//    
//    UIImageView *weatherImageView = [[UIImageView alloc] init];
//    [self.bgImageView addSubview:weatherImageView];
//    weatherImageView.image = [UIImage imageNamed:@"0"];
//    self.weatherImageView = weatherImageView;
//    
//    UILabel *tempLabel = [[UILabel alloc] init];
//    tempLabel.text = @"20°";
//    tempLabel.font = [UIFont systemFontOfSize:18];
//    tempLabel.textColor = [UIColor whiteColor];
//    [self.bgImageView addSubview:tempLabel];
//    self.temperatureLabel = tempLabel;
//    
//    UILabel *weaLabel = [[UILabel alloc] init];
//    weaLabel.textColor = [UIColor whiteColor];
//    weaLabel.font = [UIFont systemFontOfSize:16];
//    weaLabel.text = @"晴";
//    [self.bgImageView addSubview:weaLabel];
//    self.weatherLabel = weaLabel;
    
    
    
//    [weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.equalTo(@50);
//        make.centerY.equalTo(self).offset(7.5/2);
//        make.right.equalTo(self.mas_centerX);
//    }];
//    
//    [tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weatherImageView).offset(5);
//        make.left.equalTo(weatherImageView.mas_right).offset(5);
//    }];
//    
//    [weaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(tempLabel);
//        make.top.equalTo(tempLabel.mas_bottom);
//    }];
    
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
