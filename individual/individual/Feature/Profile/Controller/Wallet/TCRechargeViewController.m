//
//  TCRechargeViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRechargeViewController.h"
#import "TCBankCardAddViewController.h"

#import "TCRechargeInputView.h"
#import "TCRechargeMethodsView.h"
#import "TCPaymentBankCardView.h"

#import "TCBuluoApi.h"
#import "WXApiManager.h"
#import "TCNotificationNames.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <BaofuFuFingerSDK/BaofuFuFingerSDK.h>

#define paymentBankCardViewH 400
#define duration 0.25

@interface TCRechargeViewController ()
<UITextFieldDelegate,
WXApiManagerDelegate,
TCPaymentBankCardViewDelegate,
BaofuFuFingerClientDelegate,
TCRechargeMethodsViewDelegate>

@property (weak, nonatomic) UILabel *balanceLabel;

@property (weak, nonatomic) UITextField *textField;

@property (weak, nonatomic) TCRechargeMethodsView *methodsView;
/** 银行卡logo及背景图数据 */
@property (copy, nonatomic) NSArray *bankInfoList;

/** 输入框里是否含有小数点 */
@property (nonatomic, getter=isHavePoint) BOOL havePoint;
/** 预支付ID，查询微信支付结果时使用 */
@property (copy, nonatomic) NSString *prepayID;
/** 宝付支付ID */
@property (copy, nonatomic) NSString *payID;

@property (strong, nonatomic) TCBFSessionInfo *bfSessionInfo;
/** 是否是重新获取验证码 */
@property (nonatomic, getter=isRefetchVCode) BOOL refetchVCode;

/** 银行卡验证码输入页面的背景 */
@property (weak, nonatomic) UIView *bgView;
/** 银行卡验证码输入页面 */
@property (weak, nonatomic) TCPaymentBankCardView *paymentBankCardView;

/** 需充值的金额 */
@property (nonatomic) double totalFee;

@end

@implementation TCRechargeViewController {
    __weak TCRechargeViewController *weakSelf;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        weakSelf = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TCRGBColor(226, 238, 252);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapViewGesture:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    [self setupNavBar];
    [self setupSubviews];
    [self handleLoadBankCardList];
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    UIImage *barImage = [UIImage imageNamed:@"TransparentPixel"];
    [navBar setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:barImage];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@""];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"nav_back_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickBackButton:)];
    navItem.leftBarButtonItem = leftItem;
    [navBar setItems:@[navItem]];
}

- (void)setupSubviews {
    UIImageView *balanceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_recharge_balance_bg"]];
    [self.view addSubview:balanceImageView];
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.textColor = TCBlackColor;
    balanceLabel.font = [UIFont boldSystemFontOfSize:17];
    balanceLabel.text = [NSString stringWithFormat:@"余额：¥%0.2f", self.walletAccount.balance];
    [self.view addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    
    TCRechargeInputView *inputView = [[TCRechargeInputView alloc] init];
    inputView.textField.keyboardType = UIKeyboardTypeDecimalPad;
    inputView.textField.textColor = TCBlackColor;
    inputView.textField.font = [UIFont systemFontOfSize:14];
    inputView.textField.delegate = self;
    if (self.suggestMoney) {
        inputView.textField.text = [NSString stringWithFormat:@"%0.2f", self.suggestMoney];
    }
    [self.view addSubview:inputView];
    self.textField = inputView.textField;
    
    TCRechargeMethodsView *methodsView = [[TCRechargeMethodsView alloc] init];
    methodsView.rechargeMethod = TCRechargeMethodBankCard;
//    methodsView.bankCardList = self.walletAccount.bankCards;
    methodsView.delegate = self;
    [self.view addSubview:methodsView];
    self.methodsView = methodsView;
    
    TCCommonButton *rechargeButton = [TCCommonButton buttonWithTitle:@"充  值" target:self action:@selector(handleClickRechargeButton:)];
    [self.view addSubview:rechargeButton];
    
    [balanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(128, 128));
        make.top.equalTo(weakSelf.view.mas_top).with.offset(73);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(50);
        make.centerY.equalTo(balanceImageView.mas_centerY);
    }];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceImageView.mas_bottom).with.offset(TCRealValue(47));
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
    [methodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).with.offset(TCRealValue(58));
        make.bottom.equalTo(rechargeButton.mas_top).with.offset(-40);
        make.left.right.equalTo(weakSelf.view);
    }];
    [rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(30);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-30);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(TCRealValue(-40));
        make.height.mas_equalTo(40);
    }];
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

#pragma mark - WXApiManagerDelegate

- (void)managerDidRecvPayResponse:(PayResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            [self handleCheckWechatRechargeResult];
            break;
            
        default:
            [MBProgressHUD showHUDWithMessage:@"充值失败"];
            break;
    }
}

#pragma mark - TCPaymentBankCardViewDelegate

- (void)didClickBackButtonInBankCardView:(TCPaymentBankCardView *)view {
    [self dismissBankCardCodeView];
}

- (void)didClickFetchCodeButtonInBankCardView:(TCPaymentBankCardView *)view {
    [self fetchBFSessionInfoWithPaymentID:nil refetchVCode:YES];
}

- (void)bankCardView:(TCPaymentBankCardView *)view didClickConfirmButtonWithCode:(NSString *)code {
    [self confirmBankCardRechargeWithVCode:code];
    [self dismissBankCardCodeView];
}

#pragma mark - TCRechargeMethodsViewDelegate

- (void)didSelectedAddBankCardInRechargeMethodsView:(TCRechargeMethodsView *)view {
    TCBankCardAddViewController *vc = [[TCBankCardAddViewController alloc] init];
    vc.walletID = [[TCBuluoApi api] currentUserSession].assigned;
    vc.bankCardAddBlock = ^() {
        [weakSelf handleLoadBankCardList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - BaofuFuFingerClientDelegate

-(void)initialSucess {
    [self prepareBFPay];
}

-(void)initialfailed:(NSString*)errorMessage {
    [weakSelf showErrorMessageHUD:errorMessage];
}

#pragma mark - Actions 

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleTapViewGesture:(UITapGestureRecognizer *)gesture {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (void)handleClickRechargeButton:(UIButton *)sender {
    if (self.textField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入充值金额"];
        return;
    }
    if (!self.methodsView.currentBankCard.ID) {
        [MBProgressHUD showHUDWithMessage:@"添加银行卡后才能充值"];
        return;
    }
    self.totalFee = [self.textField.text doubleValue];
    
    
    if (self.methodsView.rechargeMethod == TCRechargeMethodBankCard) {
        [self fetchBFSessionInfoWithPaymentID:nil refetchVCode:NO];
    }
    
    /*
    if (self.rechargeMethod == TCRechargeMethodWechat) {
        [MBProgressHUD showHUD:YES];
        [[TCBuluoApi api] fetchWechatRechargeInfoWithMoney:money result:^(TCWechatRechargeInfo *wechatRechargeInfo, NSError *error) {
            if (wechatRechargeInfo) {
                [MBProgressHUD hideHUD:NO];
                [weakSelf handleArouseWechatRecharge:wechatRechargeInfo];
            } else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"充值失败，%@", reason]];
            }
        }];
    } else if (self.rechargeMethod == TCRechargeMethodAlipay) {
        // TODO:
    }
     */
}

/**
 充值成功
 */
- (void)handleRechargeSucceed {
    [MBProgressHUD showHUDWithMessage:@"充值成功"];
    
    // 发送首页需要刷新数据的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:TCNotificationHomePageNeedRefreshData object:self];
    
    self.balanceLabel.text = [NSString stringWithFormat:@"余额：¥%0.2f", self.walletAccount.balance + [self.textField.text doubleValue]];
    if (self.completionBlock) {
        self.completionBlock();
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}

/**
 重新获取银行卡列表
 */
- (void)handleLoadBankCardList {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchBankCardList:^(NSArray *bankCardList, NSError *error) {
        if (bankCardList) {
            [MBProgressHUD hideHUD:YES];
            for (TCBankCard *bankCard in bankCardList) {
                bankCard.logo = @"bank_logo_Default";
                for (NSDictionary *bankInfo in weakSelf.bankInfoList) {
                    if ([bankInfo[@"code"] isEqualToString:bankCard.bankCode]) {
                        bankCard.logo = bankInfo[@"logo"];
                        break;
                    }
                }
            }
            weakSelf.walletAccount.bankCards = bankCardList;
            weakSelf.methodsView.bankCardList = bankCardList;
            [weakSelf.methodsView reloadBankCardList];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取银行卡信息失败，%@", reason]];
        }
    }];
}

/**
 点击了获取银行卡验证码背景页面
 */
- (void)handleTapBankCardCodeBgView:(UITapGestureRecognizer *)gesture {
    if (self.paymentBankCardView && [self.paymentBankCardView.codeTextField isFirstResponder]) {
        [self.paymentBankCardView.codeTextField resignFirstResponder];
    }
}

#pragma mark - Wechat Recharge

/**
 调起微信支付
 */
- (void)handleArouseWechatRecharge:(TCWechatRechargeInfo *)rechargeInfo {
    
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD showHUDWithMessage:@"您未安装微信客户端，无法充值"];
        return;
    }
    
    [WXApiManager sharedManager].delegate = self;
    self.prepayID = rechargeInfo.prepayid;
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = rechargeInfo.partnerid;
    req.prepayId = rechargeInfo.prepayid;
    req.nonceStr = rechargeInfo.noncestr;
    req.timeStamp = [rechargeInfo.timestamp intValue];
    req.package = rechargeInfo.package;
    req.sign = rechargeInfo.sign;
    [WXApi sendReq:req];
}

/**
 查询微信支付结果
 */
- (void)handleCheckWechatRechargeResult {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchWechatRechargeResultWithPrepayID:self.prepayID result:^(BOOL success, NSError *error) {
        if (success) {
            [weakSelf handleRechargeSucceed];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"查询充值结果失败，%@", reason]];
        }
    }];
}

#pragma mark - Bao Fu Recharge

/**
 显示输入银行卡验证码页面
 */
- (void)showBankCardCodeView {
    UIView *superView = self.navigationController.view;
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = TCARGBColor(0, 0, 0, 0);
    [superView addSubview:bgView];
    [superView bringSubviewToFront:bgView];
    self.bgView = bgView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBankCardCodeBgView:)];
    tap.cancelsTouchesInView = NO;
    [bgView addGestureRecognizer:tap];
    
    TCPaymentBankCardView *paymentBankCardView = [[TCPaymentBankCardView alloc] initWithBankCard:self.methodsView.currentBankCard];
    paymentBankCardView.frame = CGRectMake(0, TCScreenHeight, TCScreenWidth, paymentBankCardViewH);
    paymentBankCardView.delegate = self;
    [bgView addSubview:paymentBankCardView];
    self.paymentBankCardView = paymentBankCardView;
    
    [UIView animateWithDuration:duration animations:^{
        bgView.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
        paymentBankCardView.y = TCScreenHeight - paymentBankCardViewH;
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
    payInfo.bankCardId = self.methodsView.currentBankCard.ID;
    payInfo.totalFee = self.totalFee;
    payInfo.paymentId = self.bfSessionInfo.paymentId;
    payInfo.targetId = self.companyID ?: nil;
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
            [weakSelf handleRechargeSucceed];
        } else if (payResult == TCBFPayResultProcessing) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf queryBankCardRechargeWithVCode:vCode];
            });
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"充值失败，%@", reason]];
        }
    }];
}

/**
 宝付查询充值
 */
- (void)queryBankCardRechargeWithVCode:(NSString *)vCode {
    [[TCBuluoApi api] queryBFPayWithPayID:self.payID result:^(TCBFPayResult payResult, NSError *error) {
        if (payResult == TCBFPayResultSucceed) {
            [weakSelf handleRechargeSucceed];
        } else if (payResult == TCBFPayResultProcessing) {
            [MBProgressHUD showHUDWithMessage:@"充值处理中，请稍后在“我的钱包”中查询"];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"充值失败，%@", reason]];
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

#pragma mark - Override Methods

- (void)setWalletAccount:(TCWalletAccount *)walletAccount {
    _walletAccount = walletAccount;
    
    for (TCBankCard *bankCard in walletAccount.bankCards) {
        for (NSDictionary *bankInfo in weakSelf.bankInfoList) {
            bankCard.logo = @"bank_logo_Default";
            if ([bankInfo[@"code"] isEqualToString:bankCard.bankCode]) {
                bankCard.logo = bankInfo[@"logo"];
                break;
            }
        }
    }
}

- (NSArray *)bankInfoList {
    if (_bankInfoList == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"TCBankInfoList" ofType:@"plist"];
        _bankInfoList = [NSArray arrayWithContentsOfFile:path];
    }
    return _bankInfoList;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
