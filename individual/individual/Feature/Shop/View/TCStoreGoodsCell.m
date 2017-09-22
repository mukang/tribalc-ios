//
//  TCStoreGoodsCell.m
//  individual
//
//  Created by 王帅锋 on 2017/9/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreGoodsCell.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "TCGoods.h"

@interface TCStoreGoodsCell ()

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIImageView *goodsImageView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *moneyLabel;

@property (strong, nonatomic) UILabel *tagsLabel;

@end

@implementation TCStoreGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setGoods:(TCGoods *)goods {
    if (_goods != goods) {
        _goods = goods;
        
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:goods.mainPicture];
        UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(123, 92)];
        [self.goodsImageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
        self.titleLabel.text = [NSString stringWithFormat:@"%@", goods.name];
        self.moneyLabel.text = [NSString stringWithFormat:@"￥%@", @(goods.salePrice)];
        if ([goods.tags isKindOfClass:[NSArray class]] && goods.tags.count > 0) {
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] init];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            attch.image = [UIImage imageNamed:@"store_goods_tags_Icon"];
            attch.bounds = CGRectMake(0, -3, 15, 15);
            NSAttributedString *attString = [NSAttributedString attributedStringWithAttachment:attch];
            [att appendAttributedString:attString];
            NSString *tagStr = [NSString stringWithFormat:@"  %@",goods.tags[0]];
            if (goods.tags.count == 2) {
                tagStr = [NSString stringWithFormat:@"  %@  |  %@", goods.tags[0], goods.tags[1]];
            }else if (goods.tags.count == 3) {
                tagStr = [NSString stringWithFormat:@"  %@  |  %@  |  %@", goods.tags[0], goods.tags[1], goods.tags[2]];
            }
            
            NSAttributedString *tagStrAtt = [[NSAttributedString alloc] initWithString:tagStr];
            [att appendAttributedString:tagStrAtt];
            
            self.tagsLabel.attributedText = att;
        }
    }
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.tagsLabel];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(@0.5);
    }];
    
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView);
        make.top.equalTo(self.lineView.mas_bottom).offset(10);
        make.width.equalTo(@123);
        make.height.equalTo(@92);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(15);
        make.top.equalTo(self.goodsImageView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
    
    [self.tagsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
}

- (UILabel *)tagsLabel {
    if (_tagsLabel == nil) {
        _tagsLabel = [[UILabel alloc] init];
        _tagsLabel.textColor = TCLightGrayColor;
        _tagsLabel.font = [UIFont systemFontOfSize:11];
    }
    return _tagsLabel;
}

- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor redColor];
        _moneyLabel.font = [UIFont systemFontOfSize:20];
    }
    return _moneyLabel;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = TCBlackColor;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIImageView *)goodsImageView {
    if (_goodsImageView == nil) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _goodsImageView.clipsToBounds = YES;
    }
    return _goodsImageView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = TCSeparatorLineColor;
    }
    return _lineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
