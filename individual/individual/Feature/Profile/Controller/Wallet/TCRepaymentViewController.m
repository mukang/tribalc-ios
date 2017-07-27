//
//  TCRepaymentViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRepaymentViewController.h"
#import "TCBankCardAddViewController.h"

#import "TCRepaymentInputViewCell.h"
#import "TCRechargeMethodViewCell.h"
#import "TCRechargeAddBankCardViewCell.h"
#import "TCPaymentBankCardView.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <BaofuFuFingerSDK/BaofuFuFingerSDK.h>

#define paymentBankCardViewH 400
#define duration 0.25

@interface TCRepaymentViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, BaofuFuFingerClientDelegate, TCPaymentBankCardViewDelegate>

@property (nonatomic) double amount;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) TCBankCard *currentBankCard;
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

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;
@property (weak, nonatomic) TCCommonButton *repaymentButton;
@property (weak, nonatomic) TCNumberTextField *textField;

@end

@implementation TCRepaymentViewController {
    __weak TCRepaymentViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = self.companyID ? @"企业还款" : @"个人还款";
    
    [self setupSubviews];
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerNotifications];
    
    [self.tableView selectRowAtIndexPath:self.selectedIndexPath
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(239, 244, 245);
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCRepaymentInputViewCell class] forCellReuseIdentifier:@"TCRepaymentInputViewCell"];
    [tableView registerClass:[TCRechargeMethodViewCell class] forCellReuseIdentifier:@"TCRechargeMethodViewCell"];
    [tableView registerClass:[TCRechargeAddBankCardViewCell class] forCellReuseIdentifier:@"TCRechargeAddBankCardViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.walletAccount.bankCards.count + 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    if (indexPath.section == 0) {
        TCRepaymentInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRepaymentInputViewCell" forIndexPath:indexPath];
        cell.subTitleLabel.text = [NSString stringWithFormat:@"应还金额：%0.2f", self.walletAccount.creditBalance];
        cell.textField.delegate = self;
        self.textField = cell.textField;
        currentCell = cell;
    } else {
        if (indexPath.row == self.walletAccount.bankCards.count + 1) {
            TCRechargeAddBankCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRechargeAddBankCardViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            currentCell = cell;
        } else {
            TCRechargeMethodViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRechargeMethodViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            if (indexPath.row == 0) {
                cell.logoImageView.image = [UIImage imageNamed:@"balance_icon"];
                cell.titleLabel.text = @"余额";
            } else {
                TCBankCard *bankCard = self.walletAccount.bankCards[indexPath.row - 1];
                NSString *bankCardNum = bankCard.bankCardNum;
                NSString *lastNum;
                if (bankCardNum.length >= 4) {
                    lastNum = [bankCardNum substringFromIndex:(bankCardNum.length - 4)];
                }
                cell.logoImageView.image = [UIImage imageNamed:bankCard.logo];
                cell.titleLabel.text = [NSString stringWithFormat:@"%@储蓄卡(%@)", bankCard.bankName, lastNum];
            }
            currentCell = cell;
        }
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 75;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 100;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    return self.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self.textField resignFirstResponder];
        
        if (indexPath.row == 0) {
            self.selectedIndexPath = indexPath;
        } else if (indexPath.row == self.walletAccount.bankCards.count + 1) {
            [self handleSelectAddBankCardCell];
        } else {
            self.currentBankCard = self.walletAccount.bankCards[indexPath.row - 1];
            self.selectedIndexPath = indexPath;
        }
    }
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

#pragma mark - BaofuFuFingerClientDelegate

-(void)initialSucess {
    [self prepareBFPay];
}

-(void)initialfailed:(NSString*)errorMessage {
    [weakSelf showErrorMessageHUD:errorMessage];
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


#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    TCNumberTextField *textField = (TCNumberTextField *)notification.object;
    
    if (![textField isEqual:self.textField]) {
        return;
    }
    
    double value = [textField.text doubleValue];
    self.amount = value;
    
    if (value) {
        self.repaymentButton.enabled = YES;
    } else {
        self.repaymentButton.enabled = NO;
    }
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.textField resignFirstResponder];
    
    [super handleClickBackButton:sender];
}

- (void)handleSelectAddBankCardCell {
    TCBankCardAddViewController *vc = [[TCBankCardAddViewController alloc] init];
    vc.walletID = self.walletAccount.ID;
    vc.bankCardAddBlock = ^() {
        [weakSelf handleLoadBankCardList];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 重新获取银行卡列表
 */
- (void)handleLoadBankCardList {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchBankCardListByWalletID:self.walletAccount.ID result:^(NSArray *bankCardList, NSError *error) {
        if (bankCardList) {
            [MBProgressHUD hideHUD:YES];
            for (TCBankCard *bankCard in bankCardList) {
                for (NSDictionary *bankInfo in weakSelf.bankInfoList) {
                    if ([bankInfo[@"code"] isEqualToString:bankCard.bankCode]) {
                        bankCard.logo = bankInfo[@"logo"];
                        bankCard.bgImage = bankInfo[@"bgImage"];
                        break;
                    }
                }
            }
            weakSelf.walletAccount.bankCards = bankCardList;
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView selectRowAtIndexPath:weakSelf.selectedIndexPath
                                            animated:NO
                                      scrollPosition:UITableViewScrollPositionNone];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取银行卡信息失败，%@", reason]];
        }
    }];
}

#pragma mark - Repayment

- (void)handleClickConfirmButton:(id)sender {
    [self.textField resignFirstResponder];
    
    if (self.selectedIndexPath.row == 0) {
        
    } else {
        [self fetchBFSessionInfoWithPaymentID:nil refetchVCode:NO];
    }
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
    payInfo.bankCardId = self.currentBankCard.ID;
    payInfo.totalFee = self.amount;
    payInfo.paymentId = self.bfSessionInfo.paymentId;
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
    
    TCPaymentBankCardView *paymentBankCardView = [[TCPaymentBankCardView alloc] initWithBankCard:self.currentBankCard];
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
 还款成功
 */
- (void)handleRechargeSucceed {
    [MBProgressHUD showHUDWithMessage:@"充值成功"];
//    self.balanceLabel.text = [NSString stringWithFormat:@"余额：¥%0.2f", self.walletAccount.balance + [self.textField.text doubleValue]];
//    if (self.completionBlock) {
//        self.completionBlock();
//    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}

/**
 显示错误HUD
 */
- (void)showErrorMessageHUD:(NSString *)errorMessage {
    NSString *result = self.isRefetchVCode ? @"获取验证码失败" : @"申请付款失败";
    NSString *reason = errorMessage ?: @"请稍后再试";
    [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"%@，%@", result ,reason]];
}

/**
 点击了获取银行卡验证码背景页面
 */
- (void)handleTapBankCardCodeBgView:(UITapGestureRecognizer *)gesture {
    if (self.paymentBankCardView && [self.paymentBankCardView.codeTextField isFirstResponder]) {
        [self.paymentBankCardView.codeTextField resignFirstResponder];
    }
}

#pragma mark - Override Methods

- (void)setWalletAccount:(TCWalletAccount *)walletAccount {
    _walletAccount = walletAccount;
    
    for (TCBankCard *bankCard in walletAccount.bankCards) {
        for (NSDictionary *bankInfo in self.bankInfoList) {
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

- (UIView *)footerView {
    if (_footerView == nil) {
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 100)];
        containerView.backgroundColor = [UIColor clearColor];
        
        TCCommonButton *repaymentButton = [TCCommonButton buttonWithTitle:@"还  款"
                                                                  color:TCCommonButtonColorPurple
                                                                 target:self
                                                                 action:@selector(handleClickConfirmButton:)];
        [repaymentButton setBackgroundImage:[UIImage imageWithColor:TCRGBColor(217, 217, 217)] forState:UIControlStateDisabled];
        repaymentButton.enabled = NO;
        [containerView addSubview:repaymentButton];
        self.repaymentButton = repaymentButton;
        
        [repaymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(TCRealValue(315), 40));
            make.top.equalTo(containerView).offset(26.5);
            make.centerX.equalTo(containerView);
        }];
        
        _footerView = containerView;
    }
    return _footerView;
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
