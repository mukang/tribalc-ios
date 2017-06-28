//
//  TCRentPayTabView.m
//  individual
//
//  Created by 穆康 on 2017/6/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRentPayTabView.h"
#import <TCCommonLibs/TCCommonButton.h>

@implementation TCRentPayTabView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *verticalLine = [[UIView alloc] init];
    verticalLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:verticalLine];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:bottomLine];
    
    UIButton *rentPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rentPayButton setTitle:@"" forState:UIControlStateNormal];
    [rentPayButton setTitleColor:TCLightGrayColor forState:UIControlStateNormal];
    [rentPayButton setTitleColor:TCBlackColor forState:UIControlStateSelected];
    
}

@end
