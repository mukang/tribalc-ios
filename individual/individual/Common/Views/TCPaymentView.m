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
#import "TCPaymentMethodView.h"
#import "TCBuluoApi.h"
#import "TCFunctions.h"

#import "TCNavigationController.h"
#import "TCRechargeViewController.h"

static CGFloat const subviewHeight = 400;
static CGFloat const duration = 0.25;

@interface TCPaymentView () <TCPaymentDetailViewDelegate, TCPaymentPasswordViewDelegate, TCPaymentMethodViewDelegate>

@property (nonatomic) CGFloat paymentAmount;
@property (weak, nonatomic) TCPaymentDetailView *paymentDetailView;
@property (weak, nonatomic) TCPaymentPasswordView *paymentPasswordView;
@property (weak, nonatomic) TCPaymentMethodView *paymentMethodView;
/** 钱包信息 */
@property (strong, nonatomic) TCWalletAccount *walletAccount;

@property (nonatomic) TCPaymentMethod currentPaymentMethod;

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
    paymentDetailView.methodLabel.text = @"余额支付";
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
    [self dismiss:animated completion:nil];
}

- (void)dismiss:(BOOL)animated completion:(void (^)())completion {
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0);
            weakSelf.paymentDetailView.y = TCScreenHeight;
        } completion:^(BOOL finished) {
            [weakSelf removeFromSuperview];
            if (completion) {
                completion();
            }
        }];
    } else {
        weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0);
        weakSelf.paymentDetailView.y = TCScreenHeight;
        [weakSelf removeFromSuperview];
        if (completion) {
            completion();
        }
    }
}

#pragma mark - Private Methods

/**
 显示输入密码页
 */
- (void)showPaymentPasswordView {
    TCPaymentPasswordView *paymentPasswordView = [[NSBundle mainBundle] loadNibNamed:@"TCPaymentPasswordView" owner:nil options:nil].lastObject;
    paymentPasswordView.frame = CGRectMake(TCScreenWidth, self.paymentDetailView.y, TCScreenWidth, subviewHeight);
    paymentPasswordView.delegate = self;
    paymentPasswordView.textField.centerX = paymentPasswordView.width / 2;
    [self addSubview:paymentPasswordView];
    self.paymentPasswordView = paymentPasswordView;
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.paymentDetailView.x = - TCScreenWidth;
        weakSelf.paymentPasswordView.x = 0;
    } completion:^(BOOL finished) {
        [weakSelf.paymentPasswordView.textField becomeFirstResponder];
    }];
}

/**
 退出输入密码页
 */
- (void)dismissPaymentPasswordView {
    [UIView animateWithDuration:duration animations:^{
        weakSelf.paymentDetailView.x = 0;
        weakSelf.paymentPasswordView.x = TCScreenWidth;
    } completion:^(BOOL finished) {
        [weakSelf.paymentPasswordView removeFromSuperview];
    }];
}

/**
 显示选择支付方式页
 */
- (void)showPaymentMethodView {
    TCPaymentMethodView *paymentMethodView = [[TCPaymentMethodView alloc] initWithPaymentMethod:self.currentPaymentMethod];
    paymentMethodView.frame = CGRectMake(TCScreenWidth, self.paymentDetailView.y, TCScreenWidth, subviewHeight);
    paymentMethodView.delegate = self;
    [self addSubview:paymentMethodView];
    self.paymentMethodView = paymentMethodView;
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.paymentDetailView.x = - TCScreenWidth;
        weakSelf.paymentMethodView.x = 0;
    }];
}

/**
 退出选择支付方式页
 */
- (void)dismissPaymentMethodView {
    [UIView animateWithDuration:duration animations:^{
        weakSelf.paymentDetailView.x = 0;
        weakSelf.paymentMethodView.x = TCScreenWidth;
    } completion:^(BOOL finished) {
        [weakSelf.paymentMethodView removeFromSuperview];
    }];
}

#pragma mark - TCPaymentDetailViewDelegate

- (void)didClickConfirmButtonInPaymentDetailView:(TCPaymentDetailView *)view {
//    [weakSelf showPaymentPasswordView];
    [self handleClickConfirmButton];
}

- (void)didClickCloseButtonInPaymentDetailView:(TCPaymentDetailView *)view {
    [self dismiss:YES completion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickCloseButtonInPaymentView:)]) {
            [weakSelf.delegate didClickCloseButtonInPaymentView:self];
        }
    }];
}

- (void)didClickQueryButtonInPaymentDetailView:(TCPaymentDetailView *)view {
    TCLog(@"点击了疑问按钮");
}

- (void)didTapChangePaymentMethodViewInPaymentDetailView:(TCPaymentDetailView *)view {
    [self showPaymentMethodView];
}

#pragma mark - TCPaymentPasswordViewDelegate

- (void)paymentPasswordView:(TCPaymentPasswordView *)view didFilledPassword:(NSString *)password {
    [self handlePaymentWithPassword:password];
}

- (void)didClickBackButtonInPaymentPasswordView:(TCPaymentPasswordView *)view {
    [self dismissPaymentPasswordView];
}

#pragma mark - TCPaymentMethodViewDelegate

- (void)paymentMethodView:(TCPaymentMethodView *)view didSlectedPaymentMethod:(TCPaymentMethod)paymentMethod {
    self.currentPaymentMethod = paymentMethod;
    switch (paymentMethod) {
        case TCPaymentMethodBalance:
            self.paymentDetailView.methodLabel.text = @"余额支付";
            break;
        case TCPaymentMethodWechat:
            self.paymentDetailView.methodLabel.text = @"微信支付";
            break;
        case TCPaymentMethodAlipay:
            self.paymentDetailView.methodLabel.text = @"支付宝支付";
            break;
            
        default:
            break;
    }
    
    [self dismissPaymentMethodView];
}

- (void)didClickBackButtonInPaymentMethodView:(TCPaymentMethodView *)view {
    [self dismissPaymentMethodView];
}

#pragma mark - Actions

/**
 点击了确认支付按钮
 */
- (void)handleClickConfirmButton {
    switch (self.currentPaymentMethod) {
        case TCPaymentMethodBalance:
            [self handlePaymentWithBalance];
            break;
        case TCPaymentMethodWechat:
            [self handlePaymentWithWechat];
            break;
        case TCPaymentMethodAlipay:
            [self handlePaymentWithAlipay];
            break;
            
        default:
            break;
    }
}

/**
 使用余额付款
 */
- (void)handlePaymentWithBalance {
    // 获取钱包信息
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchWalletAccountInfo:^(TCWalletAccount *walletAccount, NSError *error) {
        if (walletAccount) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.walletAccount = walletAccount;
            
            if (!walletAccount.password) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未设置支付密码，请到\n我的钱包>支付密码\n设置" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:action];
                [sourceController presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
            if (weakSelf.paymentAmount > walletAccount.balance) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的钱包余额不足，请充值" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf handleShowRechargeViewController];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:confirmAction];
                [alertController addAction:cancelAction];
                [sourceController presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
            [weakSelf showPaymentPasswordView];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"提交信息失败，%@", reason]];
        }
    }];
}

/**
 使用微信付款
 */
- (void)handlePaymentWithWechat {
    
}

/**
 使用余额宝付款
 */
- (void)handlePaymentWithAlipay {
    
}

/**
 显示余额充值页面
 */
- (void)handleShowRechargeViewController {
    TCRechargeViewController *vc = [[TCRechargeViewController alloc] init];
    vc.balance = self.walletAccount.balance;
    vc.suggestMoney = self.paymentAmount - self.walletAccount.balance;
    vc.completionBlock = ^() {
        
    };
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [sourceController presentViewController:nav animated:YES completion:nil];
}

/**
 提交付款申请
 */
- (void)handlePaymentWithPassword:(NSString *)password {
    if (![TCDigestMD5(password) isEqualToString:self.walletAccount.password]) {
        [MBProgressHUD showHUDWithMessage:@"付款失败，密码错误"];
        return;
    }
//    if (self.paymentAmount > self.walletAccount.balance) {
//        [MBProgressHUD showHUDWithMessage:@"付款失败，您的钱包余额不足"];
//        return;
//    }
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] commitPaymentWithPayChannel:TCPayChannelBalance payPurpose:TCPayPurposeOrder orderIDs:self.orderIDs result:^(TCUserPayment *userPayment, NSError *error) {
        if (userPayment) {
            if ([userPayment.status isEqualToString:@"CREATED"]) { // 正在处理中
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf handleQueryPaymentStatusWithPaymentID:userPayment.ID];
                });
            } else if ([userPayment.status isEqualToString:@"FAILURE"]) { // 错误（余额不足）
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"付款失败，%@", userPayment.note]];
            } else { // 付款成功
                [MBProgressHUD hideHUD:YES];
                [weakSelf dismiss:YES completion:^{
                    if ([weakSelf.delegate respondsToSelector:@selector(paymentView:didFinishedPaymentWithStatus:)]) {
                        [weakSelf.delegate paymentView:weakSelf didFinishedPaymentWithStatus:userPayment.status];
                    }
                }];
            }
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"付款失败，%@", reason]];
        }
    }];
}

/**
 查询付款状态
 */
- (void)handleQueryPaymentStatusWithPaymentID:(NSString *)paymentID {
    [[TCBuluoApi api] fetchUserPayment:paymentID result:^(TCUserPayment *userPayment, NSError *error) {
        if (userPayment) {
            if ([userPayment.status isEqualToString:@"FAILURE"]) {
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"付款失败，%@", userPayment.note]];
            } else {
                [MBProgressHUD hideHUD:YES];
                [weakSelf dismiss:YES completion:^{
                    if ([weakSelf.delegate respondsToSelector:@selector(paymentView:didFinishedPaymentWithStatus:)]) {
                        [weakSelf.delegate paymentView:weakSelf didFinishedPaymentWithStatus:userPayment.status];
                    }
                }];
            }
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"付款失败，%@", reason]];
        }
    }];
}

@end
