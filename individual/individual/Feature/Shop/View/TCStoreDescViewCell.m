//
//  TCStoreDescViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreDescViewCell.h"
#import "TCListStore.h"

@interface TCStoreDescViewCell ()

@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIImageView *locationIcon;
@property (weak, nonatomic) UILabel *markLabel;
@property (weak, nonatomic) UILabel *descLabel;

@end

@implementation TCStoreDescViewCell

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCBlackColor;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:22.5];
    nameLabel.numberOfLines = 0;
    [self.contentView addSubview:nameLabel];
    
    UIImageView *locationIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_location_icon"]];
    [self.contentView addSubview:locationIcon];
    
    UILabel *markLabel = [[UILabel alloc] init];
    markLabel.textColor = TCBlackColor;
    markLabel.textAlignment = NSTextAlignmentLeft;
    markLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:markLabel];
    
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.numberOfLines = 0;
    [self.contentView addSubview:descLabel];
    
    self.nameLabel = nameLabel;
    self.locationIcon = locationIcon;
    self.markLabel = markLabel;
    self.descLabel = descLabel;
}

- (void)setupConstraints {
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.contentView).offset(29);
    }];
    [self.locationIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(9.5, 12));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(18);
        make.left.equalTo(self.nameLabel);
    }];
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationIcon.mas_right).offset(5);
        make.centerY.equalTo(self.locationIcon);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.locationIcon.mas_bottom).offset(25);
        make.left.equalTo(self.locationIcon);
        make.right.equalTo(self.contentView).offset(-20);
        make.bottom.equalTo(self.contentView).offset(-15);
    }];
}

- (void)setStoreInfo:(TCListStore *)storeInfo {
    _storeInfo = storeInfo;
    
    self.nameLabel.text = storeInfo.name;
    self.markLabel.text = [NSString stringWithFormat:@"%@ | %@", storeInfo.category, storeInfo.markPlace];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    paragraphStyle.paragraphSpacing = 30;
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:storeInfo.desc
                                                                 attributes:@{
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                              NSForegroundColorAttributeName: TCGrayColor,
                                                                              NSParagraphStyleAttributeName: paragraphStyle
                                                                              }];
    self.descLabel.attributedText = attStr;
}

@end
