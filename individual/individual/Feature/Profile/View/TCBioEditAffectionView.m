//
//  TCBioEditAffectionView.m
//  individual
//
//  Created by 穆康 on 2016/10/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditAffectionView.h"

@interface TCBioEditAffectionView ()

@property (weak, nonatomic) IBOutlet UIButton *marriedButton;
@property (weak, nonatomic) IBOutlet UIButton *singleButton;
@property (weak, nonatomic) IBOutlet UIButton *loveButton;

@property (strong, nonatomic) UIButton *currentButton;
@property (nonatomic) TCUserEmotionState currentEmotionState;

@end

@implementation TCBioEditAffectionView

- (void)setEmotionState:(TCUserEmotionState)emotionState {
    _emotionState = emotionState;
    self.currentEmotionState = emotionState;
    self.marriedButton.selected = NO;
    self.singleButton.selected = NO;
    self.loveButton.selected = NO;
    switch (emotionState) {
        case TCUserEmotionStateMarried:
            self.marriedButton.selected = YES;
            self.currentButton = self.marriedButton;
            break;
        case TCUserEmotionStateSingle:
            self.singleButton.selected = YES;
            self.currentButton = self.singleButton;
            break;
        case TCUserEmotionStateLove:
            self.loveButton.selected = YES;
            self.currentButton = self.loveButton;
            break;
        default:
            break;
    }
}


- (IBAction)handleTapAffectionButton:(UIButton *)sender {
    if ([sender isEqual:self.currentButton]) {
        return;
    }
    if ([sender isEqual:self.marriedButton]) {
        self.currentEmotionState = TCUserEmotionStateMarried;
    } else if ([sender isEqual:self.loveButton]) {
        self.currentEmotionState = TCUserEmotionStateLove;
    } else {
        self.currentEmotionState = TCUserEmotionStateSingle;
    }
    sender.selected = YES;
    self.currentButton.selected = NO;
    self.currentButton = sender;
}

- (IBAction)handleClickCommitButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bioEditAffectionView:didClickCommitButtonWithEmotionState:)]) {
        [self.delegate bioEditAffectionView:self didClickCommitButtonWithEmotionState:self.currentEmotionState];
    }
}

- (IBAction)handleClickCancelButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonInBioEditAffectionView:)]) {
        [self.delegate didClickCancelButtonInBioEditAffectionView:self];
    }
}

@end
