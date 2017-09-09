//
//  TCGoodsDetailInfoViewCell.m
//  individual
//
//  Created by 穆康 on 2017/9/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsDetailInfoViewCell.h"

#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <UIImageView+WebCache.h>

@interface TCGoodsDetailInfoViewCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UIView *containerView;

@property (copy, nonatomic) NSArray *lastArray;

@end

@implementation TCGoodsDetailInfoViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"商品详情";
    titleLabel.textColor = TCGrayColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLabel];
    
    UIView *containerView = [[UIView alloc] init];
    [self.contentView addSubview:containerView];
    
    self.titleLabel = titleLabel;
    self.containerView = containerView;
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView.mas_top).offset(20);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(40);
    }];
}

- (void)setDetailPictures:(NSArray *)detailPictures {
    _detailPictures = detailPictures;
    
    BOOL isEquel = YES;
    if (detailPictures.count == self.lastArray.count) {
        for (int i=0; i<detailPictures.count; i++) {
            if (![detailPictures[i] isEqualToString:self.lastArray[i]]) {
                isEquel = NO;
                break;
            }
        }
    } else {
        isEquel = NO;
    }
    
    // 如果和之前一样就不再重复设置
    if (isEquel == YES) {
        return;
    }
    
    self.lastArray = detailPictures;
    
    for (UIImageView *imageView in self.containerView.subviews) {
        [imageView removeFromSuperview];
    }
    
    UIView *lastView = nil;
    for (int i=0; i<detailPictures.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:imageView];
        
        NSString *urlStr = detailPictures[i];
        NSArray *array = [urlStr componentsSeparatedByString:@"="];
        if (array.count <= 1) {
            return;
        }
        
        CGFloat scale = [array.lastObject floatValue];
        CGFloat width = TCScreenWidth - 20;
        CGFloat height = width * scale;
        
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:urlStr];
        UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(width, height)];
        [imageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.left.right.equalTo(self.containerView);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom);
            } else {
                make.top.equalTo(self.containerView);
            }
        }];
        lastView = imageView;
    }
    
    [lastView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.containerView);
    }];
}

@end
