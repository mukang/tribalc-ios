//
//  TCMeetingRoomSelectViewCell.m
//  individual
//
//  Created by 穆康 on 2017/10/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomSelectViewCell.h"

@interface TCMeetingRoomSelectViewCell ()

@property (weak, nonatomic) UIImageView *arrowImageView;

@end

@implementation TCMeetingRoomSelectViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.textColor = TCLightGrayColor;
    subTitleLabel.textAlignment = NSTextAlignmentRight;
    subTitleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:subTitleLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right_gray"]];
    [self.contentView addSubview:arrowImageView];
    
    self.titleLabel = titleLabel;
    self.subTitleLabel = subTitleLabel;
    self.arrowImageView = arrowImageView;
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(-15);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(10, 16.5));
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.titleLabel);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
