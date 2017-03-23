//
//  TCRechargeMethodsView.m
//  individual
//
//  Created by 穆康 on 2016/12/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRechargeMethodsView.h"
#import "TCRechargeMethodView.h"

@interface TCRechargeMethodsView ()

@property (weak, nonatomic) UILabel *methodLabel;
@property (weak, nonatomic) UIView *topSeparatorView;
@property (weak, nonatomic) TCRechargeMethodView *wechatView;
@property (weak, nonatomic) TCRechargeMethodView *alipayView;

@end

@implementation TCRechargeMethodsView

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
    UILabel *methodLabel = [[UILabel alloc] init];
    methodLabel.text = @"充值方式";
    methodLabel.textAlignment = NSTextAlignmentLeft;
    methodLabel.textColor = TCGrayColor;
    methodLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:methodLabel];
    
    UIView *topSeparatorView = [[UIView alloc] init];
    topSeparatorView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topSeparatorView];
    
    TCRechargeMethodView *wechatView = [[TCRechargeMethodView alloc] init];
    wechatView.imageView.image = [UIImage imageNamed:@"wechat_icon"];
    wechatView.titleLabel.text = @"微信充值";
    [wechatView.button addTarget:self action:@selector(handleClickWechatButton:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:wechatView];
    
//    TCRechargeMethodView *alipayView = [[TCRechargeMethodView alloc] init];
//    alipayView.imageView.image = [UIImage imageNamed:@"alipay_icon"];
//    alipayView.titleLabel.text = @"支付宝充值";
//    [alipayView.button addTarget:self action:@selector(handleClickAlipayButton:) forControlEvents:UIControlEventTouchDown];
//    [self addSubview:alipayView];
    
    self.methodLabel = methodLabel;
    self.topSeparatorView = topSeparatorView;
    self.wechatView = wechatView;
//    self.alipayView = alipayView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.methodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 14));
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
    }];
    [self.topSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).with.offset(36);
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.mas_right).with.offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    [self.wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topSeparatorView.mas_bottom);
        make.left.right.equalTo(weakSelf);
        make.height.mas_equalTo(40);
    }];
//    [self.alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.wechatView.mas_bottom);
//        make.left.right.equalTo(weakSelf);
//        make.height.mas_equalTo(40);
//    }];
}

- (void)setRechargeMethod:(TCRechargeMethod)rechargeMethod {
    _rechargeMethod = rechargeMethod;
    
    switch (rechargeMethod) {
        case TCRechargeMethodWechat:
            self.wechatView.button.selected = YES;
            self.alipayView.button.selected = NO;
            break;
        case TCRechargeMethodAlipay:
            self.wechatView.button.selected = NO;
            self.alipayView.button.selected = YES;
            break;
            
        default:
            break;
    }
}

#pragma mark - Actions

- (void)handleClickWechatButton:(UIButton *)sender {
    self.rechargeMethod = TCRechargeMethodWechat;
    if ([self.delegate respondsToSelector:@selector(rechargeMethodsView:didSelectedMethodButtonWithMethod:)]) {
        [self.delegate rechargeMethodsView:self didSelectedMethodButtonWithMethod:TCRechargeMethodWechat];
    }
}

- (void)handleClickAlipayButton:(UIButton *)sender {
    self.rechargeMethod = TCRechargeMethodAlipay;
    if ([self.delegate respondsToSelector:@selector(rechargeMethodsView:didSelectedMethodButtonWithMethod:)]) {
        [self.delegate rechargeMethodsView:self didSelectedMethodButtonWithMethod:TCRechargeMethodAlipay];
    }
}

@end
