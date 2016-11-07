//
//  TCProfileHeaderView.m
//  individual
//
//  Created by 穆康 on 2016/11/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCProfileHeaderView.h"

@implementation TCProfileHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.avatarBgView.layer.cornerRadius = 32;
    self.avatarBgView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 29.5;
    self.avatarImageView.layer.masksToBounds = YES;
    self.wantGradeButton.layer.cornerRadius = 7.5;
    self.wantGradeButton.layer.masksToBounds = YES;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    
}

#pragma mark - actions

- (IBAction)handleClickCardButton:(UIButton *)sender {
}

- (IBAction)handleClickCollectButton:(UIButton *)sender {
}

- (IBAction)handleClickGradeButton:(UIButton *)sender {
}

- (IBAction)handleClickPhotographButton:(UIButton *)sender {
}

@end
