//
//  TCCommonPaymentViewController.m
//  individual
//
//  Created by 穆康 on 2017/9/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommonPaymentViewController.h"
#import "TCNavigationController.h"
#import "TCWalletPasswordViewController.h"
#import "TCBankCardAddViewController.h"

#import "TCCommonPaymentMethodView.h"
#import "TCCommonPaymentInputView.h"
#import "TCPaymentMethodsSelectView.h"
#import "TCPaymentPasswordView.h"
#import "TCPaymentBankCardView.h"

#import "TCBuluoApi.h"
#import "TCPaymentMethodModel.h"
#import "WXApiManager.h"
#import "TCNotificationNames.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <TCCommonLibs/TCFunctions.h>
#import <WechatOpenSDK/WXApi.h>
#import <BaofuFuFingerSDK/BaofuFuFingerSDK.h>

static CGFloat const subviewHeight = 400;
static CGFloat const duration = 0.25;

@interface TCCommonPaymentViewController () <UITextFieldDelegate, TCPaymentMethodsSelectViewDelegate, TCPaymentPasswordViewDelegate, WXApiManagerDelegate, TCPaymentBankCardViewDelegate, BaofuFuFingerClientDelegate>

@property (weak, nonatomic) TCCommonPaymentMethodView *methodView;
@property (weak, nonatomic) TCCommonPaymentInputView *inputView;
@property (weak, nonatomic) TCCommonButton *nextButton;
@property (weak, nonatomic) TCPaymentMethodsSelectView *methodsSelectView;
@property (weak, nonatomic) TCPaymentPasswordView *passwordView;
@property (weak, nonatomic) TCPaymentBankCardView *paymentBankCardView;
@property (weak, nonatomic) UIView *bgView;

/** 金额 */
@property (nonatomic) double totalFee;
/** 用户申请的付款信息 */
@property (strong, nonatomic) TCUserPayment *userPayment;
/** 微信预支付id */
@property (copy, nonatomic) NSString *wechatPrepayID;
/** 宝付支付ID */
@property (copy, nonatomic) NSString *payID;
@property (strong, nonatomic) TCBFSessionInfo *bfSessionInfo;
/** 是否是重新获取验证码 */
@property (nonatomic, getter=isRefetchVCode) BOOL refetchVCode;

/** 输入框里是否含有小数点 */
@property (nonatomic, getter=isHavePoint) BOOL havePoint;

/** 银行卡logo及背景图数据 */
@property (copy, nonatomic) NSArray *bankInfoList;
@property (strong, nonatomic) TCPaymentMethodModel *currentMethodModel;


@end

@implementation TCCommonPaymentViewController {
    __weak TCCommonPaymentViewController *weakSelf;
}

- (instancetype)initWithPaymentPurpose:(TCCommonPaymentPurpose)paymentPurpose {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _paymentPurpose = paymentPurpose;
        weakSelf = self;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"TCCommonPaymentViewController初始化错误"
                                   reason:@"请使用接口文件提供的初始化方法"
                                 userInfo:nil];
    return nil;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TCBackgroundColor;
    
    [self setupNavBar];
    [self setupSubviews];
    [self setupConstraints];
    [self setupCurrentMethodModelAndUI];
    [self registerPasswordChangeNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
}

- (void)dealloc {
    [self removePasswordChangeNotifications];
}

#pragma mark - Setup UI

- (void)setupNavBar {
    NSString *title = nil;
    switch (self.paymentPurpose) {
        case TCCommonPaymentPurposeRecharge:
            title = @"余额充值";
            break;
        case TCCommonPaymentPurposeRepayment:
            title = @"授信还款";
            break;
        case TCCommonPaymentPurposeCompanyRecharge:
            title = @"企业余额充值";
            break;
        case TCCommonPaymentPurposeCompanyRepayment:
            title = @"企业还款";
            break;
            
        default:
            break;
    }
    self.navigationItem.title = title;
}

- (void)setupSubviews {
    TCCommonPaymentMethodView *methodView = [[TCCommonPaymentMethodView alloc] initWithPaymentPurpose:self.paymentPurpose];
    [self.view addSubview:methodView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapMethodView)];
    [methodView addGestureRecognizer:tap];
    
    TCCommonPaymentInputView *inputView = [[TCCommonPaymentInputView alloc] initWithPaymentPurpose:self.paymentPurpose];
    inputView.textField.delegate = self;
    [inputView.textField becomeFirstResponder];
    [self.view addSubview:inputView];
    
    TCCommonButton *nextButton = [TCCommonButton buttonWithTitle:@"下一步" color:TCCommonButtonColorPurple target:self action:@selector(handleClickNextButton)];
    [nextButton setBackgroundImage:[UIImage imageWithColor:TCRGBColor(217, 217, 217)] forState:UIControlStateDisabled];
    nextButton.enabled = NO;
    [self.view addSubview:nextButton];
    
    self.methodView = methodView;
    self.inputView = inputView;
    self.nextButton = nextButton;
}

- (void)setupConstraints {
    [self.methodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(61.5);
        make.top.equalTo(self.view).offset(10);
        make.left.right.equalTo(self.view);
    }];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(119);
        make.top.equalTo(self.methodView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(315), 40));
        make.top.equalTo(self.inputView.mas_bottom).offset(27);
        make.centerX.equalTo(self.view);
    }];
}

- (void)setupCurrentMethodModelAndUI {
    if (self.paymentPurpose == TCCommonPaymentPurposeRepayment || self.paymentPurpose == TCCommonPaymentPurposeCompanyRepayment) {
        TCPaymentMethodModel *model = [[TCPaymentMethodModel alloc] init];
        model.paymentMethod = TCPaymentMethodBalance;
        model.selected = YES;
        model.prompt = [NSString stringWithFormat:@"可用余额%0.2f元", self.walletAccount.balance];
        self.currentMethodModel = model;
        self.methodView.methodModel = model;
        self.inputView.repaymentAmount = self.creditBill.amount - self.creditBill.paidAmount;
        self.inputView.textField.text = [NSString stringWithFormat:@"%0.2f", self.creditBill.amount - self.creditBill.paidAmount];
        if (self.inputView.textField.hasText) {
            self.inputView.placeholderLabel.hidden = YES;
        }
        if ([self.inputView.textField.text doubleValue]) {
            self.nextButton.enabled = YES;
        }
    } else {
        if ([WXApi isWXAppInstalled]) {
            TCPaymentMethodModel *model = [[TCPaymentMethodModel alloc] init];
            model.paymentMethod = TCPaymentMethodWechat;
            model.selected = YES;
            model.singleRow = YES;
            self.currentMethodModel = model;
            self.methodView.methodModel = model;
        } else {
            [self loadBankCardListToShowMethodsSelectView:NO];
        }
        if (self.suggestAmount) {
            self.inputView.textField.text = [NSString stringWithFormat:@"%0.2f", self.suggestAmount];
        }
        if (self.inputView.textField.hasText) {
            self.inputView.placeholderLabel.hidden = YES;
        }
        if ([self.inputView.textField.text doubleValue]) {
            self.nextButton.enabled = YES;
        }
    }
}

- (void)refreshMethodView {
    if (self.currentMethodModel.paymentMethod == TCPaymentMethodBalance) {
        self.currentMethodModel.prompt = [NSString stringWithFormat:@"可用余额%0.2f元", self.walletAccount.balance];
        self.methodView.methodModel = self.currentMethodModel;
    }
}

#pragma mark - Load Net Data

- (void)reloadWalletAccountInfo {
    [MBProgressHUD showHUD:YES];
    if (self.paymentPurpose == TCCommonPaymentPurposeRecharge || self.paymentPurpose == TCCommonPaymentPurposeRepayment) {
        [[TCBuluoApi api] fetchWalletAccountInfo:^(TCWalletAccount *walletAccount, NSError *error) {
            if (walletAccount) {
                [MBProgressHUD hideHUD:YES];
                weakSelf.walletAccount = walletAccount;
                [weakSelf refreshMethodView];
            } else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
            }
        }];
    } else {
        [[TCBuluoApi api] fetchCompanyWalletAccountInfoByCompanyID:self.walletAccount.ID result:^(TCWalletAccount *walletAccount, NSError *error) {
            if (walletAccount) {
                [MBProgressHUD hideHUD:YES];
                weakSelf.walletAccount = walletAccount;
                [weakSelf refreshMethodView];
            } else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
            }
        }];
    }
}

- (void)loadBankCardListToShowMethodsSelectView:(BOOL)toShow {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchBankCardList:^(NSArray *bankCardList, NSError *error) {
        if (bankCardList) {
            [MBProgressHUD hideHUD:YES];
            if (toShow) {
                NSArray *methodModels = [weakSelf createPaymentMethodModelsWithBankCardList:bankCardList];
                [weakSelf showPaymentMethodsSelectViewWithMethodModels:methodModels];
            }
        } else {
            NSString *message = error.localizedDescription ?: @"获取信息失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
        }
        
        if (toShow == NO) {
            TCPaymentMethodModel *model = [[TCPaymentMethodModel alloc] init];
            if (bankCardList.count) {
                TCBankCard *bankCard = bankCardList[0];
                bankCard.logo = @"bank_logo_Default";
                for (NSDictionary *bankInfo in self.bankInfoList) {
                    if ([bankInfo[@"code"] isEqualToString:bankCard.bankCode]) {
                        bankCard.logo = bankInfo[@"logo"];
                        break;
                    }
                }
                model.paymentMethod = TCPaymentMethodBankCard;
                model.bankCard = bankCard;
                model.selected = YES;
                model.invalid = (bankCard.type == TCBankCardTypeWithdraw);
            } else {
                model.paymentMethod = TCPaymentMethodNone;
                model.singleRow = YES;
                model.selected = YES;
            }
            weakSelf.currentMethodModel = model;
            weakSelf.methodView.methodModel = model;
        }
    }];
}

#pragma mark - 创建模型数据源

- (NSArray *)createPaymentMethodModelsWithBankCardList:(NSArray *)bankCardList {
    NSMutableArray *models = [NSMutableArray array];
    
    // 余额支付
    if (self.paymentPurpose == TCCommonPaymentPurposeRepayment) {
        TCPaymentMethodModel *model = [[TCPaymentMethodModel alloc] init];
        model.paymentMethod = TCPaymentMethodBalance;
        model.prompt = [NSString stringWithFormat:@"可用余额%0.2f元", self.walletAccount.balance];
        if (model.paymentMethod == self.currentMethodModel.paymentMethod) {
            model.selected = YES;
        }
        [models addObject:model];
    }
    
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

#pragma mark - Actions

- (void)handleTapMethodView {
    if (self.paymentPurpose == TCCommonPaymentPurposeCompanyRepayment) {
        return;
    }
    if ([self.inputView.textField isFirstResponder]) {
        [self.inputView.textField resignFirstResponder];
    }
    
    [self loadBankCardListToShowMethodsSelectView:YES];
}

- (void)handleClickNextButton {
    if ([self.inputView.textField isFirstResponder]) {
        [self.inputView.textField resignFirstResponder];
    }
    
    double value = [self.inputView.textField.text doubleValue];
    self.totalFee = value;
    
    switch (self.currentMethodModel.paymentMethod) {
        case TCPaymentMethodNone:
            [MBProgressHUD showHUDWithMessage:@"请先绑定银行卡"];
            break;
        case TCPaymentMethodBalance:
            [self handlePaymetWithBalance];
            break;
        case TCPaymentMethodWechat:
            [self handlePaymetWithWechat];
            break;
        case TCPaymentMethodBankCard:
            [self handlePaymetWithBankCard];
            break;
            
        default:
            break;
    }
}

- (void)handlePaymetWithBalance {
    [self checkWalletAccount];
}

- (void)handlePaymetWithWechat {
    if (self.paymentPurpose == TCCommonPaymentPurposeRecharge || self.paymentPurpose == TCCommonPaymentPurposeCompanyRecharge) {
        [self fetchWechatPaymentInfoWithPaymentID:nil];
    } else {
        [self commitWechatPaymentRequest];
    }
}

- (void)handlePaymetWithBankCard {
    if (self.paymentPurpose == TCCommonPaymentPurposeRecharge || self.paymentPurpose == TCCommonPaymentPurposeCompanyRecharge) {
        [self fetchBFSessionInfoWithPaymentID:nil refetchVCode:NO];
    } else {
        [self commitBFPaymentRequest];
    }
}

- (void)handleTapBgView {
    if (self.methodsSelectView) {
        [self dismissPaymentMethodsSelectView];
    }
    if (self.passwordView) {
        [self dismissPasswordView];
    }
    if (self.paymentBankCardView) {
        [self dismissBankCardCodeView];
    }
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    if (self.paymentPurpose == TCCommonPaymentPurposeRepayment || self.paymentPurpose == TCCommonPaymentPurposeCompanyRepayment) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.navigationController) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - 余额支付

- (void)checkWalletAccount {
    // 校验钱包信息
    if (!self.walletAccount.password) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还未设置支付密码\n请先设置支付密码，再进行还款" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showPasswordViewController];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:confirmAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    if (self.totalFee > self.walletAccount.balance) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的钱包余额不足，请充值" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showRechargeViewController];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:confirmAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    [self showPasswordView];
}

/**
 提交还款申请
 */
- (void)commitBalancePaymentWithPassword:(NSString *)password {
    if (![self.walletAccount.password isEqualToString:TCDigestMD5(password)]) {
        [MBProgressHUD showHUDWithMessage:@"密码错误，请重新输入"];
        return;
    }
    
    [MBProgressHUD showHUD:YES];
    [self.passwordView.textField resignFirstResponder];
    [self dismissPasswordView];
    
    TCPaymentRequestInfo *requestInfo = [[TCPaymentRequestInfo alloc] init];
    requestInfo.password = password;
    requestInfo.payChannel = TCPayChannelBalance;
    requestInfo.totalFee = self.totalFee;
    requestInfo.targetId = self.creditBill.ID;
    [[TCBuluoApi api] commitPaymentRequest:requestInfo payPurpose:TCPayPurposeCredit walletID:self.walletAccount.ID result:^(TCUserPayment *userPayment, NSError *error) {
        if (userPayment) {
            if ([userPayment.status isEqualToString:@"CREATED"]) { // 正在处理中
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf queryBalancePaymentStatusWithPaymentID:userPayment.ID];
                });
            } else if ([userPayment.status isEqualToString:@"FAILURE"]) { // 错误（余额不足）
                NSString *message = userPayment.note ?: @"还款失败，请稍后再试";
                [MBProgressHUD showHUDWithMessage:message];
            } else { // 还款成功
                [weakSelf handleRepaymentSucceed];
            }
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"还款失败，%@", reason]];
        }
    }];
}

/**
 查询还款状态
 */
- (void)queryBalancePaymentStatusWithPaymentID:(NSString *)paymentID {
    [[TCBuluoApi api] fetchUserPaymentByWalletID:self.walletAccount.ID paymentID:paymentID result:^(TCUserPayment *userPayment, NSError *error) {
        if (userPayment) {
            if ([userPayment.status isEqualToString:@"FAILURE"]) {
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"还款失败，%@", userPayment.note]];
            } else {
                [weakSelf handleRepaymentSucceed];
            }
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"还款失败，%@", reason]];
        }
    }];
}

#pragma mark - 微信支付

- (void)commitWechatPaymentRequest {
    [MBProgressHUD showHUD:YES];
    TCPaymentRequestInfo *requestInfo = [[TCPaymentRequestInfo alloc] init];
    requestInfo.payChannel = TCPayChannelWechat;
    requestInfo.targetId = self.creditBill.ID;
    requestInfo.totalFee = self.totalFee;
    [[TCBuluoApi api] commitPaymentRequest:requestInfo payPurpose:TCPayPurposeCredit walletID:self.walletAccount.ID result:^(TCUserPayment *userPayment, NSError *error) {
        if (userPayment) {
            [weakSelf fetchWechatPaymentInfoWithPaymentID:userPayment.ID];
        } else {
            NSString *message = error.localizedDescription ?: @"操作失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
        }
    }];
}

- (void)fetchWechatPaymentInfoWithPaymentID:(NSString *)paymentID {
    TCWechatPaymentRequestInfo *requestInfo = [[TCWechatPaymentRequestInfo alloc] init];
    requestInfo.totalFee = self.totalFee;
    requestInfo.paymentId = paymentID;
    if (self.paymentPurpose == TCCommonPaymentPurposeRecharge || self.paymentPurpose == TCCommonPaymentPurposeCompanyRecharge) {
        requestInfo.targetId = self.walletAccount.ID;
    } else {
        requestInfo.targetId = self.creditBill.ID;
    }
    
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
            if (weakSelf.paymentPurpose == TCCommonPaymentPurposeRecharge || weakSelf.paymentPurpose == TCCommonPaymentPurposeCompanyRecharge) {
                [self handleRechargeSucceed];
            } else {
                [self handleRepaymentSucceed];
            }
        } else {
            NSString *message = error.localizedDescription ?: @"付款失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
        }
    }];
}

#pragma mark - 宝付银行支付

/**
 提交付款申请
 */
- (void)commitBFPaymentRequest {
    [MBProgressHUD showHUD:YES];
    TCPaymentRequestInfo *requestInfo = [[TCPaymentRequestInfo alloc] init];
    requestInfo.payChannel = TCPayChannelBankCard;
    requestInfo.targetId = self.creditBill.ID;
    requestInfo.totalFee = self.totalFee;
    [[TCBuluoApi api] commitPaymentRequest:requestInfo payPurpose:TCPayPurposeCredit walletID:self.walletAccount.ID result:^(TCUserPayment *userPayment, NSError *error) {
        if (userPayment) {
            weakSelf.userPayment = userPayment;
            [weakSelf fetchBFSessionInfoWithPaymentID:userPayment.ID refetchVCode:NO];
        } else {
            NSString *message = error.localizedDescription ?: @"操作失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
        }
    }];
}

/**
 宝付获取SESSION_ID
 */
- (void)fetchBFSessionInfoWithPaymentID:(NSString *)paymentID refetchVCode:(BOOL)isRefetchVCode {
    self.refetchVCode = isRefetchVCode;
    [MBProgressHUD showHUD:YES];
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
 宝付预充值
 */
- (void)prepareBFPay {
    TCBFPayInfo *payInfo = [[TCBFPayInfo alloc] init];
    payInfo.bankCardId = self.currentMethodModel.bankCard.ID;
    payInfo.totalFee = self.totalFee;
    payInfo.paymentId = self.bfSessionInfo.paymentId;
    if (weakSelf.paymentPurpose == TCCommonPaymentPurposeRecharge || weakSelf.paymentPurpose == TCCommonPaymentPurposeCompanyRecharge) {
        payInfo.targetId = self.walletAccount.ID;
    } else {
        payInfo.targetId = self.creditBill.ID;
    }
    [[TCBuluoApi api] prepareBFPayWithInfo:payInfo result:^(NSString *payID, NSError *error) {
        if (payID) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.payID = payID;
            if (weakSelf.isRefetchVCode) {
                [weakSelf.paymentBankCardView startCountDown];
            } else {
                [weakSelf showBankCardCodeView];
            }
        } else {
            [weakSelf showErrorMessageHUD:error.localizedDescription];
        }
    }];
}

/**
 宝付确认充值
 */
- (void)confirmBankCardRechargeWithVCode:(NSString *)vCode {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] confirmBFPayWithPayID:self.payID vCode:vCode result:^(TCBFPayResult payResult, NSError *error) {
        if (payResult == TCBFPayResultSucceed) {
            if (weakSelf.paymentPurpose == TCCommonPaymentPurposeRecharge || weakSelf.paymentPurpose == TCCommonPaymentPurposeCompanyRecharge) {
                [weakSelf handleRechargeSucceed];
            } else {
                [weakSelf handleRepaymentSucceed];
            }
        } else if (payResult == TCBFPayResultProcessing) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf queryBankCardRechargeWithVCode:vCode];
            });
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"操作失败，%@", reason]];
        }
    }];
}

/**
 宝付查询充值
 */
- (void)queryBankCardRechargeWithVCode:(NSString *)vCode {
    [[TCBuluoApi api] queryBFPayWithPayID:self.payID result:^(TCBFPayResult payResult, NSError *error) {
        if (payResult == TCBFPayResultSucceed) {
            if (weakSelf.paymentPurpose == TCCommonPaymentPurposeRecharge || weakSelf.paymentPurpose == TCCommonPaymentPurposeCompanyRecharge) {
                [weakSelf handleRechargeSucceed];
            } else {
                [weakSelf handleRepaymentSucceed];
            }
        } else if (payResult == TCBFPayResultProcessing) {
            [MBProgressHUD showHUDWithMessage:@"操作处理中，请稍后在“我的钱包”中查询"];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"操作失败，%@", reason]];
        }
    }];
}

/**
 显示错误HUD
 */
- (void)showErrorMessageHUD:(NSString *)errorMessage {
    NSString *result = self.isRefetchVCode ? @"获取验证码失败，请稍后再试" : @"申请付款失败，请稍后再试";
    NSString *message = errorMessage ?: result;
    [MBProgressHUD showHUDWithMessage:message];
}

#pragma mark - 充值成功

/**
 充值成功
 */
- (void)handleRechargeSucceed {
    [MBProgressHUD showHUDWithMessage:@"充值成功"];
    
    // 发送首页需要刷新数据的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:TCNotificationHomePageNeedRefreshData object:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        if (weakSelf.rechargeCompletionBlock) {
            weakSelf.rechargeCompletionBlock();
        }
    });
}

#pragma mark - 还款成功或还款处理中

/**
 还款成功
 */
- (void)handleRepaymentSucceed {
    [MBProgressHUD showHUDWithMessage:@"还款成功！"];
    
    // 发送首页需要刷新数据的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:TCNotificationHomePageNeedRefreshData object:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.navigationController popToViewController:weakSelf.navigationController.childViewControllers[1] animated:YES];
    });
}

#pragma mark - 创建背景

- (UIView *)createBgView {
    UIView *superView = self.navigationController.view;
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = TCARGBColor(0, 0, 0, 0);
    [superView addSubview:bgView];
    [superView bringSubviewToFront:bgView];
    UIView *tapView = [[UIView alloc] initWithFrame:bgView.bounds];
    [bgView addSubview:tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBgView)];
    [tapView addGestureRecognizer:tap];
    
    return bgView;
}

#pragma mark - 显示选择付款方式页面

- (void)showPaymentMethodsSelectViewWithMethodModels:(NSArray *)methodModels {
    UIView *bgView = [self createBgView];
    self.bgView = bgView;
    
    TCPaymentMethodsSelectView *selectView = [[TCPaymentMethodsSelectView alloc] initWithPaymentMethodModels:methodModels backButtonStyle:TCBackButtonStyleClose];
    selectView.frame = CGRectMake(0, TCScreenHeight, TCScreenWidth, subviewHeight);
    selectView.delegate = self;
    [bgView addSubview:selectView];
    self.methodsSelectView = selectView;
    
    [UIView animateWithDuration:duration animations:^{
        bgView.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
        selectView.y = TCScreenHeight - subviewHeight;
    }];
}

- (void)dismissPaymentMethodsSelectView {
    [UIView animateWithDuration:duration animations:^{
        weakSelf.bgView.backgroundColor = TCARGBColor(0, 0, 0, 0);
        weakSelf.methodsSelectView.y = TCScreenHeight;
    } completion:^(BOOL finished) {
        [weakSelf.methodsSelectView removeFromSuperview];
        [weakSelf.bgView removeFromSuperview];
    }];
}

#pragma mark - 显示输入密码页面

/**
 显示输入密码面板
 */
- (void)showPasswordView {
    UIView *bgView = [self createBgView];
    self.bgView = bgView;
    
    TCPaymentPasswordView *passwordView = [[NSBundle mainBundle] loadNibNamed:@"TCPaymentPasswordView" owner:nil options:nil].lastObject;
    passwordView.frame = CGRectMake(0, TCScreenHeight, TCScreenWidth, subviewHeight);
    passwordView.delegate = self;
    [bgView addSubview:passwordView];
    self.passwordView = passwordView;
    
    [UIView animateWithDuration:duration animations:^{
        bgView.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
        passwordView.y = TCScreenHeight - subviewHeight;
    } completion:^(BOOL finished) {
        [passwordView.textField becomeFirstResponder];
    }];
}

/**
 退出输入密码面板
 */
- (void)dismissPasswordView {
    [UIView animateWithDuration:duration animations:^{
        weakSelf.bgView.backgroundColor = TCARGBColor(0, 0, 0, 0);
        weakSelf.passwordView.y = TCScreenHeight;
    } completion:^(BOOL finished) {
        [weakSelf.passwordView removeFromSuperview];
        [weakSelf.bgView removeFromSuperview];
    }];
}

#pragma mark - 显示输入银行卡验证码页面

/**
 显示输入银行卡验证码页面
 */
- (void)showBankCardCodeView {
    UIView *bgView = [self createBgView];
    self.bgView = bgView;
    
    TCPaymentBankCardView *paymentBankCardView = [[TCPaymentBankCardView alloc] initWithBankCard:self.currentMethodModel.bankCard];
    paymentBankCardView.frame = CGRectMake(0, TCScreenHeight, TCScreenWidth, subviewHeight);
    paymentBankCardView.delegate = self;
    [bgView addSubview:paymentBankCardView];
    self.paymentBankCardView = paymentBankCardView;
    
    [UIView animateWithDuration:duration animations:^{
        bgView.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
        paymentBankCardView.y = TCScreenHeight - subviewHeight;
    } completion:^(BOOL finished) {
        [paymentBankCardView.codeTextField becomeFirstResponder];
    }];
}

/**
 退出输入银行卡验证码页面
 */
- (void)dismissBankCardCodeView {
    if ([self.paymentBankCardView.codeTextField isFirstResponder]) {
        [self.paymentBankCardView.codeTextField resignFirstResponder];
    }
    [UIView animateWithDuration:duration animations:^{
        weakSelf.bgView.backgroundColor = TCARGBColor(0, 0, 0, 0);
        weakSelf.paymentBankCardView.y = TCScreenHeight;
    } completion:^(BOOL finished) {
        [weakSelf.paymentBankCardView removeFromSuperview];
        [weakSelf.bgView removeFromSuperview];
    }];
}

#pragma mark - 显示设置支付密码控制器

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

#pragma mark - 显示充值控制器

/**
 显示充值页面
 */
- (void)showRechargeViewController {
    TCCommonPaymentPurpose purpose;
    if (self.paymentPurpose == TCCommonPaymentPurposeRepayment) {
        purpose = TCCommonPaymentPurposeRecharge;
    } else {
        purpose = TCCommonPaymentPurposeCompanyRecharge;
    }
    TCCommonPaymentViewController *vc = [[TCCommonPaymentViewController alloc] initWithPaymentPurpose:purpose];
    vc.walletAccount = self.walletAccount;
    vc.suggestAmount = self.totalFee - self.walletAccount.balance;
    vc.rechargeCompletionBlock = ^{
        [weakSelf reloadWalletAccountInfo];
    };
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 显示添加银行卡控制器

- (void)showAddbankCardViewController {
    TCBankCardAddViewController *vc = [[TCBankCardAddViewController alloc] init];
    vc.walletID = [[TCBuluoApi api] currentUserSession].assigned;
    vc.bankCardAddBlock = ^() {
        [weakSelf loadBankCardListToShowMethodsSelectView:NO];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TCPaymentMethodsSelectViewDelegate

- (void)paymentMethodsSelectView:(TCPaymentMethodsSelectView *)view didSlectedMethod:(TCPaymentMethodModel *)methodModel {
    self.currentMethodModel = methodModel;
    self.methodView.methodModel = methodModel;
    [self dismissPaymentMethodsSelectView];
}

- (void)didClickBackButtonInPaymentMethodsSelectView:(TCPaymentMethodsSelectView *)view {
    [self dismissPaymentMethodsSelectView];
}

- (void)didClickAddBankCardInPaymentMethodsSelectView:(TCPaymentMethodsSelectView *)view {
    [self dismissPaymentMethodsSelectView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf showAddbankCardViewController];
    });
}

#pragma mark - TCPaymentPasswordViewDelegate

- (void)paymentPasswordView:(TCPaymentPasswordView *)view didFilledPassword:(NSString *)password {
    [self commitBalancePaymentWithPassword:password];
}

- (void)didClickBackButtonInPaymentPasswordView:(TCPaymentPasswordView *)view {
    [self dismissPasswordView];
}

#pragma mark - WXApiManagerDelegate

- (void)managerDidRecvPayResponse:(PayResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            [self checkWechatPaymentResult];
            break;
            
        default:
            if (self.paymentPurpose == TCCommonPaymentPurposeRecharge || self.paymentPurpose == TCCommonPaymentPurposeCompanyRecharge) {
                [MBProgressHUD showHUDWithMessage:@"充值失败"];
            } else {
                [MBProgressHUD showHUDWithMessage:@"还款失败"];
            }
            break;
    }
}

#pragma mark - TCPaymentBankCardViewDelegate

- (void)didClickBackButtonInBankCardView:(TCPaymentBankCardView *)view {
    [self dismissBankCardCodeView];
}

- (void)didClickFetchCodeButtonInBankCardView:(TCPaymentBankCardView *)view {
    [self fetchBFSessionInfoWithPaymentID:self.userPayment.ID refetchVCode:YES];
}

- (void)bankCardView:(TCPaymentBankCardView *)view didClickConfirmButtonWithCode:(NSString *)code {
    [self confirmBankCardRechargeWithVCode:code];
    [self dismissBankCardCodeView];
}

#pragma mark - BaofuFuFingerClientDelegate

-(void)initialSucess {
    [self prepareBFPay];
}

-(void)initialfailed:(NSString*)errorMessage {
    [weakSelf showErrorMessageHUD:errorMessage];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    /*
     * 不能输入.0-9以外的字符
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.havePoint = YES;
    } else {
        self.havePoint = NO;
    }
    
    if (string.length > 0) {
        // 当前输入的字符
        unichar character = [string characterAtIndex:0];
        TCLog(@"single = %c",character);
        
        // 不能输入.0-9以外的字符
        if (((character < '0') || (character > '9')) && (character != '.')) {
            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHavePoint && character == '.') {
            return NO;
        }
        
        // 如果第一位是.则前面加上0
        if (textField.text.length == 0 && character == '.') {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondCharacter = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondCharacter isEqualToString:@"."]) {
                    return NO;
                }
            } else {
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHavePoint) {
            NSRange pointRange = [textField.text rangeOfString:@"."];
            if (range.location > pointRange.location) {
                if ([textField.text pathExtension].length > 1) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark - Notifications

/**
 输入文字变化的通知
 */
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    TCNumberTextField *textField = (TCNumberTextField *)notification.object;
    
    if (![textField isEqual:self.inputView.textField]) {
        return;
    }
    
    double value = [textField.text doubleValue];
    
    if (value) {
        self.nextButton.enabled = YES;
    } else {
        self.nextButton.enabled = NO;
    }
}


/**
 修改支付密码的通知
 */
- (void)registerPasswordChangeNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWalletPasswordDidChangeNotification:) name:TCWalletPasswordDidChangeNotification object:nil];
}

- (void)removePasswordChangeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleWalletPasswordDidChangeNotification:(NSNotification *)notification {
    NSString *aNewPassword = notification.userInfo[TCWalletPasswordKey];
    self.walletAccount.password = aNewPassword;
}

#pragma mark - Override Methods

- (NSArray *)bankInfoList {
    if (_bankInfoList == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TCBankInfoList" ofType:@"plist"];
        _bankInfoList = [NSArray arrayWithContentsOfFile:path];
    }
    return _bankInfoList;
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
