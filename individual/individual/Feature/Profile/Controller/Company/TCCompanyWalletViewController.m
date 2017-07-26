//
//  TCCompanyWalletViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCompanyWalletViewController.h"

#import "TCCompanyWalletTitleView.h"
#import "TCWalletBalanceView.h"
#import "TCWalletFeaturesView.h"

@interface TCCompanyWalletViewController () <TCWalletFeaturesViewDelegate>

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

#pragma mark - Private Methods

- (void)setupSubviews {
    TCCompanyWalletTitleView *titleView = [[TCCompanyWalletTitleView alloc] init];
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

#pragma mark - TCWalletFeaturesViewDelegate

- (void)walletFeaturesView:(TCWalletFeaturesView *)view didClickFeatureButtonWithIndex:(NSInteger)index {
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
    
}

- (void)handleClickStatementButton {
    
}

- (void)handleClickCreditButton {
    
}

- (void)handleClickRentButton {
    
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
