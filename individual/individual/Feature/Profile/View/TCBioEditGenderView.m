//
//  TCBioEditGenderView.m
//  individual
//
//  Created by 穆康 on 2016/10/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditGenderView.h"

@implementation TCBioEditGenderView

- (IBAction)handleClickGenderButton:(UIButton *)sender {
    
}


- (IBAction)handleClickCommitButton:(UIButton *)sender {
}

- (IBAction)handleClickCancelButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonInBioEditGenderView:)]) {
        [self.delegate didClickCancelButtonInBioEditGenderView:self];
    }
}


@end
