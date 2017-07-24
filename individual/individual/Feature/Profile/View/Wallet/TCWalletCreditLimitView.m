//
//  TCWalletCreditLimitView.m
//  individual
//
//  Created by 穆康 on 2017/7/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletCreditLimitView.h"

@implementation TCWalletCreditLimitView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 7.5;
    self.layer.masksToBounds = YES;
    
}

@end
