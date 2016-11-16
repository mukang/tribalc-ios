//
//  TCBioEditGenderView.m
//  individual
//
//  Created by 穆康 on 2016/10/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditGenderView.h"

@interface TCBioEditGenderView ()

@property (weak, nonatomic) IBOutlet UIButton *maleButton;
@property (weak, nonatomic) IBOutlet UIButton *femaleButton;
@property (nonatomic) TCUserGender currentGender;

@end

@implementation TCBioEditGenderView

- (void)setGender:(TCUserGender)gender {
    _gender = gender;
    self.currentGender = gender;
    switch (gender) {
        case TCUserGenderUnknown:
            self.maleButton.selected = NO;
            self.femaleButton.selected = NO;
            break;
        case TCUserGenderMale:
            self.maleButton.selected = YES;
            self.femaleButton.selected = NO;
            break;
        case TCUserGenderFemale:
            self.maleButton.selected = NO;
            self.femaleButton.selected = YES;
            break;
        default:
            break;
    }
}

- (IBAction)handleClickGenderButton:(UIButton *)sender {
    if ([sender isEqual:self.maleButton]) {
        self.maleButton.selected = YES;
        self.femaleButton.selected = NO;
        self.currentGender = TCUserGenderMale;
    } else {
        self.maleButton.selected = NO;
        self.femaleButton.selected = YES;
        self.currentGender = TCUserGenderFemale;
    }
}


- (IBAction)handleClickCommitButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(bioEditGenderView:didClickCommitButtonWithGender:)]) {
        [self.delegate bioEditGenderView:self didClickCommitButtonWithGender:self.currentGender];
    }
}

- (IBAction)handleClickCancelButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonInBioEditGenderView:)]) {
        [self.delegate didClickCancelButtonInBioEditGenderView:self];
    }
}


@end
