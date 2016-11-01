//
//  TCBioEditView.m
//  individual
//
//  Created by 穆康 on 2016/10/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditView.h"

@implementation TCBioEditView


- (IBAction)handleClickCommitButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCommitButtonInBioEditView:)]) {
        [self.delegate didClickCommitButtonInBioEditView:self];
    }
}

- (IBAction)handleClickCancelButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonInBioEditView:)]) {
        [self.delegate didClickCancelButtonInBioEditView:self];
    }
}

@end
