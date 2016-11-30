//
//  TCCommunityLocationViewCell.m
//  individual
//
//  Created by 穆康 on 2016/11/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunityLocationViewCell.h"
#import "TCCommunityDetailInfo.h"

#import "TCImageURLSynthesizer.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface TCCommunityLocationViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation TCCommunityLocationViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setCommunityDetailInfo:(TCCommunityDetailInfo *)communityDetailInfo {
    _communityDetailInfo = communityDetailInfo;
    
    NSURL *imageURL = [TCImageURLSynthesizer synthesizeImageURLWithPath:communityDetailInfo.map];
    [self.mapImageView sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRetryFailed];
    
    self.addressLabel.text = communityDetailInfo.address;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
