//
//  TCProfileFeatureView.m
//  individual
//
//  Created by 穆康 on 2017/8/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCProfileFeatureView.h"

@interface TCProfileFeatureView ()

@property (strong, nonatomic) UILabel *unReadNumLabel;

@end

@implementation TCProfileFeatureView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:TCBlackColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:button];
    self.button = button;
    UILabel *unreadNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:unreadNumLabel];
    unreadNumLabel.backgroundColor = [UIColor redColor];
    unreadNumLabel.textColor = [UIColor whiteColor];
    unreadNumLabel.font = [UIFont systemFontOfSize:10];
    unreadNumLabel.layer.cornerRadius = 8.0;
    unreadNumLabel.clipsToBounds = YES;
    unreadNumLabel.textAlignment = NSTextAlignmentCenter;
    unreadNumLabel.hidden = YES;
    [unreadNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(5);
        make.height.equalTo(@16);
        make.width.mas_greaterThanOrEqualTo(@16);
    }];
    
    self.unReadNumLabel = unreadNumLabel;
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setUnReadNum:(NSNumber *)unReadNum {
    if ([unReadNum isKindOfClass:[NSNumber class]]) {
        _unReadNum = unReadNum;
        
        NSInteger num = [unReadNum integerValue];
        if (num) {
            self.unReadNumLabel.hidden = NO;
            self.unReadNumLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
        }else {
            self.unReadNumLabel.hidden = YES;
        }
    }
}

@end
