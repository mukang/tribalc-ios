//
//  TCRechargeInputView.m
//  individual
//
//  Created by 穆康 on 2016/12/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRechargeInputView.h"
#import <Masonry.h>

@implementation TCRechargeInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.5;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.text = @"充值金额";
    amountLabel.textAlignment = NSTextAlignmentLeft;
    amountLabel.textColor = TCRGBColor(42, 42, 42);
    amountLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:amountLabel];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.textAlignment = NSTextAlignmentRight;
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入充值金额"
                                                                      attributes:@{
                                                                                   NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                   NSForegroundColorAttributeName: TCRGBColor(154, 154, 154)
                                                                                   }];
    [self addSubview:textField];
    self.textField = textField;
    
    __weak typeof(self) weakSelf = self;
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(10);
        make.top.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(65);
    }];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(amountLabel.mas_right);
        make.top.bottom.equalTo(weakSelf);
        make.right.equalTo(weakSelf.mas_right).with.offset(-10);
    }];
}

@end
