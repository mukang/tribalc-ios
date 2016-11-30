//
//  TCCommunitySurroundingViewCell.m
//  individual
//
//  Created by 穆康 on 2016/11/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunitySurroundingViewCell.h"

#import "TCStoreInfo.h"

#import "TCImageURLSynthesizer.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface TCCommunitySurroundingViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *perLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation TCCommunitySurroundingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.logoImageView.layer.cornerRadius = 2.5;
    self.logoImageView.layer.masksToBounds = YES;
    
    self.perLabel.hidden = YES;
    self.distanceLabel.hidden = YES;
}

- (void)setStoreInfo:(TCStoreInfo *)storeInfo {
    _storeInfo = storeInfo;
    
    NSURL *imageURL = [TCImageURLSynthesizer synthesizeImageURLWithPath:storeInfo.thumbnail];
    [self.logoImageView sd_setImageWithURL:imageURL placeholderImage:nil options:SDWebImageRetryFailed];
    
    self.nameLabel.text = storeInfo.name;
    
    if (storeInfo.tags.count) {
        self.tagLabel.text = [NSString stringWithFormat:@"%@|%@", storeInfo.markPlace, storeInfo.tags[0]];
    } else {
        self.tagLabel.text = storeInfo.markPlace;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
