//
//  TCGoodsOrderCountDownView.m
//  individual
//
//  Created by 穆康 on 2017/2/16.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderCountDownView.h"

@interface TCGoodsOrderCountDownView ()

@property (weak, nonatomic) UIButton *button;

@end

@implementation TCGoodsOrderCountDownView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.backgroundColor = TCBackgroundColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userInteractionEnabled = NO;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    [button setImage:[UIImage imageNamed:@"goods_order_count_down"] forState:UIControlStateNormal];
    [self addSubview:button];
    self.button = button;
    
    __weak typeof(self) weakSelf = self;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.right.equalTo(weakSelf).offset(-20);
        make.height.mas_equalTo(12);
        make.bottom.equalTo(weakSelf);
    }];
}

- (void)setCountDowntext:(NSString *)countDowntext {
    _countDowntext = countDowntext;
    
    [self.button setAttributedTitle:[[NSAttributedString alloc] initWithString:countDowntext
                                                                    attributes:@{
                                                                                 NSFontAttributeName: [UIFont systemFontOfSize:10],
                                                                                 NSForegroundColorAttributeName: TCGrayColor
                                                                                 }]
                           forState:UIControlStateNormal];
}

@end
