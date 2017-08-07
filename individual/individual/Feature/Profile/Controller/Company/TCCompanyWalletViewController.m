//
//  TCCompanyWalletViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCompanyWalletViewController.h"
#import "TCNavigationController.h"
#import "TCRechargeViewController.h"
#import "TCCreditViewController.h"
#import "TCWalletBillViewController.h"
#import "TCWalletPasswordViewController.h"

#import "TCCompanyWalletTitleView.h"
#import "TCWalletBalanceView.h"
#import "TCWalletFeaturesView.h"

#import "TCBuluoApi.h"
#import "TCUserDefaultsKeys.h"

@interface TCCompanyWalletViewController () <TCWalletFeaturesViewDelegate>

@property (strong, nonatomic) TCWalletAccount *walletAccount;

@property (weak, nonatomic) TCCompanyWalletTitleView *titleView;
@property (weak, nonatomic) TCWalletBalanceView *balanceView;

@end

@implementation TCCompanyWalletViewController {
    __weak TCCompanyWalletViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"我的公司";
    self.view.backgroundColor = TCRGBColor(239, 244, 245);
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fetchNetData];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    TCCompanyWalletTitleView *titleView = [[TCCompanyWalletTitleView alloc] init];
    titleView.nameLabel.text = [[TCBuluoApi api] currentUserSession].userInfo.companyName;
    [titleView.closeButton addTarget:self action:@selector(handleClickCloseTitleButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    TCWalletBalanceView *balanceView = [[TCWalletBalanceView alloc] initWithType:TCWalletBalanceViewTypeCompany];
    [self.view addSubview:balanceView];
    self.balanceView = balanceView;
    
    TCWalletFeaturesView *featuresView = [[TCWalletFeaturesView alloc] initWithType:TCWalletFeaturesViewTypeCompany];
    featuresView.delegate = self;
    [self.view addSubview:featuresView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22.5);
        make.top.left.right.equalTo(self.view);
    }];
    [balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(22.5);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(TCRealValue(224));
    }];
    [featuresView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceView.mas_bottom).offset(TCRealValue(9));
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)fetchNetData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchCompanyWalletAccountInfoByCompanyID:self.companyID result:^(TCWalletAccount *walletAccount, NSError *error) {
        if (walletAccount) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.walletAccount = walletAccount;
            weakSelf.balanceView.walletAccount = walletAccount;
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取钱包信息失败！"];
        }
    }];
}

#pragma mark - TCWalletFeaturesViewDelegate

- (void)walletFeaturesView:(TCWalletFeaturesView *)view didClickFeatureButtonWithIndex:(NSInteger)index {
    if (!self.walletAccount) {
        [MBProgressHUD showHUDWithMessage:@"获取钱包信息失败，暂不能操作，请退出此页面重试"];
        return;
    }
    switch (index) {
        case 0:
            [self handleClickRechargeButton];
            break;
        case 1:
            [self handleClickStatementButton];
            break;
        case 2:
            [self handleClickCreditButton];
            break;
        case 3:
            [self handleClickRentButton];
            break;
            break;
        case 4:
            [self handleClickPasswordButton];
            break;
            break;
            
        default:
            break;
    }
}

#pragma mark - Actions

- (void)handleClickCloseTitleButton:(id)seder {
    [self.titleView removeFromSuperview];
    [self.balanceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
}

- (void)handleClickRechargeButton {
    TCRechargeViewController *vc = [[TCRechargeViewController alloc] init];
    vc.companyID = self.companyID;
    vc.walletAccount = self.walletAccount;
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)handleClickStatementButton {
    TCWalletBillViewController *vc = [[TCWalletBillViewController alloc] init];
    vc.walletID = self.walletAccount.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickCreditButton {
    TCCreditViewController *vc = [[TCCreditViewController alloc] init];
    vc.companyID = self.companyID;
    vc.walletAccount = self.walletAccount;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickRentButton {
    
}

- (void)handleClickPasswordButton {
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
