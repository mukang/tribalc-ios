//
//  TCCommunityViewCell.m
//  individual
//
//  Created by 穆康 on 2016/11/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunityViewCell.h"
#import "TCCommunity.h"
#import "TCClientConfig.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TCCommunityViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@end

@implementation TCCommunityViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageView.layer.cornerRadius = 2.5;
    self.imageView.layer.masksToBounds = YES;
}

- (void)setCommunity:(TCCommunity *)community {
    _community = community;
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"" TCCLIENT_RESOURCES_BASE_URL "%@", community.mainPicture]];
    [self.imageView sd_setImageWithURL:URL placeholderImage:nil options:SDWebImageRetryFailed];
    
    self.nameLabel.text = community.name;
    
    self.addressLabel.text = community.address;
    
    NSString *phone = community.phone ?: @"";
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:phone
                                                                 attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11],
                                                                              NSForegroundColorAttributeName: TCRGBColor(81, 199, 209),
                                                                              NSUnderlineColorAttributeName: TCRGBColor(81, 199, 209),
                                                                              NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
                                                                              }];
    [self.phoneButton setAttributedTitle:attStr forState:UIControlStateNormal];
}

- (IBAction)handleClickPhoneButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(communityViewCell:didClickPhoneButtonWithCommunity:)]) {
        [self.delegate communityViewCell:self didClickPhoneButtonWithCommunity:self.community];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = TCRGBColor(217, 217, 217);
    } else {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            weakSelf.backgroundColor = [UIColor whiteColor];
        } completion:nil];
    }
}

@end
