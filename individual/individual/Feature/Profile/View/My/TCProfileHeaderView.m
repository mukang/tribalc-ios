//
//  TCProfileHeaderView.m
//  individual
//
//  Created by 穆康 on 2017/8/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCProfileHeaderView.h"
#import "TCBuluoApi.h"

#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface TCProfileHeaderView ()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIImageView *avatarView;
@property (weak, nonatomic) UILabel *nameLabel;

@end

@implementation TCProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"profile_header_bg"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    
    UIImageView *avatarView = [[UIImageView alloc] init];
    avatarView.contentMode = UIViewContentModeScaleAspectFill;
    avatarView.userInteractionEnabled = YES;
    avatarView.layer.borderWidth = 0.5;
    avatarView.layer.borderColor = TCSeparatorLineColor.CGColor;
    avatarView.layer.cornerRadius = TCRealValue(36);
    avatarView.layer.masksToBounds = YES;
    [self addSubview:avatarView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAvatarView)];
    [avatarView addGestureRecognizer:tap];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:nameLabel];
    
    self.imageView = imageView;
    self.avatarView = avatarView;
    self.nameLabel = nameLabel;
}

- (void)setupConstraints {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(72), TCRealValue(72)));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(TCRealValue(-79));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(TCRealValue(-50));
    }];
}

- (void)reloadData {
    TCUserInfo *userInfo = [[TCBuluoApi  api] currentUserSession].userInfo;
    if (userInfo) {
        NSURL *URL = [TCImageURLSynthesizer synthesizeAvatarImageURLWithUserID:userInfo.ID needTimestamp:NO];
        UIImage *placeholderImage = self.avatarView.image ?: [UIImage imageNamed:@"profile_default_avatar_icon"];
        [self.avatarView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
        self.nameLabel.text = userInfo.nickname;
    } else {
        self.avatarView.image = [UIImage imageNamed:@"profile_default_avatar_icon"];
        self.nameLabel.text = @"未登录";
    }
}

- (void)handleTapAvatarView {
    if ([self.delegate respondsToSelector:@selector(didClickAvatarViewInProfileHeaderView:)]) {
        [self.delegate didClickAvatarViewInProfileHeaderView:self];
    }
}

@end
