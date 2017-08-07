//
//  TCStoreCell.m
//  individual
//
//  Created by 王帅锋 on 2017/7/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreCell.h"
#import "TCListStore.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <UIImageView+WebCache.h>
#import <TCCommonLibs/UIImage+Category.h>

@interface TCStoreCell ()

@property (strong, nonatomic) UIImageView *bgImageView;

@property (strong, nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UILabel *desLabel;

@property (strong, nonatomic) UIImageView *locationImageView;

@property (strong, nonatomic) UILabel *tagsLabel;

@property (strong, nonatomic) UILabel *moneyLabel;

@end

@implementation TCStoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setStore:(TCListStore *)store {
    if (_store != store) {
        _store = store;
        
        if ([store.pictures isKindOfClass:[NSArray class]] && store.pictures.count > 0) {
            NSString *str = store.pictures[0];
            if ([str isKindOfClass:[NSString class]]) {
                NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:str];
                UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(TCScreenWidth, TCRealValue(252))];
                [self.bgImageView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
            }
        }
        
        NSURL *URL = [TCImageURLSynthesizer synthesizeAvatarImageURLWithUserID:store.ID needTimestamp:NO];
        [self.iconImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
        
        self.desLabel.text = store.name;
        self.tagsLabel.text = [NSString stringWithFormat:@"%@ | %@", store.category, store.markPlace];
        NSString *moneyStr = [NSString stringWithFormat:@"¥%.0f",store.avgprice];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
        [attStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} range:NSMakeRange(0, 1)];
        self.moneyLabel.attributedText = attStr;
    }
}

- (void)setUpViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.desLabel];
    [self.contentView addSubview:self.locationImageView];
    [self.contentView addSubview:self.tagsLabel];
    [self.contentView addSubview:self.moneyLabel];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(TCRealValue(12));
        make.top.equalTo(self.contentView).offset(TCRealValue(15));
        make.width.height.equalTo(@(TCRealValue(45)));
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(TCRealValue(10));
        make.right.equalTo(self.contentView).offset(-TCRealValue(10));
        make.bottom.equalTo(self.contentView).offset(-TCRealValue(50));
    }];
    
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(TCRealValue(15));
        make.top.equalTo(self.desLabel.mas_bottom).offset(TCRealValue(15));
        make.width.equalTo(@(TCRealValue(10)));
        make.height.equalTo(@(TCRealValue(12)));
    }];
    
    [self.tagsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationImageView).offset(-TCRealValue(2));
        make.left.equalTo(self.locationImageView.mas_right).offset(TCRealValue(5));
        make.width.equalTo(@(TCRealValue(220)));
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagsLabel.mas_right);
        make.top.equalTo(self.desLabel.mas_bottom);
        make.right.equalTo(self.contentView).offset(-TCRealValue(10));
    }];
}

- (UILabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor whiteColor];
        _moneyLabel.font = [UIFont systemFontOfSize:31];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.baselineAdjustment = UIBaselineAdjustmentNone;
    }
    return _moneyLabel;
}

- (UILabel *)tagsLabel {
    if (_tagsLabel == nil) {
        _tagsLabel = [[UILabel alloc] init];
        _tagsLabel.font = [UIFont systemFontOfSize:12];
        _tagsLabel.textColor = [UIColor whiteColor];
    }
    return _tagsLabel;
}

- (UIImageView *)locationImageView {
    if (_locationImageView == nil) {
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.image = [UIImage imageNamed:@"location"];
    }
    return _locationImageView;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont systemFontOfSize:16];
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.numberOfLines = 0;
    }
    return _desLabel;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = TCRealValue(45)/2;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.layer.borderWidth = 2.0;
    }
    return _iconImageView;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.clipsToBounds = YES;
    }
    return _bgImageView;
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
