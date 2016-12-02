//
//  TCPaymentView.m
//  individual
//
//  Created by 穆康 on 2016/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPaymentView.h"
#import "TCPaymentDetailView.h"
#import "TCPaymentPasswordView.h"

static CGFloat const subviewHeight = 400;
static CGFloat const duration = 0.25;

@interface TCPaymentView () <TCPaymentDetailViewDelegate, TCPaymentPasswordViewDelegate>

@property (nonatomic) CGFloat paymentAmount;
@property (weak, nonatomic) TCPaymentDetailView *paymentDetailView;
@property (weak, nonatomic) TCPaymentPasswordView *paymentPasswordView;

@end

@implementation TCPaymentView {
    __weak TCPaymentView *weakSelf;
    __weak UIViewController *sourceController;
}

- (instancetype)initWithAmount:(CGFloat)amount fromController:(UIViewController *)controller {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        weakSelf = self;
        sourceController = controller;
        _paymentAmount = amount;
        [self initPrivate];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    @throw [NSException exceptionWithName:@"TCPaymentView初始化错误"
                                   reason:@"请使用接口文件提供的初始化方法"
                                 userInfo:nil];
    return nil;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"TCPaymentView初始化错误"
                                   reason:@"请使用接口文件提供的初始化方法"
                                 userInfo:nil];
    return nil;
}

- (void)initPrivate {
    self.backgroundColor = TCARGBColor(0, 0, 0, 0);
    
    TCPaymentDetailView *paymentDetailView = [[NSBundle mainBundle] loadNibNamed:@"TCPaymentDetailView" owner:nil options:nil].lastObject;
    paymentDetailView.paymentAmount = _paymentAmount;
    paymentDetailView.delegate = self;
    paymentDetailView.frame = CGRectMake(0, TCScreenHeight, TCScreenWidth, subviewHeight);
    [self addSubview:paymentDetailView];
    self.paymentDetailView = paymentDetailView;
}

#pragma mark - Public Methods

- (void)show:(BOOL)animated {
    if (!sourceController) return;
    
    UIView *superView;
    if (sourceController.navigationController) {
        superView = sourceController.navigationController.view;
    } else {
        superView = sourceController.view;
    }
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
    
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
            weakSelf.paymentDetailView.y = TCScreenHeight - subviewHeight;
        }];
    } else {
        weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
        weakSelf.paymentDetailView.y = TCScreenHeight - subviewHeight;
    }
}

- (void)dismiss:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0);
            weakSelf.paymentDetailView.y = TCScreenHeight;
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
        }];
    } else {
        weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0);
        weakSelf.paymentDetailView.y = TCScreenHeight;
        [weakSelf removeFromSuperview];
    }
}

#pragma mark - Private Methods

- (void)showPaymentPasswordView {
    TCPaymentPasswordView *paymentPasswordView = [[NSBundle mainBundle] loadNibNamed:@"TCPaymentPasswordView" owner:nil options:nil].lastObject;
    paymentPasswordView.frame = CGRectMake(TCScreenWidth, self.paymentDetailView.y, TCScreenWidth, subviewHeight);
    paymentPasswordView.delegate = self;
    [self addSubview:paymentPasswordView];
    self.paymentPasswordView = paymentPasswordView;
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.paymentDetailView.x = - TCScreenWidth;
        weakSelf.paymentPasswordView.x = 0;
    } completion:^(BOOL finished) {
        [weakSelf.paymentPasswordView.textField becomeFirstResponder];
    }];
}

- (void)dismissPaymentPasswordView {
    [UIView animateWithDuration:duration animations:^{
        weakSelf.paymentDetailView.x = 0;
        weakSelf.paymentPasswordView.x = TCScreenWidth;
    } completion:^(BOOL finished) {
        [weakSelf.paymentPasswordView removeFromSuperview];
    }];
}

#pragma mark - TCPaymentDetailViewDelegate

- (void)didClickConfirmButtonInPaymentDetailView:(TCPaymentDetailView *)view {
    [self showPaymentPasswordView];
}

- (void)didClickCloseButtonInPaymentDetailView:(TCPaymentDetailView *)view {
    [self dismiss:YES];
}

- (void)didClickQueryButtonInPaymentDetailView:(TCPaymentDetailView *)view {
    TCLog(@"点击了疑问按钮");
}

#pragma mark - TCPaymentPasswordViewDelegate

- (void)didClickBackButtonInPaymentPasswordView:(TCPaymentPasswordView *)view {
    [self dismissPaymentPasswordView];
}

@end
