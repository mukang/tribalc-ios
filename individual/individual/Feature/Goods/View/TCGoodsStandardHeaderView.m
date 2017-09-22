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
@property (weak, nonatomic) UILabel *limitLabel;
@property (weak, nonatomic) UILabel *residueLabel;
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
    priceLabel.textColor = TCRGBColor(113, 130, 220);
    priceLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:priceLabel];
    
    UILabel *repertoryLabel = [[UILabel alloc] init];
    repertoryLabel.textColor = TCGrayColor;
    repertoryLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:repertoryLabel];
    
    UILabel *limitLabel = [[UILabel alloc] init];
    limitLabel.textColor = TCRGBColor(244, 55, 49);
    limitLabel.font = [UIFont systemFontOfSize:12];
    limitLabel.hidden = YES;
    [self addSubview:limitLabel];
    
    UILabel *residueLabel = [[UILabel alloc] init];
    residueLabel.textColor = TCGrayColor;
    residueLabel.font = [UIFont systemFontOfSize:12];
    residueLabel.hidden = YES;
    [self addSubview:residueLabel];
    
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
    self.limitLabel = limitLabel;
    self.residueLabel = residueLabel;
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
    [self.limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.top.equalTo(self.repertoryLabel.mas_bottom).offset(8);
    }];
    [self.residueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.limitLabel.mas_right);
        make.centerY.equalTo(self.limitLabel);
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
    
    self.repertoryLabel.text = [NSString stringWithFormat:@"库存：%zd", goodsDetail.repertory];
    
    self.limitLabel.text = [NSString stringWithFormat:@"每日限量%zd", goodsDetail.dailyLimit];
    
    NSInteger residue = goodsDetail.dailyLimit - goodsDetail.dailySaled;
    if (residue < 0) residue = 0;
    if (residue < goodsDetail.repertory) residue = goodsDetail.repertory;
    self.residueLabel.text = [NSString stringWithFormat:@"（剩余%zd）", residue];
    
    CGFloat repertoryLabelTop = 0, selectLabelTop = 0;
    if (goodsDetail.dailyLimit) {
        repertoryLabelTop = 10;
        selectLabelTop = 30;
        self.limitLabel.hidden = NO;
        self.residueLabel.hidden = NO;
    } else {
        repertoryLabelTop = 12;
        selectLabelTop = 12;
        self.limitLabel.hidden = YES;
        self.residueLabel.hidden = YES;
    }
    
    [self.repertoryLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(repertoryLabelTop);
    }];
    [self.selectLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.repertoryLabel.mas_bottom).offset(selectLabelTop);
    }];
    
    [self layoutIfNeeded];
}

- (void)setStandardStr:(NSString *)standardStr {
    _standardStr = standardStr;
    
    self.standardLable.text = standardStr;
}

@end
