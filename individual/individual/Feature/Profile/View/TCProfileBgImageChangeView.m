//
//  TCProfileBgImageChangeView.m
//  individual
//
//  Created by 穆康 on 2016/11/9.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCProfileBgImageChangeView.h"

@implementation TCProfileBgImageChangeView

- (IBAction)handleClickPhotographButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickPhotographButtonInProfileBgImageChangeView:)]) {
        [self.delegate didClickPhotographButtonInProfileBgImageChangeView:self];
    }
}

- (IBAction)handleClickAlbumButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickAlbumButtonInProfileBgImageChangeView:)]) {
        [self.delegate didClickAlbumButtonInProfileBgImageChangeView:self];
    }
}

- (IBAction)handleClickCancelButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonInProfileBgImageChangeView:)]) {
        [self.delegate didClickCancelButtonInProfileBgImageChangeView:self];
    }
}

@end
