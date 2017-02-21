//
//  TCRechargeMethodView.m
//  individual
//
//  Created by 穆康 on 2016/12/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRechargeMethodView.h"

@implementation TCRechargeMethodView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = TCRGBColor(154, 154, 154);
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLabel];
    
    TCExtendButton *button = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"profile_common_address_button_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"profile_common_address_button_selected"] forState:UIControlStateSelected];
    button.hitTestSlop = UIEdgeInsetsMake(-8, -20, -8, -20);
    [self addSubview:button];
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = [UIColor whiteColor];
    [self addSubview:separatorView];
    
    self.imageView = imageView;
    self.titleLabel = titleLabel;
    self.button = button;
    self.separatorView = separatorView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17.5, 17.5));
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 21));
        make.left.equalTo(weakSelf.imageView.mas_right).with.offset(11);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.right.equalTo(weakSelf.mas_right).with.offset(-20);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.mas_right).with.offset(-20);
        make.bottom.equalTo(weakSelf.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

@end
