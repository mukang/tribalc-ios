//
//  TCWalletViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletViewController.h"
#import "TCWalletBillViewController.h"
#import "TCWalletPasswordViewController.h"
#import "TCBankCardViewController.h"
#import "TCQRCodeViewController.h"
#import "TCCommonPaymentViewController.h"
#import "TCNavigationController.h"
#import "TCWithdrawViewController.h"
#import "TCCreditViewController.h"

#import "TCWalletBalanceView.h"
#import "TCWalletFeaturesView.h"
#import "TCNavigationBar.h"

#import "TCBuluoApi.h"
#import "TCUserDefaultsKeys.h"
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface TCWalletViewController () <TCWalletFeaturesViewDelegate>

@property (weak, nonatomic) TCNavigationBar *navBar;
@property (weak, nonatomic) TCWalletBalanceView *balanceView;

@property (weak, nonatomic) TCWalletFeaturesView *featuresView;

@property (strong, nonatomic) TCWalletAccount *walletAccount;

@end

@implementation TCWalletViewController {
    __weak TCWalletViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.view.backgroundColor = TCRGBColor(239, 244, 245);
    
    [self setupNavBar];
    [self setupSubviews];
    [self registerNotifications];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchNetData];
}

- (void)dealloc {
    [self removeNotifications];
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    TCNavigationBar *navBar = [[TCNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [navBar setBackgroundImage:[UIImage imageNamed:@"TransparentPixel"] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"钱包"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item_white"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickBackButton:)];
    navItem.leftBarButtonItem = leftItem;
    [navBar setItems:@[navItem]];
    
    [navBar setTintColor:[UIColor whiteColor]];
    navBar.titleTextAttributes = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:16],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]
                                   };
    
    self.navBar = navBar;
}

- (void)setupSubviews {
    TCWalletBalanceView *balanceView = [[TCWalletBalanceView alloc] initWithType:TCWalletBalanceViewTypeIndividual];
    [self.view insertSubview:balanceView belowSubview:self.navBar];
    self.balanceView = balanceView;
    
    TCWalletFeaturesView *featuresView = [[TCWalletFeaturesView alloc] initWithType:TCWalletFeaturesViewTypeIndividual];
    featuresView.delegate = self;
    [self.view addSubview:featuresView];
    self.featuresView = featuresView;
    
    [balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(TCRealValue(282));
    }];
    [featuresView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceView.mas_bottom).offset(TCRealValue(9));
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)fetchNetData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchWalletAccountInfo:^(TCWalletAccount *walletAccount, NSError *error) {
        if (walletAccount) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.walletAccount = walletAccount;
            weakSelf.balanceView.walletAccount = walletAccount;
            weakSelf.featuresView.creditStatus = walletAccount.creditStatus;
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取钱包信息失败！"];
        }
    }];
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWalletPasswordDidChangeNotification:) name:TCWalletPasswordDidChangeNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleWalletPasswordDidChangeNotification:(NSNotification *)notification {
    NSString *aNewPassword = notification.userInfo[TCWalletPasswordKey];
    self.walletAccount.password = aNewPassword;
}

#pragma mark - TCWalletFeaturesViewDelegate

- (void)walletFeaturesView:(TCWalletFeaturesView *)view didClickFeatureButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            [self handleClickRechargeButton:nil];
            break;
        case 1:
            [self handleClickWithdrawButton:nil];
            break;
        case 2:
            [self handleClickCreditButton:nil];
            break;
        case 3:
            [self handleClickBankCardButton:nil];
            break;
        case 4:
            [self handleClickSweepCodeButton:nil];
            break;
        case 5:
            [self handleClickStatementButton:nil];
            break;
        case 6:
            [self handleClickCouponButton:nil];
            break;
        case 7:
            [self handleClickFinanceButton:nil];
            break;
        case 8:
            [self handleClickPasswordButton:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark - Actions

- (void)handleClickRechargeButton:(id)sender {
    NSNumber *recharge = [[NSUserDefaults standardUserDefaults] objectForKey:TCUserDefaultsKeySwitchBfRecharge];
    if (recharge && [recharge boolValue] == NO) {
        [self btnClickUnifyTips];
        return;
    }
    if (!self.walletAccount) {
        [MBProgressHUD showHUDWithMessage:@"暂时无法充值"];
        return;
    }
    TCCommonPaymentViewController *vc = [[TCCommonPaymentViewController alloc] initWithPaymentPurpose:TCCommonPaymentPurposeRecharge];
    vc.walletAccount = self.walletAccount;
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)handleClickWithdrawButton:(id)sender {
    NSNumber *withdraw = [[NSUserDefaults standardUserDefaults] objectForKey:TCUserDefaultsKeySwitchBfWithdraw];
    if (withdraw && [withdraw boolValue] == NO) {
        [self btnClickUnifyTips];
        return;
    }
    
    
    if (!self.walletAccount.bankCards.count) {
        [MBProgressHUD showHUDWithMessage:@"绑定银行卡后才能提现"];
        return;
    }
    if (!self.walletAccount.password) {
        [MBProgressHUD showHUDWithMessage:@"您还没有设置密码，请先设置密码"];
        return;
    }
    if (!self.walletAccount.balance) {
        [MBProgressHUD showHUDWithMessage:@"您的钱包余额为0，无法提现"];
        return;
    }
    TCWithdrawViewController *vc = [[TCWithdrawViewController alloc] initWithWalletAccount:self.walletAccount];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickCreditButton:(id)sender {
    TCCreditViewController *creditVC = [[TCCreditViewController alloc] init];
    creditVC.walletAccount = self.walletAccount;
    [self.navigationController pushViewController:creditVC animated:YES];
}

- (void)handleClickBankCardButton:(id)sender {
    TCBankCardViewController *vc = [[TCBankCardViewController alloc] initWithNibName:@"TCBankCardViewController" bundle:[NSBundle mainBundle]];
    vc.walletAccount = self.walletAccount;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickSweepCodeButton:(id)sender {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted) { // 因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
        [MBProgressHUD showHUDWithMessage:@"因为系统原因, 无法访问相册" afterDelay:1.0];
    } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册(用户当初点击了"不允许")
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没允许海托邦访问相机" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self setAuth];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册(用户当初点击了"好")
        [self toQRCodeVC];
    } else if (status == AVAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self toQRCodeVC];
                });
            }
        }];
    }
}

- (void)setAuth {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)toQRCodeVC {
    TCQRCodeViewController *vc = [[TCQRCodeViewController alloc] init];
    vc.fromController = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickStatementButton:(id)sender {
    TCWalletBillViewController *vc = [[TCWalletBillViewController alloc] initWithNibName:@"TCWalletBillViewController" bundle:[NSBundle mainBundle]];
    vc.walletID = self.walletAccount.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)handleClickCouponButton:(UIButton *)sender {
    [self btnClickUnifyTips];
}

- (void)handleClickFinanceButton:(id)sender {
    [self btnClickUnifyTips];
}

- (void)handleClickPasswordButton:(id)sender {
    if (!self.walletAccount) {
        [MBProgressHUD showHUDWithMessage:@"暂时无法设置支付密码"];
        return;
    }
    TCWalletPasswordType passwordType;
    NSString *oldPassword;
    if (self.walletAccount.password) {
        passwordType = TCWalletPasswordTypeResetInputOldPassword;
        oldPassword = self.walletAccount.password;
    } else {
        passwordType = TCWalletPasswordTypeFirstTimeInputPassword;
    }
    TCWalletPasswordViewController *vc = [[TCWalletPasswordViewController alloc] initWithPasswordType:passwordType];
    vc.walletID = self.walletAccount.ID;
    vc.oldPassword = oldPassword;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Status Bar



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
