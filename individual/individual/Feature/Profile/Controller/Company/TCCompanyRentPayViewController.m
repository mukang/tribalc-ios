//
//  TCCompanyRentPayViewController.m
//  individual
//
//  Created by 穆康 on 2017/8/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCompanyRentPayViewController.h"
#import "TCCompanyPaymentViewController.h"
#import "TCApartmentRentPaySuccessViewController.h"
#import "TCRentPlanItemsViewController.h"

#import "TCCompanyRentPayDetailView.h"
#import "TCApartmentRentPayFinishView.h"

#import <TCCommonLibs/TCExtendButton.h>

#import "TCBuluoApi.h"

@interface TCCompanyRentPayViewController ()
<TCCompanyRentPayDetailViewDelegate,
TCApartmentRentPayFinishViewDelegate,
TCCompanyPaymentViewControllerDelegate>

@property (copy, nonatomic) NSString *rentProtocolID;
@property (strong, nonatomic) TCRentPlanItem *rentPlanItem;
@property (weak, nonatomic) TCCompanyRentPayDetailView *rentPayDetailView;
@property (weak, nonatomic) TCExtendButton *payPlanButton;
@property (weak, nonatomic) TCApartmentRentPayFinishView *payFinishView;

@end

@implementation TCCompanyRentPayViewController {
    __weak TCCompanyRentPayViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"企业缴租";
    self.view.backgroundColor = TCRGBColor(239, 244, 245);
    
    [self setupSubviews];
    [self loadRentPlanItem];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    TCCompanyRentPayDetailView *rentPayDetailView = [[TCCompanyRentPayDetailView alloc] init];
    rentPayDetailView.delegate = self;
    rentPayDetailView.hidden = YES;
    [self.view addSubview:rentPayDetailView];
    self.rentPayDetailView = rentPayDetailView;
    
    TCExtendButton *payPlanButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    payPlanButton.hidden = YES;
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"全部付款计划"
                                                                 attributes:@{
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(14)],
                                                                              NSForegroundColorAttributeName: TCRGBColor(74, 119, 250),
                                                                              NSUnderlineStyleAttributeName: @(1)
                                                                              }];
    [payPlanButton setAttributedTitle:attStr forState:UIControlStateNormal];
    [payPlanButton addTarget:self action:@selector(handleClickPayPlanButton:) forControlEvents:UIControlEventTouchUpInside];
    payPlanButton.hitTestSlop = UIEdgeInsetsMake(-10, -20, -10, -20);
    [self.view addSubview:payPlanButton];
    self.payPlanButton = payPlanButton;
    
    TCApartmentRentPayFinishView *payFinishView = [[TCApartmentRentPayFinishView alloc] initWithType:TCRentPayFinishViewTypeCompany];
    payFinishView.hidden = YES;
    payFinishView.delegate = self;
    [self.view addSubview:payFinishView];
    self.payFinishView = payFinishView;
    
    [rentPayDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(TCRealValue(285));
    }];
    [payPlanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(rentPayDetailView.mas_bottom).offset(18);
    }];
    [payFinishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)loadRentPlanItem {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchCompanyCurrentRentPlanItemByCompanyID:self.companyID result:^(NSString *rentProtocolID, TCRentPlanItem *planItem, NSError *error) {
        if (error) {
            NSString *reason = error.localizedDescription ?: @"请退出重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        } else if (rentProtocolID) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.rentProtocolID = rentProtocolID;
            if (planItem) {
                weakSelf.rentPlanItem = planItem;
                [weakSelf showRentPayDetailView];
            } else {
                [weakSelf showRentPayFinishView];
            }
        } else {
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"当前无缴租计划"]];
        }
    }];
}

- (void)showRentPayDetailView {
    self.payFinishView.hidden = YES;
    self.rentPayDetailView.hidden = NO;
    self.rentPayDetailView.companyName = self.companyName;
    self.rentPayDetailView.planItem = self.rentPlanItem;
    self.payPlanButton.hidden = NO;
    [self.view layoutIfNeeded];
}

- (void)showRentPayFinishView {
    self.payFinishView.hidden = NO;
    self.rentPayDetailView.hidden = YES;
    self.payPlanButton.hidden = YES;
    [self.view layoutIfNeeded];
}

#pragma mark - TCCompanyRentPayDetailViewDelegate

- (void)didClickPayButtonInCompanyRentPayDetailView:(TCCompanyRentPayDetailView *)view {
    TCCompanyPaymentViewController *vc = [[TCCompanyPaymentViewController alloc] initWithTotalFee:self.rentPlanItem.plannedRental
                                                                                       payPurpose:TCPayPurposeRent
                                                                                   fromController:self];
    vc.targetID = self.rentProtocolID;
    vc.companyID = self.companyID;
    vc.delegate = self;
    [vc show:YES];
}

#pragma mark - TCCompanyPaymentViewControllerDelegate

- (void)companyPaymentViewController:(TCCompanyPaymentViewController *)controller didFinishedPaymentWithPayment:(TCUserPayment *)payment {
    TCApartmentRentPaySuccessViewController *vc = [[TCApartmentRentPaySuccessViewController alloc] initWithRentPaySuccessType:TCRentPaySuccessTypeCompany];
    vc.itemNum = self.rentPlanItem.num;
    vc.companyID = self.companyID;
    vc.companyName = self.companyName;
    vc.rentProtocolID = self.rentProtocolID;
    vc.paySuccess = ^{
        [weakSelf loadRentPlanItem];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TCApartmentRentPayFinishViewDelegate

- (void)didClickPayPlanInApartmentRentPayFinishView:(TCApartmentRentPayFinishView *)view {
    [self handleClickPayPlanButton:nil];
}

#pragma mark - Actions

- (void)handleClickPayPlanButton:(id)sender {
    TCRentPlanItemsViewController *vc = [[TCRentPlanItemsViewController alloc] initWithRentPlanItemsType:TCRentPlanItemsTypeCompany];
    vc.companyID = self.companyID;
    vc.companyName = self.companyName;
    vc.rentProtocolID = self.rentProtocolID;
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
