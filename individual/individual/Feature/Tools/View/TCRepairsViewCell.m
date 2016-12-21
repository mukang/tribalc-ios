//
//  TCRepairsViewCell.m
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRepairsViewCell.h"

@interface TCRepairsViewCell ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *repairsButtons;


@end

@implementation TCRepairsViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CGFloat originSpace = 1, space = 13;
    CGSize imageViewSize, labelSize;
    for (int i=0; i<self.repairsButtons.count; i++) {
        UIButton *button = self.repairsButtons[i];
        button.tag = 1000 + i;
        imageViewSize = button.imageView.size;
        labelSize = button.titleLabel.size;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, labelSize.height + space, -labelSize.width + originSpace);
        button.titleEdgeInsets = UIEdgeInsetsMake(imageViewSize.height + space, -imageViewSize.width + originSpace, 0, 0);
    }
}

- (IBAction)handleClickRepairsButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(repairsViewCell:didClickRepairsButtonWithIndex:)]) {
        [self.delegate repairsViewCell:self didClickRepairsButtonWithIndex:sender.tag - 1000];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
