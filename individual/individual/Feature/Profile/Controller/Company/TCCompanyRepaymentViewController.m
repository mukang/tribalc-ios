//
//  TCCompanyRepaymentViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCompanyRepaymentViewController.h"
#import "TCRechargeViewController.h"
#import "TCWalletPasswordViewController.h"
#import "TCNavigationController.h"

#import "TCRepaymentInputViewCell.h"
#import "TCRechargeMethodViewCell.h"
#import "TCPaymentPasswordView.h"

#import "TCBuluoApi.h"
#import "TCNotificationNames.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <TCCommonLibs/TCFunctions.h>

#define passwordViewH 400
#define duration 0.25

@interface TCCompanyRepaymentViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TCPaymentPasswordViewDelegate, TCRechargeMethodViewCellDelegate>

@property (nonatomic) double amount;
/** 输入框里是否含有小数点 */
@property (nonatomic, getter=isHavePoint) BOOL havePoint;

/** 密码输入页面的背景 */
@property (weak, nonatomic) UIView *bgView;
/** 密码输入页面 */
@property (weak, nonatomic) TCPaymentPasswordView *passwordView;

@property (weak, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *footerView;
@property (weak, nonatomic) TCCommonButton *repaymentButton;
@property (weak, nonatomic) TCNumberTextField *textField;

@end

@implementation TCCompanyRepaymentViewController {
    __weak TCCompanyRepaymentViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"企业还款";
    
    [self setupSubviews];
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

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(239, 244, 245);
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCRepaymentInputViewCell class] forCellReuseIdentifier:@"TCRepaymentInputViewCell"];
    [tableView registerClass:[TCRechargeMethodViewCell class] forCellReuseIdentifier:@"TCRechargeMethodViewCell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
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
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    if (indexPath.section == 0) {
        TCRepaymentInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRepaymentInputViewCell" forIndexPath:indexPath];
        
        cell.subTitleLabel.text = [NSString stringWithFormat:@"应还金额：%0.2f", (self.creditBill.amount - self.creditBill.paidAmount)];
        cell.textField.delegate = self;
        self.textField = cell.textField;
        currentCell = cell;
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.textLabel.text = @"支付方式";
            cell.textLabel.textColor = TCBlackColor;
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.separatorInset = UIEdgeInsetsZero;
            cell.textLabel.x = 20;
            cell.textLabel.centerY = 22.5;
            currentCell = cell;
        } else {
            TCRechargeMethodViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRechargeMethodViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.logoImageView.image = [UIImage imageNamed:@"balance_icon"];
            cell.titleLabel.text = [NSString stringWithFormat:@"企业余额（¥%0.2f）", self.walletAccount.balance];
            cell.hideMarkIcon = YES;
            cell.showRechargeButton = (self.walletAccount.balance < (self.creditBill.amount - self.creditBill.paidAmount));
            cell.delegate = self;
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

#pragma mark - TCRechargeMethodViewCellDelegate

- (void)didClickRechargeButtonInRechargeMethodViewCell:(TCRechargeMethodViewCell *)cell {
    [self.textField resignFirstResponder];
    
    [self showRechargeViewController];
}

#pragma mark - TCPaymentPasswordViewDelegate

- (void)paymentPasswordView:(TCPaymentPasswordView *)view didFilledPassword:(NSString *)password {
    [self handleRepaymentWithPassword:password];
}

- (void)didClickBackButtonInPaymentPasswordView:(TCPaymentPasswordView *)view {
    [self dismissPasswordView];
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

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.textField resignFirstResponder];
    
    [super handleClickBackButton:sender];
}

#pragma mark - Repayment

- (void)handleClickConfirmButton:(id)sender {
    [self.textField resignFirstResponder];
    
    [self handleRepaymentWithBalance];
}

#pragma mark - 余额还款

/**
 使用余额付款
 */
- (void)handleRepaymentWithBalance {
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
    
    if (self.amount > self.walletAccount.balance) {
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
    
    // 显示“输入密码”面板
    [self showPasswordView];
}

/**
 提交还款申请
 */
- (void)handleRepaymentWithPassword:(NSString *)password {
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
    requestInfo.totalFee = self.amount;
    requestInfo.targetId = self.creditBill.ID;
    [[TCBuluoApi api] commitPaymentRequest:requestInfo payPurpose:TCPayPurposeCredit walletID:self.walletAccount.ID result:^(TCUserPayment *userPayment, NSError *error) {
        if (userPayment) {
            if ([userPayment.status isEqualToString:@"CREATED"]) { // 正在处理中
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf handleQueryRepaymentStatusWithPaymentID:userPayment.ID];
                });
            } else if ([userPayment.status isEqualToString:@"FAILURE"]) { // 错误（余额不足）
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"还款失败，%@", userPayment.note]];
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
- (void)handleQueryRepaymentStatusWithPaymentID:(NSString *)paymentID {
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

#pragma mark - 还款相关页面

/**
 显示余额充值页面
 */
- (void)showRechargeViewController {
    TCRechargeViewController *vc = [[TCRechargeViewController alloc] init];
    vc.walletAccount = self.walletAccount;
    vc.suggestMoney = self.amount - self.walletAccount.balance;
    vc.completionBlock = ^() {
        [weakSelf reloadWalletAccountInfo];
    };
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

/**
 显示输入密码面板
 */
- (void)showPasswordView {
    UIView *superView = self.tabBarController.view;
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = TCARGBColor(0, 0, 0, 0);
    [superView addSubview:bgView];
    [superView bringSubviewToFront:bgView];
    self.bgView = bgView;
    
    TCPaymentPasswordView *passwordView = [[NSBundle mainBundle] loadNibNamed:@"TCPaymentPasswordView" owner:nil options:nil].lastObject;
    passwordView.frame = CGRectMake(0, TCScreenHeight, TCScreenWidth, passwordViewH);
    passwordView.delegate = self;
    [bgView addSubview:passwordView];
    self.passwordView = passwordView;
    
    [UIView animateWithDuration:duration animations:^{
        bgView.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
        passwordView.y = TCScreenHeight - passwordViewH;
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

#pragma mark - 重新获取数据

/**
 重新获取钱包信息
 */
- (void)reloadWalletAccountInfo {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchWalletAccountInfo:^(TCWalletAccount *walletAccount, NSError *error) {
        if (walletAccount) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.walletAccount = walletAccount;
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
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

#pragma mark - Override Methods

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
