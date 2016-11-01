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

- (IBAction)handleClickCommitButton:(UIButton *)sender {
}

- (IBAction)handleClickCancelButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonInBioEditAffectionView:)]) {
        [self.delegate didClickCancelButtonInBioEditAffectionView:self];
    }
}

@end
