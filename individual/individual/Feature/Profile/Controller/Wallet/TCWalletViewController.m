//
//  TCWalletViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletViewController.h"
#import "TCWalletBillViewController.h"
#import "TCWalletPasswordViewController.h"
#import "TCBankCardViewController.h"
#import "TCQRCodeViewController.h"
#import "TCRechargeViewController.h"
#import "TCNavigationController.h"
#import "TCWithdrawViewController.h"

#import "TCBuluoApi.h"
#import "TCUserDefaultsKeys.h"

@interface TCWalletViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *functionButtons;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@property (strong, nonatomic) TCWalletAccount *walletAccount;

@end

@implementation TCWalletViewController {
    __weak TCWalletViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    self.navigationItem.title = @"我的钱包";
    
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

- (void)setupSubviews {
    
    CGFloat originSpace = 1, space = 12;
    CGSize imageViewSize, labelSize;
    for (UIButton *button in self.functionButtons) {
        imageViewSize = button.imageView.size;
        labelSize = button.titleLabel.size;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, labelSize.height + space, -labelSize.width + originSpace);
        button.titleEdgeInsets = UIEdgeInsetsMake(imageViewSize.height + space, -imageViewSize.width + originSpace, 0, 0);
    }
}

- (void)fetchNetData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchWalletAccountInfo:^(TCWalletAccount *walletAccount, NSError *error) {
        if (walletAccount) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.walletAccount = walletAccount;
            weakSelf.balanceLabel.text = [NSString stringWithFormat:@"余额：¥%0.2f", walletAccount.balance];
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取钱包信息失败！"];
        }
    }];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWalletPasswordDidChangeNotification:) name:TCWalletPasswordDidChangeNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (IBAction)handleClickRechargeButton:(UIButton *)sender {
    NSNumber *recharge = [[NSUserDefaults standardUserDefaults] objectForKey:TCUserDefaultsKeySwitchBfRecharge];
    if ([recharge boolValue] == NO) {
        [self btnClickUnifyTips];
        return;
    }
    if (!self.walletAccount) {
        [MBProgressHUD showHUDWithMessage:@"暂时无法充值"];
        return;
    }
    TCRechargeViewController *vc = [[TCRechargeViewController alloc] init];
    vc.walletAccount = self.walletAccount;
    vc.completionBlock = ^() {
//        [weakSelf fetchNetData];
    };
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (IBAction)handleClickWithdrawButton:(UIButton *)sender {
    NSNumber *withdraw = [[NSUserDefaults standardUserDefaults] objectForKey:TCUserDefaultsKeySwitchBfWithdraw];
    if ([withdraw boolValue] == NO) {
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
    vc.completionBlock = ^() {
//        [weakSelf fetchNetData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)handleClickBankCardButton:(UIButton *)sender {
    TCBankCardViewController *vc = [[TCBankCardViewController alloc] initWithNibName:@"TCBankCardViewController" bundle:[NSBundle mainBundle]];
    vc.walletAccount = self.walletAccount;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)handleClickSweepCodeButton:(UIButton *)sender {
//    [self btnClickUnifyTips];
    TCQRCodeViewController *qrVc = [[TCQRCodeViewController alloc] init];
    [self.navigationController pushViewController:qrVc animated:YES];
}
- (IBAction)handleClickWalletBillButton:(UIButton *)sender {
    TCWalletBillViewController *vc = [[TCWalletBillViewController alloc] initWithNibName:@"TCWalletBillViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)handleClickCouponButton:(UIButton *)sender {
    [self btnClickUnifyTips];
}

- (IBAction)handleClickFinanceButton:(UIButton *)sender {
    [self btnClickUnifyTips];
}

- (IBAction)handleClickPasswordButton:(UIButton *)sender {
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
    vc.oldPassword = oldPassword;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleWalletPasswordDidChangeNotification:(NSNotification *)notification {
    NSString *aNewPassword = notification.userInfo[TCWalletPasswordKey];
    self.walletAccount.password = aNewPassword;
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
