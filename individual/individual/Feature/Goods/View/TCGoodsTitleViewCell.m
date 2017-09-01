//
//  TCGoodsTitleViewCell.m
//  individual
//
//  Created by 穆康 on 2017/9/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsTitleViewCell.h"
#import "TCGoodsDetail.h"

@interface TCGoodsTitleViewCell ()

@property (copy, nonatomic) UILabel *titleLabel;
@property (copy, nonatomic) UILabel *priceLabel;
@property (copy, nonatomic) UILabel *originPriceLabel;
@property (copy, nonatomic) UIImageView *tagImageView;
@property (copy, nonatomic) UILabel *tagLabel;

@end

@implementation TCGoodsTitleViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.textColor = TCBlackColor;
    priceLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:priceLabel];
    
    UILabel *originPriceLabel = [[UILabel alloc] init];
    originPriceLabel.textColor = TCLightGrayColor;
    originPriceLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:originPriceLabel];
    
    UIImageView *tagImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_tag"]];
    [self.contentView addSubview:tagImageView];
    
    UILabel *tagLabel = [[UILabel alloc] init];
    tagLabel.textColor = TCGrayColor;
    tagLabel.textAlignment = NSTextAlignmentRight;
    tagLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:tagLabel];
    
    self.titleLabel = titleLabel;
    self.priceLabel = priceLabel;
    self.originPriceLabel = originPriceLabel;
    self.tagImageView = tagImageView;
    self.tagLabel = tagLabel;
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(11);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(17);
        make.left.equalTo(self.titleLabel);
        make.bottom.equalTo(self.contentView).offset(-17);
    }];
    [self.originPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(17);
        make.bottom.equalTo(self.priceLabel).offset(-1);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.originPriceLabel);
        make.right.equalTo(self.titleLabel);
    }];
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 18));
        make.centerY.equalTo(self.tagLabel);
        make.right.equalTo(self.tagLabel.mas_left).offset(-2);
    }];
}

- (void)setGoodsDetail:(TCGoodsDetail *)goodsDetail {
    _goodsDetail = goodsDetail;
    
    self.titleLabel.text = goodsDetail.title;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", [NSNumber numberWithDouble:goodsDetail.salePrice]];
    
    
    NSAttributedString *originPriceStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:<#(nonnull NSString *), ...#>] attributes:<#(nullable NSDictionary<NSString *,id> *)#>]
}

@end
