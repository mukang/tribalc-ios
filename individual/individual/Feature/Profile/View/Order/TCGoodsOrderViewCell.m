//
//  TCGoodsOrderViewCell.m
//  store
//
//  Created by 穆康 on 2017/2/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderViewCell.h"
#import "TCOrderItem.h"
#import "TCGoods.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <UIImageView+WebCache.h>

@interface TCGoodsOrderViewCell ()

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *brandLabel;
@property (weak, nonatomic) UILabel *priceLabel;
@property (weak, nonatomic) UILabel *countLabel;
@property (weak, nonatomic) UILabel *standardLabel;

@end

@implementation TCGoodsOrderViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = TCBackgroundColor;
    [self.contentView addSubview:containerView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [containerView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCBlackColor;
    nameLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:nameLabel];
    
    UILabel *brandLabel = [[UILabel alloc] init];
    brandLabel.textColor = TCBlackColor;
    brandLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:brandLabel];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = TCBlackColor;
    priceLabel.textAlignment = NSTextAlignmentRight;
    priceLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:priceLabel];
    
    UILabel *countLabel = [[UILabel alloc] init];
    countLabel.textColor = TCBlackColor;
    countLabel.textAlignment = NSTextAlignmentRight;
    countLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:countLabel];
    
    UILabel *standardLabel = [[UILabel alloc] init];
    standardLabel.textColor = TCGrayColor;
    standardLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:standardLabel];
    
    self.containerView = containerView;
    self.imageView = imageView;
    self.nameLabel = nameLabel;
    self.brandLabel = brandLabel;
    self.priceLabel = priceLabel;
    self.countLabel = countLabel;
    self.standardLabel = standardLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView).offset(-2);
        make.left.equalTo(weakSelf.contentView.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-20);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(71.5, 71.5));
        make.left.equalTo(weakSelf.containerView.mas_left).with.offset(3);
        make.centerY.equalTo(weakSelf.containerView.mas_centerY);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.containerView).offset(12);
        make.left.equalTo(weakSelf.nameLabel.mas_right).offset(10);
        make.right.equalTo(weakSelf.containerView).offset(-11);
        make.width.mas_greaterThanOrEqualTo(55);
        make.height.mas_equalTo(14);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.priceLabel.mas_bottom).offset(4);
        make.right.height.equalTo(weakSelf.priceLabel);
        make.left.equalTo(weakSelf.brandLabel.mas_right).offset(10);
        make.width.mas_greaterThanOrEqualTo(55);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(weakSelf.priceLabel);
        make.left.equalTo(weakSelf.imageView.mas_right).with.offset(9);
    }];
    [self.brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(weakSelf.countLabel);
        make.left.equalTo(weakSelf.nameLabel);
    }];
    [self.standardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(weakSelf.nameLabel);
        make.right.equalTo(weakSelf.priceLabel);
        make.bottom.equalTo(weakSelf.containerView).with.offset(-10);
    }];
}

- (void)setOrderItem:(TCOrderItem *)orderItem {
    _orderItem = orderItem;
    
    TCGoods *goods = orderItem.goods;
    
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:goods.mainPicture];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(71.5, 71.5)];
    [self.imageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    
    self.nameLabel.text = goods.name;
    
    self.brandLabel.text = goods.brand;
    
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %0.2f", goods.salePrice];
    
    self.countLabel.text = [NSString stringWithFormat:@"× %zd", orderItem.amount];
    
    self.standardLabel.text = goods.standardSnapshot;
}

@end
