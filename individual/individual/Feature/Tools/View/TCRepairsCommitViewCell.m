//
//  TCRepairsCommitViewCell.m
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRepairsCommitViewCell.h"

#import "UIImage+Category.h"

@interface TCRepairsCommitViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation TCRepairsCommitViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIImage *normalImage = [UIImage imageWithColor:TCRGBColor(81, 199, 209)];
    UIImage *highlightedImage = [UIImage imageWithColor:TCRGBColor(10, 164, 177)];
    [self.commitButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.commitButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    self.commitButton.layer.cornerRadius = 2.5;
    self.commitButton.layer.masksToBounds = YES;
}

- (IBAction)handleClickCommitButton:(UIButton *)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
