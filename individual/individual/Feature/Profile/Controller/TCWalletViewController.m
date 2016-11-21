//
//  TCWalletViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletViewController.h"

#import "TCBuluoApi.h"

@interface TCWalletViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *functionButtons;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end

@implementation TCWalletViewController {
    __weak TCWalletViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
    [self fetchNetData];
}

- (void)setupNavBar {
    self.navigationItem.title = @"我的钱包";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
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

#pragma mark - Actions

- (IBAction)handleClickRechargeButton:(UIButton *)sender {
    
}

- (IBAction)handleClickWithdrawButton:(UIButton *)sender {
    
}

- (IBAction)handleClickBankCardButton:(UIButton *)sender {
    
}

- (IBAction)handleClickSweepCodeButton:(UIButton *)sender {
    
}

- (IBAction)handleClickCouponButton:(UIButton *)sender {
    
}

- (IBAction)handleClickFinanceButton:(UIButton *)sender {
    
}

- (IBAction)handleClickPasswordButton:(UIButton *)sender {
    
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
