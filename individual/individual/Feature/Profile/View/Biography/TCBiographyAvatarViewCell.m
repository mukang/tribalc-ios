//
//  TCBiographyAvatarViewCell.m
//  individual
//
//  Created by 穆康 on 2016/10/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBiographyAvatarViewCell.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface TCBiographyAvatarViewCell ()



@end

@implementation TCBiographyAvatarViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.avatarImageView.layer.cornerRadius = 30;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
