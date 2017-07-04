//
//  TCApartmentPayViewController.m
//  individual
//
//  Created by 穆康 on 2017/6/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCApartmentPayViewController.h"
#import "TCPaymentViewController.h"
#import "TCApartmentRentPaySuccessViewController.h"
#import "TCApartmentAddWithholdViewController.h"
#import "TCRentPlanItemsViewController.h"

#import "TCApartmentPayTabView.h"
#import "TCApartmentRentPayDetailView.h"
#import "TCApartmentRentPayFinishView.h"
#import "TCApartmentGuideWithholdView.h"
#import "TCApartmentWithholdInfoView.h"

#import <TCCommonLibs/TCExtendButton.h>

#import "TCBuluoApi.h"

@interface TCApartmentPayViewController ()
<TCApartmentPayTabViewDelegate,
TCApartmentRentPayDetailViewDelegate,
TCApartmentWithholdInfoViewDelegate,
TCApartmentRentPayFinishViewDelegate,
TCPaymentViewControllerDelegate>

@property (nonatomic) TCApartmentPayType payType;
@property (strong, nonatomic) TCRentPlanItem *rentPlanItem;
@property (strong, nonatomic) TCRentProtocolWithholdInfo *withholdInfo;

@property (weak, nonatomic) TCApartmentPayTabView *tabView;
@property (weak, nonatomic) UIView *rentPayContainerView;
@property (weak, nonatomic) UIView *lifePayContainerView;

@property (weak, nonatomic) TCApartmentRentPayDetailView *rentPayDetailView;
@property (weak, nonatomic) TCApartmentGuideWithholdView *guideWithholdView;
@property (weak, nonatomic) TCApartmentWithholdInfoView *withholdInfoView;
@property (weak, nonatomic) TCExtendButton *payPlanButton;
@property (weak, nonatomic) TCApartmentRentPayFinishView *payFinishView;

@end

@implementation TCApartmentPayViewController {
    __weak TCApartmentPayViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"缴费";
    self.view.backgroundColor = TCBackgroundColor;
    
    [self setupSubviews];
    [self.tabView clickApartmentPayTabWithType:TCApartmentPayTypeRent];
    [self loadRentPlanItems];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    TCApartmentPayTabView *tabView = [[TCApartmentPayTabView alloc] init];
    tabView.delegate = self;
    [self.view addSubview:tabView];
    self.tabView = tabView;
    
    UIView *rentPayContainerView = [[UIView alloc] init];
    rentPayContainerView.backgroundColor = TCBackgroundColor;
    [self.view addSubview:rentPayContainerView];
    self.rentPayContainerView = rentPayContainerView;
    
    UIView *lifePayContainerView = [[UIView alloc] init];
    lifePayContainerView.backgroundColor = TCBackgroundColor;
    [self.view addSubview:lifePayContainerView];
    self.lifePayContainerView = lifePayContainerView;
    
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(TCRealValue(41));
    }];
    [rentPayContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tabView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    [lifePayContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tabView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
    
    [self setupRentPayContainerView];
    [self setupLifePayContainerView];
}

- (void)setupRentPayContainerView {
    TCApartmentRentPayDetailView *rentPayDetailView = [[TCApartmentRentPayDetailView alloc] init];
    rentPayDetailView.delegate = self;
    rentPayDetailView.hidden = YES;
    [self.rentPayContainerView addSubview:rentPayDetailView];
    self.rentPayDetailView = rentPayDetailView;
    
    TCApartmentGuideWithholdView *guideWithholdView = [[TCApartmentGuideWithholdView alloc] init];
    guideWithholdView.hidden = YES;
    [self.rentPayContainerView addSubview:guideWithholdView];
    self.guideWithholdView = guideWithholdView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGuideWithholdView)];
    [guideWithholdView addGestureRecognizer:tap];
    
    TCApartmentWithholdInfoView *withholdInfoView = [[TCApartmentWithholdInfoView alloc] init];
    withholdInfoView.hidden = YES;
    withholdInfoView.delegate = self;
    [self.rentPayContainerView addSubview:withholdInfoView];
    self.withholdInfoView = withholdInfoView;
    
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
    [self.rentPayContainerView addSubview:payPlanButton];
    self.payPlanButton = payPlanButton;
    
    TCApartmentRentPayFinishView *payFinishView = [[TCApartmentRentPayFinishView alloc] init];
    payFinishView.hidden = YES;
    payFinishView.delegate = self;
    [self.rentPayContainerView addSubview:payFinishView];
    self.payFinishView = payFinishView;
    
    [rentPayDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabView.mas_bottom).offset(TCRealValue(8));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(TCRealValue(309));
    }];
    [guideWithholdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rentPayDetailView.mas_bottom).offset(TCRealValue(8));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(TCRealValue(45));
    }];
    [withholdInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.guideWithholdView.mas_bottom).offset(TCRealValue(8));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(TCRealValue(169));
    }];
    [payFinishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabView.mas_bottom).offset(TCRealValue(8));
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)setupLifePayContainerView {
    
}

- (void)showRentPlanItemsFinishView {
    self.rentPayDetailView.hidden = YES;
    self.guideWithholdView.hidden = YES;
    self.withholdInfoView.hidden = YES;
    self.payPlanButton.hidden = YES;
    self.payFinishView.hidden = NO;
    [self.rentPayContainerView layoutIfNeeded];
}

- (void)reloadRentPayContainerView {
    if (!self.rentPlanItem) return;
    
    self.payFinishView.hidden = YES;
    self.rentPayDetailView.hidden = NO;
    self.rentPayDetailView.rentProtocol = self.rentProtocol;
    self.rentPayDetailView.planItem = self.rentPlanItem;
    self.payPlanButton.hidden = NO;
    if (self.withholdInfo) {
        self.withholdInfoView.hidden = NO;
        self.withholdInfoView.withholdInfo = self.withholdInfo;
        self.guideWithholdView.hidden = YES;
        [self.payPlanButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.withholdInfoView.mas_bottom).offset(TCRealValue(18));
        }];
    } else {
        self.guideWithholdView.hidden = NO;
        self.withholdInfoView.hidden = YES;
        [self.payPlanButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.guideWithholdView.mas_bottom).offset(TCRealValue(18));
        }];
    }
    [self.rentPayContainerView layoutIfNeeded];
}

- (void)reloadLifePayContainerView {
    
}

- (void)analysizeRentPlanItems:(NSArray *)rentPlanItems {
    TCRentPlanItem *lastPlanItem = [rentPlanItems lastObject];
    if (lastPlanItem.finished) {
        [MBProgressHUD hideHUD:YES];
        [self showRentPlanItemsFinishView];
        return;
    }
    
    lastPlanItem = nil;
    for (int i=0; i<rentPlanItems.count; i++) {
        TCRentPlanItem *planItem = rentPlanItems[i];
        if (planItem.finished == NO && (lastPlanItem.finished || !lastPlanItem)) {
            planItem.itemNum = i;
            planItem.currentItem = YES;
            self.rentPlanItem = planItem;
            break;
        }
        lastPlanItem = planItem;
    }
    [self loadRentPayProtocolWithhold];
}

#pragma mark - Net Request

- (void)loadRentPlanItems {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchRentPlanItemListByRentProtocolID:self.rentProtocol.ID result:^(NSArray *rentPlanItemList, NSError *error) {
        if (rentPlanItemList) {
            [weakSelf analysizeRentPlanItems:rentPlanItemList];
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

- (void)loadRentPayProtocolWithhold {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchRentProtocolWithholdInfoByRentProtocolID:self.rentProtocol.ID result:^(TCRentProtocolWithholdInfo *withholdInfo, NSError *error) {
        if (error) {
            NSString *reason = error.localizedDescription ?: @"请退出重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        } else {
            [MBProgressHUD hideHUD:YES];
            weakSelf.withholdInfo = withholdInfo;
            [weakSelf reloadRentPayContainerView];
        }
    }];
}

#pragma mark - TCApartmentPayTabViewDelegate

- (void)apartmentPayTabView:(TCApartmentPayTabView *)view didClickTabWithType:(TCApartmentPayType)type {
    self.payType = type;
    if (type == TCApartmentPayTypeRent) {
        self.rentPayContainerView.hidden = NO;
        self.lifePayContainerView.hidden = YES;
        [self.view bringSubviewToFront:self.rentPayContainerView];
    } else {
        self.rentPayContainerView.hidden = YES;
        self.lifePayContainerView.hidden = NO;
        [self.view bringSubviewToFront:self.lifePayContainerView];
    }
}

#pragma mark - TCApartmentRentPayDetailViewDelegate

- (void)didClickPayButtonInApartmentRentPayDetailView:(TCApartmentRentPayDetailView *)view {
    TCPaymentViewController *vc = [[TCPaymentViewController alloc] initWithTotalFee:self.rentProtocol.monthlyRent
                                                                         payPurpose:TCPayPurposeRent
                                                                     fromController:self];
    vc.targetID = self.rentProtocol.ID;
    vc.delegate = self;
    [vc show:YES];
}

#pragma mark - TCApartmentWithholdInfoViewDelegate

- (void)didClickEditButtonInApartmentWithholdInfoView:(TCApartmentWithholdInfoView *)view {
    [self showAddWithholeViewControllerWithWithholdInfo:self.withholdInfo];
}

#pragma mark - TCApartmentRentPayFinishViewDelegate

- (void)didClickPayPlanInApartmentRentPayFinishView:(TCApartmentRentPayFinishView *)view {
    TCRentPlanItemsViewController *vc = [[TCRentPlanItemsViewController alloc] init];
    vc.rentProtocol = self.rentProtocol;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TCPaymentViewControllerDelegate

- (void)paymentViewController:(TCPaymentViewController *)controller didFinishedPaymentWithPayment:(TCUserPayment *)payment {
    TCApartmentRentPaySuccessViewController *vc = [[TCApartmentRentPaySuccessViewController alloc] init];
    vc.itemNum = self.rentPlanItem.itemNum;
    vc.rentProtocol = self.rentProtocol;
    vc.paySuccess = ^{
        [weakSelf loadRentPlanItems];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (void)handleClickPayPlanButton:(id)sender {
    TCRentPlanItemsViewController *vc = [[TCRentPlanItemsViewController alloc] init];
    vc.rentProtocol = self.rentProtocol;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleTapGuideWithholdView {
    [self showAddWithholeViewControllerWithWithholdInfo:nil];
}

- (void)showAddWithholeViewControllerWithWithholdInfo:(TCRentProtocolWithholdInfo *)withholdInfo {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchBFSupportedBankListByType:TCBFSupportedBankTypeWithhold result:^(NSArray *bankCardList, NSError *error) {
        if (bankCardList) {
            [MBProgressHUD hideHUD:YES];
            TCApartmentAddWithholdViewController *vc = [[TCApartmentAddWithholdViewController alloc] init];
            vc.isEdit = withholdInfo ? NO : YES;
            vc.withholdInfo = withholdInfo;
            vc.banks = bankCardList;
            vc.addWithholdSuccess = ^{
                [weakSelf loadRentPayProtocolWithhold];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
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
