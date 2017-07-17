//
//  TCSearchBarView.m
//  individual
//
//  Created by 穆康 on 2017/7/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSearchBarView.h"

@implementation TCSearchBarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = TCRGBColor(225, 225, 225);
    containerView.layer.cornerRadius = 2.5;
    containerView.layer.masksToBounds = YES;
    [self addSubview:containerView];
    
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_icon"]];
    [containerView addSubview:iconView];
    
    UITextField *textField = [[UITextField alloc] init];
    textField.textColor = TCBlackColor;
    textField.font = [UIFont systemFontOfSize:12];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入搜索内容"
                                                                      attributes:@{
                                                                                   NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                   NSForegroundColorAttributeName: TCGrayColor
                                                                                   }];
    textField.returnKeyType = UIReturnKeySearch;
    textField.enablesReturnKeyAutomatically = YES;
    [containerView addSubview:textField];
    self.textField = textField;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:TCBlackColor forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:cancelButton];
    self.cancelButton = cancelButton;
    
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-52);
        make.centerY.equalTo(self.mas_top).offset(42);
    }];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(13, 13));
        make.left.equalTo(containerView).offset(11);
        make.centerY.equalTo(containerView);
    }];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(6);
        make.top.bottom.right.equalTo(containerView);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView.mas_right);
        make.right.equalTo(self);
        make.height.centerY.equalTo(containerView);
    }];
}

@end
