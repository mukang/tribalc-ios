//
//  TCCommunityViewCell.m
//  individual
//
//  Created by 穆康 on 2016/11/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunityViewCell.h"
#import "TCCommunity.h"
#import "TCExtendButton.h"
#import "TCImageURLSynthesizer.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry.h>

@interface TCCommunityViewCell ()

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *addressLabel;
@property (weak, nonatomic) TCExtendButton *phoneButton;

@end

@implementation TCCommunityViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundView.backgroundColor = TCRGBColor(242, 242, 242);
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = 2.5;
    containerView.clipsToBounds = YES;
    [self.contentView addSubview:containerView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [containerView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = TCRGBColor(42, 42, 42);
    nameLabel.font = [UIFont boldSystemFontOfSize:16];
    [containerView addSubview:nameLabel];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.textColor = TCRGBColor(154, 154, 154);
    addressLabel.font = [UIFont systemFontOfSize:14];
    [containerView addSubview:addressLabel];
    
    TCExtendButton *phoneButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [phoneButton setImage:[UIImage imageNamed:@"community_phone_icon"] forState:UIControlStateNormal];
    [phoneButton addTarget:self action:@selector(handleClickPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
    phoneButton.hitTestSlop = UIEdgeInsetsMake(-7, -20, -7, -20);
    [containerView addSubview:phoneButton];
    
    self.containerView = containerView;
    self.imageView = imageView;
    self.nameLabel = nameLabel;
    self.addressLabel = addressLabel;
    self.phoneButton = phoneButton;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.contentView);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.containerView);
        make.height.mas_equalTo(207);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageView.mas_bottom).with.offset(11);
        make.left.equalTo(weakSelf.containerView.mas_left).with.offset(12.5);
        make.right.equalTo(weakSelf.containerView.mas_right).with.offset(-12.5);
        make.height.mas_equalTo(18);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom).with.offset(7);
        make.left.right.equalTo(weakSelf.nameLabel);
        make.height.mas_equalTo(16);
    }];
    
    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.addressLabel.mas_bottom).with.offset(7);
        make.left.equalTo(weakSelf.addressLabel.mas_left);
    }];
}

- (void)setCommunity:(TCCommunity *)community {
    _community = community;
    
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:community.mainPicture];
    [self.imageView sd_setImageWithURL:URL placeholderImage:nil options:SDWebImageRetryFailed];
    
    self.nameLabel.text = community.name;
    
    self.addressLabel.text = community.address;
    
    NSString *phone = community.phone ?: @"";
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:phone
                                                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                              NSForegroundColorAttributeName: TCRGBColor(81, 199, 209)
//                                                                              NSUnderlineColorAttributeName: TCRGBColor(81, 199, 209),
//                                                                              NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                                                              }];
    [self.phoneButton setAttributedTitle:attStr forState:UIControlStateNormal];
}

- (void)handleClickPhoneButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(communityViewCell:didClickPhoneButtonWithCommunity:)]) {
        [self.delegate communityViewCell:self didClickPhoneButtonWithCommunity:self.community];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.containerView.backgroundColor = TCRGBColor(217, 217, 217);
    } else {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.containerView.backgroundColor = [UIColor whiteColor];
        } completion:nil];
    }
}

@end
