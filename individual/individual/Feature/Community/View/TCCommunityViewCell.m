//
//  TCCommunityViewCell.m
//  individual
//
//  Created by 穆康 on 2016/11/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunityViewCell.h"

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

- (IBAction)handleClickPhoneButton:(UIButton *)sender {
    
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
