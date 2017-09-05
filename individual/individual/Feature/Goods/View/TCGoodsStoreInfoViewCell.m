//
//  TCGoodsStoreInfoViewCell.m
//  individual
//
//  Created by 穆康 on 2017/9/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStoreInfoViewCell.h"
#import "TCGoodsDetail.h"

#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <UIImageView+WebCache.h>

#define starCount 5

@interface TCGoodsStoreInfoViewCell ()

@property (strong, nonatomic) NSMutableArray *starIcons;

@property (weak, nonatomic) UIImageView *logoView;
@property (weak, nonatomic) UILabel *brandLabel;
@property (weak, nonatomic) UILabel *salesLabel;
@property (weak, nonatomic) UILabel *phoneLabel;

@end

@implementation TCGoodsStoreInfoViewCell

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
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.layer.borderColor = TCSeparatorLineColor.CGColor;
    logoView.layer.borderWidth = 0.5;
    logoView.clipsToBounds = YES;
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:logoView];
    
    UILabel *brandLabel = [[UILabel alloc] init];
    brandLabel.textColor = TCBlackColor;
    brandLabel.font = [UIFont boldSystemFontOfSize:14];
    [self.contentView addSubview:brandLabel];
    
    for (int i=0; i<starCount; i++) {
        UIImageView *starIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_store_star"]];
        [self.contentView addSubview:starIcon];
        [self.starIcons addObject:starIcon];
    }
    
    UILabel *salesLabel = [[UILabel alloc] init];
    salesLabel.textColor = TCGrayColor;
    salesLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:salesLabel];
    
    UILabel *phoneLabel = [[UILabel alloc] init];
    phoneLabel.textColor = TCGrayColor;
    phoneLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:phoneLabel];
    
    self.logoView = logoView;
    self.brandLabel = brandLabel;
    self.salesLabel = salesLabel;
    self.phoneLabel = phoneLabel;
}

- (void)setupConstraints {
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(48.5, 48.5));
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    [self.brandLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logoView.mas_right).offset(15);
        make.top.equalTo(self.logoView).offset(-1);
    }];
    [self.salesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brandLabel);
        make.bottom.equalTo(self.logoView);
    }];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.salesLabel.mas_right).offset(25);
        make.centerY.equalTo(self.salesLabel);
    }];
    
    UIImageView *lastStarIcon = nil;
    for (int i=0; i<self.starIcons.count; i++) {
        UIImageView *starIcon = self.starIcons[i];
        [starIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(9.5, 9.5));
            make.centerY.equalTo(self.logoView);
            if (lastStarIcon) {
                make.left.equalTo(lastStarIcon.mas_right).offset(5);
            } else {
                make.left.equalTo(self.brandLabel);
            }
        }];
        lastStarIcon = starIcon;
    }
}

- (void)setGoodsDetail:(TCGoodsDetail *)goodsDetail {
    _goodsDetail = goodsDetail;
    
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:goodsDetail.tMarkStore.logo];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(48.5, 48.5)];
    [self.logoView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    
    self.brandLabel.text = goodsDetail.tMarkStore.name;
    
    self.salesLabel.text = [NSString stringWithFormat:@"总销量：%zd", goodsDetail.saleQuantity];
    
    self.phoneLabel.text = [NSString stringWithFormat:@"电话：%@", goodsDetail.tMarkStore.phone];
}

- (NSMutableArray *)starIcons {
    if (_starIcons == nil) {
        _starIcons = [NSMutableArray arrayWithCapacity:starCount];
    }
    return _starIcons;
}

@end
