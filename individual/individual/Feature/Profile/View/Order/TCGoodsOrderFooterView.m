//
//  TCGoodsOrderFooterView.m
//  store
//
//  Created by 穆康 on 2017/2/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsOrderFooterView.h"
#import "TCOrder.h"

@interface TCGoodsOrderFooterView ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *amountLabel;

@end

@implementation TCGoodsOrderFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"总计：";
    titleLabel.textColor = TCRGBColor(154, 154, 154);
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLabel];
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.textColor = TCRGBColor(42, 42, 42);
    amountLabel.font = [UIFont boldSystemFontOfSize:18];
    [self addSubview:amountLabel];
    
    self.titleLabel = titleLabel;
    self.amountLabel = amountLabel;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(weakSelf);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.amountLabel.mas_left);
        make.height.mas_equalTo(14);
        make.bottom.equalTo(weakSelf.amountLabel);
    }];
}

- (void)setOrder:(TCOrder *)order {
    _order = order;
    
    self.amountLabel.text = [NSString stringWithFormat:@"¥ %0.2f", order.totalFee];
}

@end
