//
//  TCCompanyPaymentViewController.m
//  individual
//
//  Created by 穆康 on 2017/8/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCompanyPaymentViewController.h"
#import "TCNavigationController.h"
#import "TCCommonPaymentViewController.h"
#import "TCWalletPasswordViewController.h"

#import "TCPaymentDetailView.h"
#import "TCPaymentPasswordView.h"

#import "TCNotificationNames.h"

#import <TCCommonLibs/TCFunctions.h>

static CGFloat const subviewHeight = 400;
static CGFloat const duration = 0.25;

@interface TCCompanyPaymentViewController ()
<TCPaymentDetailViewDelegate,
TCPaymentPasswordViewDelegate
>

/** 显示的时候是否有动画 */
@property (nonatomic) BOOL showAnimated;

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) TCPaymentDetailView *paymentDetailView;
@property (weak, nonatomic) TCPaymentPasswordView *paymentPasswordView;

/** 钱包信息 */
@property (strong, nonatomic) TCWalletAccount *walletAccount;

@property (strong, nonatomic) TCUserPayment *payment;

@end

@implementation TCCompanyPaymentViewController {
    __weak TCCompanyPaymentViewController *weakSelf;
    __weak UIViewController *sourceController;
}

- (instancetype)initWithTotalFee:(double)totalFee payPurpose:(TCPayPurpose)payPurpose fromController:(UIViewController *)controller {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _totalFee = totalFee;
        _payPurpose = payPurpose;
        weakSelf = self;
        sourceController = controller;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"TCCompanyPaymentViewController初始化错误"
                                   reason:@"请使用接口文件提供的初始化方法"
                                 userInfo:nil];
    return nil;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = TCARGBColor(0, 0, 0, 0);
    
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.showAnimated) {
        [UIView animateWithDuration:duration animations:^{
            weakSelf.view.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
            weakSelf.containerView.y = TCScreenHeight - subviewHeight;
        }];
    } else {
        weakSelf.view.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
        weakSelf.containerView.y = TCScreenHeight - subviewHeight;
    }
}

- (void)dealloc {
    TCLog(@"%s", __func__);
}

#pragma mark - Public Methods

- (void)show:(BOOL)animated {
    self.showAnimated = animated;
    
    sourceController.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [sourceController presentViewController:self animated:NO completion:nil];
}

- (void)dismiss:(BOOL)animated completion:(void (^)())completion {
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            weakSelf.view.backgroundColor = TCARGBColor(0, 0, 0, 0);
            weakSelf.containerView.y = TCScreenHeight;
        } completion:^(BOOL finished) {
            [weakSelf dismissViewControllerAnimated:NO completion:^{
                if (completion) {
                    completion();
                }
            }];
        }];
    } else {
        self.view.backgroundColor = TCARGBColor(0, 0, 0, 0);
        self.containerView.y = TCScreenHeight;
        [weakSelf dismissViewControllerAnimated:NO completion:^{
            if (completion) {
                completion();
            }
        }];
    }
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UIView *containerView = [[UIView alloc] init];
    containerView.frame = CGRectMake(0, TCScreenHeight, TCScreenWidth, subviewHeight);
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    TCPaymentDetailView *paymentDetailView = [[NSBundle mainBundle] loadNibNamed:@"TCPaymentDetailView" owner:nil options:nil].lastObject;
    paymentDetailView.totalFee = self.totalFee;
    paymentDetailView.methodLabel.text = @"企业余额";
    paymentDetailView.arrowIcon.hidden = YES;
    paymentDetailView.delegate = self;
    paymentDetailView.frame = containerView.bounds;
    [containerView addSubview:paymentDetailView];
    self.paymentDetailView = paymentDetailView;
}

/**
 显示输入密码页
 */
- (void)showPaymentPasswordView {
    TCPaymentPasswordView *paymentPasswordView = [[NSBundle mainBundle] loadNibNamed:@"TCPaymentPasswordView" owner:nil options:nil].lastObject;
    paymentPasswordView.frame = CGRectMake(self.containerView.width, 0, self.containerView.width, self.containerView.height);
    paymentPasswordView.delegate = self;
    paymentPasswordView.textField.centerX = paymentPasswordView.width / 2;
    [self.containerView addSubview:paymentPasswordView];
    self.paymentPasswordView = paymentPasswordView;
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.paymentDetailView.x = - weakSelf.containerView.width;
        weakSelf.paymentPasswordView.x = 0;
    } completion:^(BOOL finished) {
        [weakSelf.paymentPasswordView.textField becomeFirstResponder];
    }];
}

/**
 退出输入密码页
 */
- (void)dismissPaymentPasswordView {
    [self.paymentPasswordView.textField resignFirstResponder];
    [UIView animateWithDuration:duration animations:^{
        weakSelf.paymentDetailView.x = 0;
        weakSelf.paymentPasswordView.x = weakSelf.containerView.width;
    } completion:^(BOOL finished) {
        [weakSelf.paymentPasswordView removeFromSuperview];
    }];
}

/**
 显示余额充值页面
 */
- (void)showRechargeViewController {
    double balance = [self.walletAccount.creditStatus isEqualToString:@"NORMAL"] ? (self.walletAccount.balance + self.walletAccount.creditLimit - self.walletAccount.creditBalance) : self.walletAccount.balance;
    TCCommonPaymentViewController *vc = [[TCCommonPaymentViewController alloc] initWithPaymentPurpose:TCCommonPaymentPurposeCompanyRecharge];
    vc.walletAccount = self.walletAccount;
    vc.suggestAmount = self.totalFee - balance;
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 显示设置支付密码页面
 */
- (void)showPasswordViewController {
    TCWalletPasswordViewController *vc = [[TCWalletPasswordViewController alloc] initWithPasswordType:TCWalletPasswordTypeFirstTimeInputPassword];
    vc.walletID = self.companyID;
    vc.modalMode = YES;
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - TCPaymentDetailViewDelegate

- (void)didClickConfirmButtonInPaymentDetailView:(TCPaymentDetailView *)view {
    [self handleClickConfirmButton];
}

- (void)didClickCloseButtonInPaymentDetailView:(TCPaymentDetailView *)view {
    [self dismiss:YES completion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickCloseButtonInCompanyPaymentViewController:)]) {
            [weakSelf.delegate didClickCloseButtonInCompanyPaymentViewController:weakSelf];
        }
    }];
}

- (void)didClickQueryButtonInPaymentDetailView:(TCPaymentDetailView *)view {
    TCLog(@"点击了疑问按钮");
}

- (void)didTapChangePaymentMethodViewInPaymentDetailView:(TCPaymentDetailView *)view {
    
}

#pragma mark - TCPaymentPasswordViewDelegate

- (void)paymentPasswordView:(TCPaymentPasswordView *)view didFilledPassword:(NSString *)password {
    [self handlePaymentWithPassword:password];
}

- (void)didClickBackButtonInPaymentPasswordView:(TCPaymentPasswordView *)view {
    [self dismissPaymentPasswordView];
}

#pragma mark - Actions

/**
 点击了确认支付按钮
 */
- (void)handleClickConfirmButton {
    [self handlePaymentWithBalance];
}

/**
 付款成功
 */
- (void)handlePaymentSucceedWithPayment:(TCUserPayment *)payment {
    [MBProgressHUD hideHUD:YES];
    
    // 发送首页需要刷新数据的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:TCNotificationHomePageNeedRefreshData object:self];
    
    if ([self.paymentPasswordView.textField isFirstResponder]) {
        [self.paymentPasswordView.textField resignFirstResponder];
    }
    [self dismiss:YES completion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(companyPaymentViewController:didFinishedPaymentWithPayment:)]) {
            [weakSelf.delegate companyPaymentViewController:weakSelf didFinishedPaymentWithPayment:payment];
        }
    }];
}

#pragma mark - 余额支付

/**
 使用余额付款
 */
- (void)handlePaymentWithBalance {
    // 获取钱包信息
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchCompanyWalletAccountInfoByCompanyID:self.companyID result:^(TCWalletAccount *walletAccount, NSError *error) {
        if (walletAccount) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.walletAccount = walletAccount;
            
            if (!walletAccount.password) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未设置企业支付密码\n请先设置支付密码，再进行付款" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf showPasswordViewController];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:confirmAction];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
            double balance = [walletAccount.creditStatus isEqualToString:@"NORMAL"] ? (walletAccount.balance + walletAccount.creditLimit - walletAccount.creditBalance) : walletAccount.balance;
            if (weakSelf.totalFee > balance) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的企业钱包余额不足，请充值" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf showRechargeViewController];
                }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alertController addAction:confirmAction];
                [alertController addAction:cancelAction];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
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
 提交付款申请
 */
- (void)handlePaymentWithPassword:(NSString *)password {
    if (![TCDigestMD5(password) isEqualToString:self.walletAccount.password]) {
        [MBProgressHUD showHUDWithMessage:@"付款失败，密码错误"];
        return;
    }
    
    [MBProgressHUD showHUD:YES];
    TCPaymentRequestInfo *requestInfo = [[TCPaymentRequestInfo alloc] init];
    requestInfo.password = password;
    requestInfo.payChannel = TCPayChannelBalance;
    requestInfo.totalFee = self.totalFee;
    requestInfo.targetId = self.targetID;
    [[TCBuluoApi api] commitPaymentRequest:requestInfo payPurpose:self.payPurpose walletID:self.companyID result:^(TCUserPayment *userPayment, NSError *error) {
        if (userPayment) {
            if ([userPayment.status isEqualToString:@"CREATED"]) { // 正在处理中
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf handleQueryPaymentStatusWithPaymentID:userPayment.ID];
                });
            } else if ([userPayment.status isEqualToString:@"FAILURE"]) { // 错误（余额不足）
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"付款失败，%@", userPayment.note]];
            } else { // 付款成功
                [weakSelf handlePaymentSucceedWithPayment:userPayment];
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
    [[TCBuluoApi api] fetchUserPaymentByWalletID:self.walletAccount.ID paymentID:paymentID result:^(TCUserPayment *userPayment, NSError *error) {
        if (userPayment) {
            if ([userPayment.status isEqualToString:@"FAILURE"]) {
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"付款失败，%@", userPayment.note]];
            } else {
                [weakSelf handlePaymentSucceedWithPayment:userPayment];
            }
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"付款失败，%@", reason]];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
