//
//  TCBioEditAffectionView.m
//  individual
//
//  Created by 穆康 on 2016/10/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditAffectionView.h"

@interface TCBioEditAffectionView ()

@property (strong, nonatomic) UIButton *currentButton;

@end

@implementation TCBioEditAffectionView


- (IBAction)handleTapAffectionButton:(UIButton *)sender {
    sender.selected = YES;
    self.currentButton.selected = NO;
    self.currentButton = sender;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
