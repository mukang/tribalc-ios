//
//  TCPaymentViewController.m
//  individual
//
//  Created by 穆康 on 2017/6/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPaymentViewController.h"
#import "TCNavigationController.h"
#import "TCCommonPaymentViewController.h"
#import "TCWalletPasswordViewController.h"

#import "TCPaymentDetailView.h"
#import "TCPaymentPasswordView.h"
#import "TCPaymentBankCardView.h"
#import "TCPaymentMethodsSelectView.h"

#import "TCNotificationNames.h"
#import "TCPaymentMethodModel.h"
#import "WXApiManager.h"

#import <TCCommonLibs/TCFunctions.h>
#import <BaofuFuFingerSDK/BaofuFuFingerClient.h>
#import <WechatOpenSDK/WXApi.h>

static CGFloat const subviewHeight = 400;
static CGFloat const duration = 0.25;

@interface TCPaymentViewController ()
<TCPaymentDetailViewDelegate,
TCPaymentPasswordViewDelegate,
TCPaymentMethodsSelectViewDelegate,
TCPaymentBankCardViewDelegate,
BaofuFuFingerClientDelegate,
WXApiManagerDelegate
>

/** 显示的时候是否有动画 */
@property (nonatomic) BOOL showAnimated;

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) TCPaymentDetailView *paymentDetailView;
@property (weak, nonatomic) TCPaymentPasswordView *paymentPasswordView;
@property (weak, nonatomic) TCPaymentBankCardView *bankCardView;
@property (weak, nonatomic) TCPaymentMethodsSelectView *methodsSelectView;

/** 钱包信息 */
@property (strong, nonatomic) TCWalletAccount *walletAccount;
/** 银行卡logo及背景图数据 */
@property (copy, nonatomic) NSArray *bankInfoList;

@property (strong, nonatomic) TCPaymentMethodModel *currentMethodModel;


@property (strong, nonatomic) TCUserPayment *payment;
/** 微信预支付id */
@property (copy, nonatomic) NSString *wechatPrepayID;
/** 宝付支付ID */
@property (copy, nonatomic) NSString *bfPayID;

@property (strong, nonatomic) TCBFSessionInfo *bfSessionInfo;
/** 是否是重新获取验证码 */
@property (nonatomic, getter=isRefetchVCode) BOOL refetchVCode;

@property (copy, nonatomic) NSString *walletID;

/** 余额支付正在进行中 */
@property (nonatomic, getter=isUnderWay) BOOL underWay;

@end

@implementation TCPaymentViewController {
    __weak TCPaymentViewController *weakSelf;
    __weak UIViewController *sourceController;
}

- (instancetype)initWithTotalFee:(double)totalFee payPurpose:(TCPayPurpose)payPurpose fromController:(UIViewController *)controller {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _totalFee = totalFee;
        _payPurpose = payPurpose;
        _underWay = NO;
        weakSelf = self;
        sourceController = controller;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"TCPaymentViewController初始化错误"
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
    [self setupCurrentMethodModel];
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
    paymentDetailView.totalFee = self.displayedFee ?: self.totalFee;
    paymentDetailView.methodLabel.text = @"余额支付";
    paymentDetailView.delegate = self;
    paymentDetailView.frame = containerView.bounds;
    [containerView addSubview:paymentDetailView];
    self.paymentDetailView = paymentDetailView;
}

- (void)setupCurrentMethodModel {
    TCPaymentMethodModel *model = [[TCPaymentMethodModel alloc] init];
    model.paymentMethod = TCPaymentMethodBalance;
    model.selected = YES;
    model.singleRow = YES;
    self.currentMethodModel = model;
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
 显示银行卡付款页
 */
- (void)showBankCardView {
    TCPaymentBankCardView *bankCardView = [[TCPaymentBankCardView alloc] initWithBankCard:self.currentMethodModel.bankCard];
    bankCardView.frame = CGRectMake(self.containerView.width, 0, self.containerView.width, self.containerView.height);
    bankCardView.delegate = self;
    [self.containerView addSubview:bankCardView];
    weakSelf.bankCardView = bankCardView;
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.paymentDetailView.x = - weakSelf.containerView.width;
        weakSelf.bankCardView.x = 0;
    } completion:^(BOOL finished) {
        [weakSelf.bankCardView.codeTextField becomeFirstResponder];
    }];
}

/**
 退出银行卡付款页
 */
- (void)dismissBankCardView {
    [UIView animateWithDuration:duration animations:^{
        weakSelf.paymentDetailView.x = 0;
        weakSelf.bankCardView.x = weakSelf.containerView.width;
    } completion:^(BOOL finished) {
        [weakSelf.bankCardView removeFromSuperview];
    }];
}

/**
 显示选择支付方式页
 */
- (void)showPaymentMethodsSelectViewWithMethodModels:(NSArray *)methodModels {
    TCPaymentMethodsSelectView *methodsSelectView = [[TCPaymentMethodsSelectView alloc] initWithPaymentMethodModels:methodModels backButtonStyle:TCBackButtonStyleLeftArrow];
    methodsSelectView.hideAddBankCardItem = YES;
    methodsSelectView.frame = CGRectMake(self.containerView.width, 0, self.containerView.width, self.containerView.height);
    methodsSelectView.delegate = self;
    [self.containerView addSubview:methodsSelectView];
    self.methodsSelectView = methodsSelectView;
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.paymentDetailView.x = - weakSelf.containerView.width;
        weakSelf.methodsSelectView.x = 0;
    }];
}

/**
 退出选择支付方式页
 */
- (void)dismissPaymentMethodsSelectView {
    [UIView animateWithDuration:duration animations:^{
        weakSelf.paymentDetailView.x = 0;
        weakSelf.methodsSelectView.x = weakSelf.containerView.width;
    } completion:^(BOOL finished) {
        [weakSelf.methodsSelectView removeFromSuperview];
    }];
}

/**
 显示余额充值页面
 */
- (void)showRechargeViewController {
    double fee = self.displayedFee ?: self.totalFee;
    double balance = [self.walletAccount.creditStatus isEqualToString:@"NORMAL"] ? (self.walletAccount.balance + self.walletAccount.creditLimit - self.walletAccount.creditBalance) : self.walletAccount.balance;
    TCCommonPaymentViewController *vc = [[TCCommonPaymentViewController alloc] initWithPaymentPurpose:TCCommonPaymentPurposeRecharge];
    vc.walletAccount = self.walletAccount;
    vc.suggestAmount = fee - balance;
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 显示设置支付密码页面
 */
- (void)showPasswordViewController {
    TCWalletPasswordViewController *vc = [[TCWalletPasswordViewController alloc] initWithPasswordType:TCWalletPasswordTypeFirstTimeInputPassword];
    vc.walletID = self.walletAccount.ID;
    vc.modalMode = YES;
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 创建模型数据源

- (NSArray *)createPaymentMethodModelsWithBankCardList:(NSArray *)bankCardList {
    NSMutableArray *models = [NSMutableArray array];
    
    // 余额支付
    TCPaymentMethodModel *model = [[TCPaymentMethodModel alloc] init];
    model.paymentMethod = TCPaymentMethodBalance;
    model.singleRow = YES;
    if (model.paymentMethod == self.currentMethodModel.paymentMethod) {
        model.selected = YES;
    }
    [models addObject:model];
    
    // 微信支付
    if ([WXApi isWXAppInstalled]) {
        TCPaymentMethodModel *model = [[TCPaymentMethodModel alloc] init];
        model.paymentMethod = TCPaymentMethodWechat;
        model.singleRow = YES;
        if (model.paymentMethod == self.currentMethodModel.paymentMethod) {
            model.selected = YES;
        }
        [models addObject:model];
    }
    
    // 银行卡支付
    for (int i=0; i<bankCardList.count; i++) {
        TCBankCard *bankCard = bankCardList[i];
        bankCard.logo = @"bank_logo_Default";
        for (NSDictionary *bankInfo in self.bankInfoList) {
            if ([bankInfo[@"code"] isEqualToString:bankCard.bankCode]) {
                bankCard.logo = bankInfo[@"logo"];
                break;
            }
        }
        
        TCPaymentMethodModel *model = [[TCPaymentMethodModel alloc] init];
        model.paymentMethod = TCPaymentMethodBankCard;
        model.bankCard = bankCard;
        if (model.paymentMethod == self.currentMethodModel.paymentMethod && [bankCard.ID isEqualToString:self.currentMethodModel.bankCard.ID]) {
            model.selected = YES;
        }
        model.invalid = (bankCard.type == TCBankCardTypeWithdraw);
        [models addObject:model];
    }
    
    return [models copy];
}

#pragma mark - TCPaymentDetailViewDelegate

- (void)didClickConfirmButtonInPaymentDetailView:(TCPaymentDetailView *)view {
    [self handleClickConfirmButton];
}

- (void)didClickCloseButtonInPaymentDetailView:(TCPaymentDetailView *)view {
    [self dismiss:YES completion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(didClickCloseButtonInPaymentViewController:)]) {
            [weakSelf.delegate didClickCloseButtonInPaymentViewController:weakSelf];
        }
    }];
}

- (void)didClickQueryButtonInPaymentDetailView:(TCPaymentDetailView *)view {
    TCLog(@"点击了疑问按钮");
}

- (void)didTapChangePaymentMethodViewInPaymentDetailView:(TCPaymentDetailView *)view {
    [self handleTapChangePaymentMethodView];
}

#pragma mark - TCPaymentPasswordViewDelegate

- (void)paymentPasswordView:(TCPaymentPasswordView *)view didFilledPassword:(NSString *)password {
    [self handlePaymentWithPassword:password];
}

- (void)didClickBackButtonInPaymentPasswordView:(TCPaymentPasswordView *)view {
    [self dismissPaymentPasswordView];
}

#pragma mark - TCPaymentBankCardViewDelegate

- (void)didClickBackButtonInBankCardView:(TCPaymentBankCardView *)view {
    [self dismissBankCardView];
}

- (void)didClickFetchCodeButtonInBankCardView:(TCPaymentBankCardView *)view {
    [self fetchBFSessionInfoWithPaymentID:weakSelf.payment.ID refetchVCode:YES];
}

- (void)bankCardView:(TCPaymentBankCardView *)view didClickConfirmButtonWithCode:(NSString *)code {
    [self confirmBFPayWithVCode:code];
}

#pragma mark - TCPaymentMethodsSelectViewDelegate

- (void)paymentMethodsSelectView:(TCPaymentMethodsSelectView *)view didSlectedMethod:(TCPaymentMethodModel *)methodModel {
    self.currentMethodModel = methodModel;
    
    switch (methodModel.paymentMethod) {
        case TCPaymentMethodBalance:
            self.paymentDetailView.methodLabel.text = @"余额支付";
            break;
        case TCPaymentMethodWechat:
            self.paymentDetailView.methodLabel.text = @"微信支付";
            break;
        case TCPaymentMethodBankCard:
        {
            TCBankCard *bankCard = methodModel.bankCard;
            NSString *bankCardNum = bankCard.bankCardNum;
            NSString *lastNum;
            if (bankCardNum.length >= 4) {
                lastNum = [bankCardNum substringFromIndex:(bankCardNum.length - 4)];
            }
            self.paymentDetailView.methodLabel.text = [NSString stringWithFormat:@"%@储蓄卡(%@)", bankCard.bankName, lastNum];
        }
            break;
            
        default:
            break;
    }
    
    [self dismissPaymentMethodsSelectView];
}

- (void)didClickBackButtonInPaymentMethodsSelectView:(TCPaymentMethodsSelectView *)view {
    [self dismissPaymentMethodsSelectView];
}

#pragma mark - BaofuFuFingerClientDelegate

-(void)initialSucess {
    [self prepareBFPay];
}

-(void)initialfailed:(NSString*)errorMessage {
    [weakSelf showErrorMessageHUD:errorMessage];
}

#pragma mark - WXApiManagerDelegate

- (void)managerDidRecvPayResponse:(PayResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            [self checkWechatPaymentResult];
            break;
            
        default:
            [MBProgressHUD showHUDWithMessage:@"充值失败"];
            break;
    }
}

#pragma mark - Actions

/**
 点击了确认支付按钮
 */
- (void)handleClickConfirmButton {
    switch (self.currentMethodModel.paymentMethod) {
        case TCPaymentMethodBalance:
            [self handlePaymentWithBalance];
            break;
        case TCPaymentMethodWechat:
            [self handlePaymentWithWechat];
            break;
        case TCPaymentMethodBankCard:
            [self handlePaymentWithBankCard];
            break;
//        case TCPaymentMethodAlipay:
//            [self handlePaymentWithAlipay];
//            break;
            
        default:
            break;
    }
}

/**
 点击了更换支付方式
 */
- (void)handleTapChangePaymentMethodView {
    // 获取银行卡列表
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchBankCardList:^(NSArray *bankCardList, NSError *error) {
        if (error) {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取支付方式失败，%@", reason]];
        } else {
            [MBProgressHUD hideHUD:YES];
            NSArray *methodModels = [weakSelf createPaymentMethodModelsWithBankCardList:bankCardList];
            [weakSelf showPaymentMethodsSelectViewWithMethodModels:methodModels];
        }
    }];
}

/**
 使用微信付款
 */
- (void)handlePaymentWithWechat {
    [self commitWechatPaymentRequest];
}

/**
 使用余额宝付款
 */
- (void)handlePaymentWithAlipay {
    
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
    if ([self.bankCardView.codeTextField isFirstResponder]) {
        [self.bankCardView.codeTextField resignFirstResponder];
    }
    [self dismiss:YES completion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(paymentViewController:didFinishedPaymentWithPayment:)]) {
            TCUserPayment *userPayment = payment ?: weakSelf.payment;
            [weakSelf.delegate paymentViewController:weakSelf didFinishedPaymentWithPayment:userPayment];
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
    [[TCBuluoApi api] fetchWalletAccountInfo:^(TCWalletAccount *walletAccount, NSError *error) {
        if (walletAccount) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.walletAccount = walletAccount;
            weakSelf.walletID = walletAccount.ID;
            
            if (!walletAccount.password) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未设置支付密码\n请先设置支付密码，再进行付款" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf showPasswordViewController];
                }];
                [alertController addAction:cancelAction];
                [alertController addAction:confirmAction];
                [weakSelf presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
            double fee = weakSelf.displayedFee ?: weakSelf.totalFee;
            double balance = [walletAccount.creditStatus isEqualToString:@"NORMAL"] ? (walletAccount.balance + walletAccount.creditLimit - walletAccount.creditBalance) : walletAccount.balance;
            if (fee > balance) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的钱包余额不足，请充值" preferredStyle:UIAlertControllerStyleAlert];
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
    if (self.isUnderWay) {
        return;
    }
    self.underWay = YES;
    
    [MBProgressHUD showHUD:YES];
    TCPaymentRequestInfo *requestInfo = [[TCPaymentRequestInfo alloc] init];
    requestInfo.password = password;
    requestInfo.payChannel = TCPayChannelBalance;
    requestInfo.orderIds = self.orderIDs;
    requestInfo.totalFee = self.totalFee;
    requestInfo.targetId = self.targetID;
    [[TCBuluoApi api] commitPaymentRequest:requestInfo payPurpose:self.payPurpose walletID:self.walletAccount.ID result:^(TCUserPayment *userPayment, NSError *error) {
        if (userPayment) {
            if ([userPayment.status isEqualToString:@"CREATED"]) { // 正在处理中
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf handleQueryPaymentStatusWithPaymentID:userPayment.ID];
                });
            } else if ([userPayment.status isEqualToString:@"FAILURE"]) { // 错误（余额不足）
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"付款失败，%@", userPayment.note]];
                weakSelf.underWay = NO;
            } else { // 付款成功
                [weakSelf handlePaymentSucceedWithPayment:userPayment];
                weakSelf.underWay = NO;
            }
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            if (error.code == 412 && weakSelf.payPurpose == TCPayPurposeFace2Face) { // 当时面对面付款申请时，错误码412表示平台向商户充值的会员卡余额不足
                [MBProgressHUD hideHUD:YES];
                [weakSelf showLackOfBalanceWithMessage:reason];
            } else {
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"付款失败，%@", reason]];
            }
            weakSelf.underWay = NO;
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
        weakSelf.underWay = NO;
    }];
}

#pragma mark - 宝付银行卡支付

/**
 使用宝付付款
 */
- (void)handlePaymentWithBankCard {
    if (self.payment) {
        [MBProgressHUD showHUD:YES];
        [self fetchBFSessionInfoWithPaymentID:self.payment.ID refetchVCode:NO];
    } else {
        [self commitBFPayRequest];
    }
}

/**
 提交付款申请
 */
- (void)commitBFPayRequest {
    [MBProgressHUD showHUD:YES];
    TCPaymentRequestInfo *requestInfo = [[TCPaymentRequestInfo alloc] init];
    requestInfo.payChannel = TCPayChannelBankCard;
    requestInfo.targetId = self.targetID;
    requestInfo.totalFee = self.totalFee;
    requestInfo.orderIds = self.orderIDs;
    [[TCBuluoApi api] commitPaymentRequest:requestInfo payPurpose:self.payPurpose walletID:self.walletID result:^(TCUserPayment *userPayment, NSError *error) {
        if (userPayment) {
            weakSelf.payment = userPayment;
            [weakSelf fetchBFSessionInfoWithPaymentID:userPayment.ID refetchVCode:NO];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            if (error.code == 412 && weakSelf.payPurpose == TCPayPurposeFace2Face) { // 当时面对面付款申请时，错误码412表示平台向商户充值的会员卡余额不足
                [MBProgressHUD hideHUD:YES];
                [weakSelf showLackOfBalanceWithMessage:reason];
            } else {
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"申请付款失败，%@", reason]];
            }
        }
    }];
}

/**
 宝付获取SESSION_ID
 */
- (void)fetchBFSessionInfoWithPaymentID:(NSString *)paymentID refetchVCode:(BOOL)isRefetchVCode {
    self.refetchVCode = isRefetchVCode;
    if (isRefetchVCode) {
        [MBProgressHUD showHUD:YES];
    }
    [[TCBuluoApi api] fetchBFSessionInfoWithPaymentID:paymentID result:^(TCBFSessionInfo *sessionInfo, NSError *error) {
        if (sessionInfo) {
            weakSelf.bfSessionInfo = sessionInfo;
            [weakSelf fetchBFFingerWithSessionID:sessionInfo.sessionId];
        } else {
            [weakSelf showErrorMessageHUD:error.localizedDescription];
        }
    }];
}

/**
 宝付获取设备指纹
 */
- (void)fetchBFFingerWithSessionID:(NSString *)sessionID {
    BaofuFuFingerClient *client = [[BaofuFuFingerClient alloc] initWithSessionId:sessionID andoperationalState:operational_true];
    client.delegate = self;
}

/**
 宝付预支付
 */
- (void)prepareBFPay {
    TCBFPayInfo *payInfo = [[TCBFPayInfo alloc] init];
    payInfo.bankCardId = self.currentMethodModel.bankCard.ID;
    payInfo.totalFee = self.totalFee;
    payInfo.paymentId = self.bfSessionInfo.paymentId;
    [[TCBuluoApi api] prepareBFPayWithInfo:payInfo result:^(NSString *payID, NSError *error) {
        if (payID) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.bfPayID = payID;
            if (weakSelf.isRefetchVCode) {
                [weakSelf.bankCardView startCountDown];
            } else {
                [weakSelf showBankCardView];
            }
        } else {
            [weakSelf showErrorMessageHUD:error.localizedDescription];
        }
    }];
}

/**
 宝付确认支付
 */
- (void)confirmBFPayWithVCode:(NSString *)vCode {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] confirmBFPayWithPayID:self.bfPayID vCode:vCode result:^(TCBFPayResult payResult, NSError *error) {
        if (payResult == TCBFPayResultSucceed) {
            [weakSelf handlePaymentSucceedWithPayment:nil];
        } else if (payResult == TCBFPayResultProcessing) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf queryBFPayWithVCode:vCode];
            });
        } else {
            [weakSelf.bankCardView stopCountDown];
            NSString *reason = nil;
            if (error.localizedDescription) {
                reason = [NSString stringWithFormat:@"%@，请重新获取验证码", error.localizedDescription];
            } else {
                reason = @"请重新获取验证码";
            }
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"支付失败，%@", reason]];
        }
    }];
}

/**
 宝付查询充值
 */
- (void)queryBFPayWithVCode:(NSString *)vCode {
    [[TCBuluoApi api] queryBFPayWithPayID:self.bfPayID result:^(TCBFPayResult payResult, NSError *error) {
        if (payResult == TCBFPayResultSucceed) {
            [weakSelf handlePaymentSucceedWithPayment:nil];
        } else if (payResult == TCBFPayResultProcessing) {
            [MBProgressHUD showHUDWithMessage:@"支付处理中，请稍后查询"];
        } else {
            weakSelf.bankCardView.codeTextField.text = @"";
            [weakSelf.bankCardView stopCountDown];
            NSString *reason = nil;
            if (error.localizedDescription) {
                reason = [NSString stringWithFormat:@"%@，请重新获取验证码", error.localizedDescription];
            } else {
                reason = @"请重新获取验证码";
            }
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"支付失败，%@", reason]];
        }
    }];
}

/**
 显示错误HUD
 */
- (void)showErrorMessageHUD:(NSString *)errorMessage {
    NSString *result = self.isRefetchVCode ? @"获取验证码失败" : @"申请付款失败";
    NSString *reason = errorMessage ?: @"请稍后再试";
    [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"%@，%@", result ,reason]];
}

#pragma mark - 微信支付

- (void)commitWechatPaymentRequest {
    [MBProgressHUD showHUD:YES];
    TCPaymentRequestInfo *requestInfo = [[TCPaymentRequestInfo alloc] init];
    requestInfo.payChannel = TCPayChannelWechat;
    requestInfo.targetId = self.targetID;
    requestInfo.totalFee = self.totalFee;
    requestInfo.orderIds = self.orderIDs;
    [[TCBuluoApi api] commitPaymentRequest:requestInfo payPurpose:self.payPurpose walletID:self.walletID result:^(TCUserPayment *userPayment, NSError *error) {
        if (userPayment) {
            [weakSelf fetchWechatPaymentInfoWithPaymentID:userPayment.ID];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            if (error.code == 412 && weakSelf.payPurpose == TCPayPurposeFace2Face) { // 当时面对面付款申请时，错误码412表示平台向商户充值的会员卡余额不足
                [MBProgressHUD hideHUD:YES];
                [weakSelf showLackOfBalanceWithMessage:reason];
            } else {
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"申请付款失败，%@", reason]];
            }
        }
    }];
}

- (void)fetchWechatPaymentInfoWithPaymentID:(NSString *)paymentID {
    TCWechatPaymentRequestInfo *requestInfo = [[TCWechatPaymentRequestInfo alloc] init];
    requestInfo.totalFee = self.totalFee;
    requestInfo.paymentId = paymentID;
    requestInfo.targetId = self.targetID;
    [[TCBuluoApi api] fetchWechatPaymentInfo:requestInfo result:^(TCWechatPaymentInfo *wechatPaymentInfo, NSError *error) {
        if (wechatPaymentInfo) {
            [MBProgressHUD hideHUD:YES];
            [weakSelf handleArouseWechatPayment:wechatPaymentInfo];
        } else {
            NSString *message = error.localizedDescription ?: @"申请付款失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
        }
    }];
}

/**
 调起微信支付
 */
 - (void)handleArouseWechatPayment:(TCWechatPaymentInfo *)paymentInfo {
     [WXApiManager sharedManager].delegate = self;
     self.wechatPrepayID = paymentInfo.prepayid;
     PayReq *req = [[PayReq alloc] init];
     req.partnerId = paymentInfo.partnerid;
     req.prepayId = paymentInfo.prepayid;
     req.nonceStr = paymentInfo.noncestr;
     req.timeStamp = [paymentInfo.timestamp intValue];
     req.package = paymentInfo.packageValue;
     req.sign = paymentInfo.sign;
     [WXApi sendReq:req];
 }


/**
 查询微信支付结果
 */
 - (void)checkWechatPaymentResult {
     [MBProgressHUD showHUD:YES];
     [[TCBuluoApi api] fetchWechatPaymentResultWithPrepayID:self.wechatPrepayID result:^(BOOL success, NSError *error) {
         if (success) {
             [weakSelf handlePaymentSucceedWithPayment:nil];
         } else {
             NSString *message = error.localizedDescription ?: @"付款失败，请稍后再试";
             [MBProgressHUD showHUDWithMessage:message];
         }
     }];
 }


#pragma mark - 展示平台向商户充值的会员卡余额不足错误信息

/**
 当时面对面付款申请时，错误码412表示平台向商户充值的会员卡余额不足
 */
- (void)showLackOfBalanceWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                             message:@"今日优惠买单金额已达上限，暂不可用优惠买单进行支付！"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([weakSelf.paymentPasswordView.textField isFirstResponder]) {
            [weakSelf.paymentPasswordView.textField resignFirstResponder];
        }
        if ([weakSelf.bankCardView.codeTextField isFirstResponder]) {
            [weakSelf.bankCardView.codeTextField resignFirstResponder];
        }
        [weakSelf dismiss:YES completion:nil];
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Override Methods

- (NSArray *)bankInfoList {
    if (_bankInfoList == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TCBankInfoList" ofType:@"plist"];
        _bankInfoList = [NSArray arrayWithContentsOfFile:path];
    }
    return _bankInfoList;
}

- (NSString *)walletID {
    if (_walletID == nil) {
        // 钱包id和用户id一样
        _walletID = [[TCBuluoApi api] currentUserSession].assigned;
    }
    return _walletID;
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
