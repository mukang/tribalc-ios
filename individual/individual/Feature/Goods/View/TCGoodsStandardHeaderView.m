//
//  TCGoodsStandardHeaderView.m
//  individual
//
//  Created by 穆康 on 2017/9/5.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandardHeaderView.h"

#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <UIImageView+WebCache.h>

@interface TCGoodsStandardHeaderView ()

@property (weak, nonatomic) UIImageView *mainPictureView;
@property (weak, nonatomic) UILabel *priceLabel;
@property (weak, nonatomic) UILabel *repertoryLabel;
@property (weak, nonatomic) UILabel *selectLabel;
@property (weak, nonatomic) UILabel *standardLable;
@property (weak, nonatomic) UIView *lineView;

@end

@implementation TCGoodsStandardHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *mainPictureView = [[UIImageView alloc] init];
    mainPictureView.layer.borderWidth = 1;
    mainPictureView.layer.borderColor = TCBackgroundColor.CGColor;
    mainPictureView.layer.cornerRadius = 2.5;
    mainPictureView.layer.masksToBounds = YES;
    mainPictureView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:mainPictureView];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = TCRGBColor(81, 199, 209);
    priceLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:priceLabel];
    
    UILabel *repertoryLabel = [[UILabel alloc] init];
    repertoryLabel.textColor = TCGrayColor;
    repertoryLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:repertoryLabel];
    
    UILabel *selectLabel = [[UILabel alloc] init];
    selectLabel.text = @"已选择";
    selectLabel.textColor = TCBlackColor;
    selectLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:selectLabel];
    
    UILabel *standardLable = [[UILabel alloc] init];
    standardLable.textColor = TCRGBColor(81, 199, 209);
    standardLable.font = [UIFont systemFontOfSize:14];
    [self addSubview:standardLable];
    
    TCExtendButton *closeButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"goods_standard_close"] forState:UIControlStateNormal];
    closeButton.hitTestSlop = UIEdgeInsetsMake(-10, -10, -10, -10);
    [self addSubview:closeButton];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCBackgroundColor;
    [self addSubview:lineView];
    
    self.mainPictureView = mainPictureView;
    self.priceLabel = priceLabel;
    self.repertoryLabel = repertoryLabel;
    self.selectLabel = selectLabel;
    self.standardLable = standardLable;
    self.closeButton = closeButton;
    self.lineView = lineView;
}

- (void)setupConstraints {
    [self.mainPictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(118, 118));
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(-16);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainPictureView.mas_right).offset(13);
        make.top.equalTo(self).offset(16);
    }];
    [self.repertoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.top.equalTo(self.priceLabel.mas_bottom).offset(12);
    }];
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.top.equalTo(self.repertoryLabel.mas_bottom).offset(12);
    }];
    [self.standardLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectLabel.mas_right).offset(10);
        make.centerY.equalTo(self.selectLabel);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27.5, 27.5));
        make.top.equalTo(self).offset(12);
        make.right.equalTo(self).offset(-20);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.bottom.right.equalTo(self);
    }];
}

- (void)setGoodsDetail:(TCGoodsDetail *)goodsDetail {
    _goodsDetail = goodsDetail;
    
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:goodsDetail.mainPicture];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(118, 118)];
    [self.mainPictureView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [NSNumber numberWithDouble:goodsDetail.salePrice]];
    
    self.repertoryLabel.text = [NSString stringWithFormat:@"（剩余：%zd）", goodsDetail.repertory];
}

- (void)setStandardStr:(NSString *)standardStr {
    _standardStr = standardStr;
    
    self.standardLable.text = standardStr;
}

@end
