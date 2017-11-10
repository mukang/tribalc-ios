//
//  TCHomeViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeViewController.h"
#import "TCSearchViewController.h"
#import "TCNavigationController.h"
#import "TCQRCodeViewController.h"
#import "TCMyLockQRCodeController.h"
#import "TCLocksAndVisitorsViewController.h"
#import "TCRepairsViewController.h"
#import "TCWalletBillDetailViewController.h"
#import "TCCreditViewController.h"
#import "TCApartmentViewController.h"
#import "TCCompanyWalletViewController.h"
#import "TCCompanyViewController.h"
#import "TCCompanyApplyViewController.h"
#import "TCApartmentPayViewController.h"
#import "TCCompanyRentPayViewController.h"
#import "TCMeetingRoomConditionsViewController.h"
#import "TCMeetingRoomBookingDetailViewController.h"

#import "TCHomeSearchBarView.h"
#import "TCHomeToolBarView.h"
#import "TCHomeToolsView.h"
#import "TCHomeBannerView.h"
#import "TCHomeCoverView.h"
#import "TCHomeMessageCell.h"
#import "TCHomeMessageSubTitleCell.h"
#import "TCHomeMessageMoneyMiddleCell.h"
#import "TCHomeMessageExtendCreditMiddleCell.h"
#import "TCHomeMessageOnlyMainTitleMiddleCell.h"
#import "TCHomeMessageWelfareCell.h"

#import "TCBuluoApi.h"
#import "TCNotificationNames.h"

#import <TCCommonLibs/UIImage+Category.h>
#import <MJRefresh/MJRefresh.h>
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>


#define toolsViewH     112
#define bannerViewH    (TCRealValue(76.5) + 7.5)

@interface TCHomeViewController ()
<UITableViewDataSource,
UITableViewDelegate,
TCHomeSearchBarViewDelegate,
TCHomeToolBarViewDelegate,
TCHomeToolsViewDelegate,
TCHomeMessageCellDelegate,
TCHomeCoverViewDelegate>

@property (weak, nonatomic) UIView *navBarView;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCHomeSearchBarView *searchBarView;
@property (weak, nonatomic) TCHomeToolBarView *toolBarView;
@property (weak, nonatomic) TCHomeToolsView *toolsView;
@property (weak, nonatomic) TCHomeBannerView *bannerView;


@property (assign, nonatomic) int64_t sinceTime;

@property (strong, nonatomic) TCHomeCoverView *coverView;

@property (strong, nonatomic) NSMutableArray *messageArr;

@end

@implementation TCHomeViewController {
    __weak TCHomeViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavBar];
    [self setupSubviews];
    [self loadDataFirstTime];
    [self registerNotifications];
//    [self loadWeatherData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.bannerView imagePlayerStartPlaying];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.bannerView imagePlayerStopPlaying];
}

- (void)dealloc {
    [self removeNotifications];
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    navBarView.backgroundColor = TCRGBColor(113, 130, 220);
    [self.view addSubview:navBarView];
    self.navBarView = navBarView;
    
    TCHomeSearchBarView *searchBarView = [[TCHomeSearchBarView alloc] initWithFrame:navBarView.frame];
    searchBarView.delegate = self;
    searchBarView.titleLabel.text = @"嗨托邦";
    [self.view addSubview:searchBarView];
    self.searchBarView = searchBarView;
    
    TCHomeToolBarView *toolBarView = [[TCHomeToolBarView alloc] initWithFrame:navBarView.frame];
    toolBarView.delegate = self;
    toolBarView.alpha = 0.0;
    [self.view insertSubview:toolBarView belowSubview:searchBarView];
    self.toolBarView = toolBarView;
}

- (void)setupSubviews {
    CGFloat insetTop = toolsViewH + bannerViewH;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(242, 242, 242);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.clipsToBounds = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(insetTop, 0, 0, 0);
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(insetTop, 0, 0, 0);
    [tableView setContentOffset:CGPointMake(0, -insetTop)];
    [tableView registerClass:[TCHomeMessageCell class] forCellReuseIdentifier:@"TCHomeMessageCell"];
    [tableView registerClass:[TCHomeMessageOnlyMainTitleMiddleCell class] forCellReuseIdentifier:@"TCHomeMessageOnlyMainTitleMiddleCell"];
    [tableView registerClass:[TCHomeMessageSubTitleCell class] forCellReuseIdentifier:@"TCHomeMessageSubTitleCell"];
    [tableView registerClass:[TCHomeMessageExtendCreditMiddleCell class] forCellReuseIdentifier:@"TCHomeMessageExtendCreditMiddleCell"];
    [tableView registerClass:[TCHomeMessageMoneyMiddleCell class] forCellReuseIdentifier:@"TCHomeMessageMoneyMiddleCell"];
    [tableView registerClass:[TCHomeMessageWelfareCell class] forCellReuseIdentifier:@"TCHomeMessageWelfareCell"];
    [self.view insertSubview:tableView belowSubview:self.toolBarView];
    self.tableView = tableView;
    
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    refreshFooter.stateLabel.textColor = TCGrayColor;
    refreshFooter.stateLabel.font = [UIFont systemFontOfSize:14];
    [refreshFooter setTitle:@"-我是有底线的-" forState:MJRefreshStateNoMoreData];
    refreshFooter.hidden = YES;
    tableView.mj_footer = refreshFooter;
    
    MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    refreshHeader.stateLabel.textColor = TCBlackColor;
    refreshHeader.stateLabel.font = [UIFont systemFontOfSize:14];
    refreshHeader.lastUpdatedTimeLabel.textColor = TCBlackColor;
    refreshHeader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    tableView.mj_header = refreshHeader;
    
    TCHomeToolsView *toolsView = [[TCHomeToolsView alloc] init];
    toolsView.frame = CGRectMake(0, -insetTop, TCScreenWidth, toolsViewH);
    toolsView.delegate = self;
    [tableView addSubview:toolsView];
    self.toolsView = toolsView;
    
    TCHomeBannerView *bannerView = [[TCHomeBannerView alloc] initWithFrame:CGRectMake(0, -bannerViewH, TCScreenWidth, bannerViewH)];
    [tableView addSubview:bannerView];
    self.bannerView = bannerView;
    
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navBarView.mas_bottom);
        make.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - Load Data

- (void)loadWeatherData {
    NSArray *weatherArr = [[NSUserDefaults standardUserDefaults] objectForKey:TCBuluoUserLocationCoordinateKey];
    NSString *location;
    if ([weatherArr isKindOfClass:[NSArray class]] && weatherArr.count == 2) {
        location = [NSString stringWithFormat:@"%@:%@",weatherArr[0],weatherArr[1]];
    }else {
        location = @"beijing";
    }
    
    [[TCBuluoApi api] fetchWeatherDataWithLocation:location result:^(NSDictionary *weatherDic, NSError *error) {
        if ([weatherDic isKindOfClass:[NSDictionary class]]) {
            self.bannerView.weatherDic = weatherDic;
        }else {
            
        }
    }];
}

- (void)loadDataFirstTime {
    @WeakObj(self)
    [[TCBuluoApi api] fetchHomeMessageWrapperByPullType:TCDataListPullFirstTime count:20 sinceTime:0 result:^(TCHomeMessageWrapper *messageWrapper, NSError *error) {
        @StrongObj(self)
        [self.tableView.mj_header endRefreshing];
        if (messageWrapper) {
            if (messageWrapper.content.count) {
                self.tableView.mj_footer.hidden = NO;
            }
            if (!messageWrapper.hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.messageArr addObjectsFromArray:messageWrapper.content];
            [self.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

- (void)loadNewData {
    TCHomeMessage *firstMessage = (TCHomeMessage *)self.messageArr.firstObject;
    if (!firstMessage) {
        [self loadDataFirstTime];
        return;
    }
    @WeakObj(self)
    [[TCBuluoApi api] fetchHomeMessageWrapperByPullType:TCDataListPullNewerList count:20 sinceTime:firstMessage.createTime result:^(TCHomeMessageWrapper *messageWrapper, NSError *error) {
        @StrongObj(self)
        [self.tableView.mj_header endRefreshing];
        if (messageWrapper) {
            if ([messageWrapper.content isKindOfClass:[NSArray class]] && messageWrapper.content.count>0) {
                [self.messageArr insertObjects:messageWrapper.content atIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, messageWrapper.content.count)]];
                NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
                for (int i = 0; i < messageWrapper.content.count; i++) {
                    [mutableArr addObject: [NSIndexPath indexPathForRow:i inSection:0]];
                }
                [self.tableView insertRowsAtIndexPaths:mutableArr withRowAnimation:UITableViewRowAnimationRight];
            }
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

- (void)loadOldData {
    @WeakObj(self)
    TCHomeMessage *lastMessage = (TCHomeMessage *)self.messageArr.lastObject;
    [[TCBuluoApi api] fetchHomeMessageWrapperByPullType:TCDataListPullOlderList count:20 sinceTime:lastMessage.createTime result:^(TCHomeMessageWrapper *messageWrapper, NSError *error) {
        @StrongObj(self)
        [self.tableView.mj_footer endRefreshing];
        if (messageWrapper) {
            if (!messageWrapper.hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [self.messageArr addObjectsFromArray:messageWrapper.content];
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TCHomeMessage *message = self.messageArr[indexPath.row];
    TCMessageType type = message.messageBody.homeMessageType.type;
    TCHomeMessageCell *cell;
    if (type == TCMessageTypeAccountWalletPayment || type == TCMessageTypeAccountWalletRecharge || type == TCMessageTypeTenantRecharge || type == TCMessageTypeTenantWithdraw || type == TCMessageTypeCompaniesWalletWithdraw || type == TCMessageTypeAccountWalletWithdraw || type == TCMessageTypeOrderRefund || type == TCMessageTypeWelfarePayment) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TCHomeMessageMoneyMiddleCell" forIndexPath:indexPath];
    }else if (type == TCMessageTypeCreditEnable || type == TCMessageTypeCreditDisable || type == TCMessageTypeCreditBillGeneration || type == TCMessageTypeCreditBillPayment || type == TCMessageTypeCompaniesAdmin) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TCHomeMessageExtendCreditMiddleCell" forIndexPath:indexPath];
    }else if (type == TCMessageTypeCompaniesRentBillPayment || type == TCMessageTypeRentBillPayment || type == TCMessageTypeCompaniesRentBillGeneration || type == TCMessageTypeRentBillGeneration || type == TCMessageTypeConferenceReservation) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TCHomeMessageSubTitleCell" forIndexPath:indexPath];
    }else if (type == TCMessageTypeWelfare) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TCHomeMessageWelfareCell" forIndexPath:indexPath];
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TCHomeMessageOnlyMainTitleMiddleCell" forIndexPath:indexPath];
    }
    cell.homeMessage = message;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TCHomeMessage *message = self.messageArr[indexPath.row];
    TCMessageType type = message.messageBody.homeMessageType.type;
    CGFloat scale = TCScreenWidth > 375.0 ? 3.0 : 2.0;
    CGFloat baseH = 80+4*(1/scale);
    if (type == TCMessageTypeAccountWalletPayment || type == TCMessageTypeAccountWalletRecharge || type == TCMessageTypeTenantRecharge || type == TCMessageTypeTenantWithdraw || type == TCMessageTypeCompaniesWalletWithdraw || type == TCMessageTypeAccountWalletWithdraw || type == TCMessageTypeOrderRefund || type == TCMessageTypeWelfarePayment) {
        return baseH+102;
    }else if (type == TCMessageTypeCreditEnable || type == TCMessageTypeCreditDisable || type == TCMessageTypeCreditBillGeneration || type == TCMessageTypeCreditBillPayment || type == TCMessageTypeCompaniesAdmin) {
        return baseH+102;
    }else if (type == TCMessageTypeCompaniesRentBillPayment || type == TCMessageTypeRentBillPayment || type == TCMessageTypeCompaniesRentBillGeneration || type == TCMessageTypeRentBillGeneration || type == TCMessageTypeConferenceReservation) {
        return baseH+143;
    }else if (type == TCMessageTypeWelfare) {
        return 8+TCRealValue(174);
    }else {
        return baseH+62;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


#pragma mark - TCHomeMessageCellDelegate

- (void)didClickCheckBtnWithHomeMessage:(TCHomeMessage *)message {
    if (!message) {
        return;
    }
    
    if (!message.messageBody.homeMessageType) {
        return;
    }
    
    if (![message.messageBody.homeMessageType.homeMessageTypeEnum isKindOfClass:[NSString class]]) {
        return;
    }
    
    if (message.messageBody.homeMessageType.type == TCMessageTypeOther) {
        return;
    }
    
    TCMessageType type = message.messageBody.homeMessageType.type;
    if (type == TCMessageTypeAccountWalletPayment || type == TCMessageTypeAccountWalletRecharge || type == TCMessageTypeCreditBillPayment || type == TCMessageTypeRentBillPayment || type == TCMessageTypeWelfare || type == TCMessageTypeOrderRefund) {
        // 对账单详情
        [self getbillInfoWithHomeMessage:message];
    }else if (type == TCMessageTypeAccountWalletWithdraw) {
        // 提现记录详情
        [self getbillInfoWithHomeMessage:message];
    }else if (type == TCMessageTypeCreditEnable || type == TCMessageTypeCreditDisable || type == TCMessageTypeCreditBillGeneration) {
        //授信
        [self fetchWalletData];
    }else if (type == TCMessageTypeRentCheckIn) {
        //我的公寓
        [self handleClickApartmentButton];
    }else if (type == TCMessageTypeRentBillGeneration) {
        // 租金账单详情
        [self getRentProtocolWithMessage:message];
    }else if (type == TCMessageTypeCompaniesAdmin) {
        // 我的公司
        [self handleClickCompanyButton];
    }else if (type == TCMessageTypeCompaniesRentBillGeneration) {
        //企业租金账单详情
        [self handleCompanyRentBill];
    }else if (type == TCMessageTypeCompaniesRentBillPayment) {
        //企业对账单详情
        [self getbillInfoWithHomeMessage:message];
    }else if (type == TCMessageTypeCompaniesWalletWithdraw) {
        //企业提现记录详情
        [self getbillInfoWithHomeMessage:message];
    }else if (type == TCMessageTypeConferenceReservation) {
        [self getMeetingRoomReservationDetailWithHomeMessage:message];
    }
    
}

- (void)getMeetingRoomReservationDetailWithHomeMessage:(TCHomeMessage *)message {
    NSString *reservationID = message.messageBody.referenceId;
    TCMeetingRoomBookingDetailViewController *detailVC = [[TCMeetingRoomBookingDetailViewController alloc] init];
    detailVC.reservationID = reservationID;
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.block = ^{
        [self loadNewData];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didClickMoreActionBtnWithMessageCell:(UITableViewCell *)cell {
    TCHomeMessageCell *messageCell = (TCHomeMessageCell *)cell;
    CGRect rect = [messageCell convertRect:messageCell.bounds toView:self.tabBarController.view];
    NSLog(@"%@", NSStringFromCGRect(rect));
    self.coverView.rect = rect;
    self.coverView.currentCell = (TCHomeMessageCell *)cell;
    self.coverView.homeMessage = messageCell.homeMessage;
    self.coverView.hidden = NO;
}

- (void)handleCompanyRentBill {
    TCCompanyRentPayViewController *vc = [[TCCompanyRentPayViewController alloc] init];
    vc.companyID = [[TCBuluoApi api] currentUserSession].userInfo.companyID;
    vc.companyName = [[TCBuluoApi api] currentUserSession].userInfo.companyName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getRentProtocolWithMessage:(TCHomeMessage *)message {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchCurrentRentProtocolBySourceID:message.messageBody.referenceId result:^(TCRentProtocol *rentProtocol, NSError *error) {
        @StrongObj(self)
        if ([rentProtocol isKindOfClass:[TCRentProtocol class]]) {
            TCApartmentPayViewController *vc = [[TCApartmentPayViewController alloc] init];
            vc.rentProtocol = rentProtocol;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

- (void)handleClickCompanyButton {
    TCUserInfo *userInfo = [TCBuluoApi api].currentUserSession.userInfo;
    if ([userInfo.roles containsObject:@"AGENT"]) {
        TCCompanyWalletViewController *vc = [[TCCompanyWalletViewController alloc] init];
        vc.companyID = userInfo.companyID;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (userInfo.companyID) {
            TCCompanyViewController *vc = [[TCCompanyViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            TCCompanyApplyViewController *vc = [[TCCompanyApplyViewController alloc] initWithCompanyApplyStatus:TCCompanyApplyStatusNotApply];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)handleClickApartmentButton {
    TCApartmentViewController *propertyListVc = [[TCApartmentViewController alloc] init];
    propertyListVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:propertyListVc animated:YES];
}

- (void)fetchWalletData {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchWalletAccountInfo:^(TCWalletAccount *walletAccount, NSError *error) {
        @StrongObj(self)
        if (walletAccount) {
            [MBProgressHUD hideHUD:YES];
            TCCreditViewController *creditVC = [[TCCreditViewController alloc] init];
            creditVC.fromController = weakSelf;
            creditVC.hidesBottomBarWhenPushed = YES;
            creditVC.walletAccount = walletAccount;
            [self.navigationController pushViewController:creditVC animated:YES];
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取钱包信息失败！"];
        }
    }];
}

- (void)getbillInfoWithHomeMessage:(TCHomeMessage *)message {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchWalletBillByBillID:message.messageBody.referenceId result:^(TCWalletBill *walletBill, NSError *error) {
        if (walletBill) {
            [MBProgressHUD hideHUD:YES];
            TCWalletBillDetailViewController *walletBillDetailVC = [[TCWalletBillDetailViewController alloc] init];
            walletBillDetailVC.walletBill = walletBill;
            walletBillDetailVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:walletBillDetailVC animated:YES];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

#pragma mark - TCHomeCoverViewDelegate

- (void)didClickNeverShowMessage:(TCHomeMessage *)message {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] ignoreAParticularTypeHomeMessageByMessageType:message.messageBody.homeMessageType.homeMessageTypeEnum result:^(BOOL success, NSError *error) {
        @StrongObj(self)
        if (success) {
            [self tap];
            [MBProgressHUD showHUDWithMessage:@"忽略成功" afterDelay:0.5];
            [self handleReloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

- (void)didClickOverLookMessage:(TCHomeMessage *)message currentCell:(TCHomeMessageCell *)cell{
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] ignoreAHomeMessageByMessageID:message.ID result:^(BOOL success, NSError *error) {
        @StrongObj(self)
        if (success) {
            [self tap];
            [MBProgressHUD hideHUD:YES];
            [self.messageArr removeObject:message];
            if (self.messageArr.count > 3) {
                NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
                NSArray *indexPathArr = [NSArray arrayWithObjects:indexPath, nil];
                [self.tableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
            } else {
                [self.tableView reloadData];
            }
            if (self.messageArr.count == 0) {
                self.tableView.mj_footer.hidden = YES;
            }
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"忽略失败，%@", reason]];
        }
    }];
}

#pragma mark - TCHomeSearchBarViewDelegate

- (void)didClickSearchBarInHomeSearchBarView:(TCHomeSearchBarView *)view {
    [self showSearchViewController];
}

#pragma mark - TCHomeToolBarViewDelegate

- (void)didClickScanButtonInHomeToolBarView:(TCHomeToolBarView *)view {
    [self handleClickScanButton];
}

- (void)didClickUnlockButtonInHomeToolBarView:(TCHomeToolBarView *)view {
    [self handleClickUnlockButton];
}

- (void)didClickMaintainButtonInHomeToolBarView:(TCHomeToolBarView *)view {
    [self handleClickMaintainButton];
}

- (void)didClickSearchButtonInHomeToolBarView:(TCHomeToolBarView *)view {
    [self showSearchViewController];
}

#pragma mark - TCHomeToolsViewDelegate

- (void)didClickScanButtonInHomeToolsView:(TCHomeToolsView *)view {
    [self handleClickScanButton];
}

- (void)didClickUnlockButtonInHomeToolsView:(TCHomeToolsView *)view {
    [self handleClickUnlockButton];
}

- (void)didClickMaintainButtonInHomeToolsView:(TCHomeToolsView *)view {
    [self handleClickMaintainButton];
}

- (void)didClickMeetingButtonInHomeToolsView:(TCHomeToolsView *)view {
    TCMeetingRoomConditionsViewController *vc = [[TCMeetingRoomConditionsViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat maxOffsetY = -bannerViewH;
    CGFloat minOffsetY = -(toolsViewH + bannerViewH);
    
    if ((offsetY < (minOffsetY - 200)) || (offsetY > (maxOffsetY + 200))) {
        return;
    }
    
    if (offsetY >= minOffsetY) {
        self.toolsView.y = minOffsetY + (offsetY - minOffsetY) * 0.4;
        self.bannerView.y = -bannerViewH;
    } else {
        self.toolsView.y = offsetY;
        self.bannerView.y = offsetY + toolsViewH;
    }
    
    CGFloat offsetValue = offsetY - minOffsetY;
    CGFloat toolsViewAlpha = 1 - (offsetValue / (toolsViewH * 0.5));
    if (toolsViewAlpha < 0.0) {
        toolsViewAlpha = 0.0;
    }
    if (toolsViewAlpha > 1.0) {
        toolsViewAlpha = 1.0;
    }
    self.toolsView.containerView.alpha = toolsViewAlpha;
    
    CGFloat searchBarAlpha = 1 - (offsetValue / (toolsViewH * 0.3));
    if (searchBarAlpha < 0.0) {
        searchBarAlpha = 0.0;
    }
    if (searchBarAlpha > 1.0) {
        searchBarAlpha = 1.0;
    }
    self.searchBarView.alpha = searchBarAlpha;
    
    CGFloat toolBarAlpha = (offsetValue - toolsViewH * 0.3) / (toolsViewH * 0.6);
    if (toolBarAlpha < 0.0) {
        toolBarAlpha = 0.0;
    }
    if (toolBarAlpha > 1.0) {
        toolBarAlpha = 1.0;
    }
    self.toolBarView.alpha = toolBarAlpha;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGFloat maxOffsetY = -bannerViewH;
    CGFloat minOffsetY = -(toolsViewH + bannerViewH);
    CGFloat targetOffsetX = targetContentOffset->x;
    CGFloat targetOffsetY = targetContentOffset->y;
    
    if (targetOffsetY <= minOffsetY || targetOffsetY >= maxOffsetY) {
        return;
    }
    
    CGFloat slidingH = scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom;
    CGFloat visualH = TCScreenHeight - 64 - 49;
    CGFloat invalidL = slidingH - visualH;
    if (invalidL >= 0 && invalidL <= toolsViewH) {
        return;
    }
    
    CGFloat conditionOffsetY = -(toolsViewH * 0.5 + bannerViewH);
    if (targetOffsetY >= conditionOffsetY) {
        *targetContentOffset = CGPointMake(targetOffsetX, maxOffsetY);
    } else {
        *targetContentOffset = CGPointMake(targetOffsetX, minOffsetY);
    }
}

#pragma mark - CoverView

- (void)tap {
    self.coverView.hidden = YES;
    self.coverView.homeMessage = nil;
    [self.coverView removeFromSuperview];
    self.coverView = nil;
}


- (TCHomeCoverView *)coverView {
    if (_coverView == nil) {
        _coverView = [[TCHomeCoverView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, TCScreenHeight)];
        _coverView.hidden = YES;
        _coverView.delegate = self;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [_coverView addGestureRecognizer:tapG];
        [self.tabBarController.view addSubview:_coverView];
    }
    return _coverView;
}

#pragma mark - Notification

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserDidLogin:)
                                                 name:TCBuluoApiNotificationUserDidLogin
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUserDidLogout:)
                                                 name:TCBuluoApiNotificationUserDidLogout
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadNewData)
                                                 name:TCNotificationHomePageNeedRefreshData
                                               object:nil];
    
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)showSearchViewController {
    TCSearchViewController *vc = [[TCSearchViewController alloc] init];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
}

- (void)handleClickScanButton {
    
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusRestricted) { // 因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
        [MBProgressHUD showHUDWithMessage:@"因为系统原因, 无法访问相册" afterDelay:1.0];
    } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册(用户当初点击了"不允许")
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您还没允许海托邦商户版访问相机" preferredStyle:UIAlertControllerStyleAlert];
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
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickUnlockButton {
    TCUserInfo *userInfo = [[TCBuluoApi api] currentUserSession].userInfo;
    if (![userInfo.authorizedStatus isEqualToString:@"SUCCESS"]) {
        [MBProgressHUD showHUDWithMessage:@"身份认证成功后才可使用开门功能"];
        return;
    }
    if (!userInfo.companyID) {
        [MBProgressHUD showHUDWithMessage:@"绑定公司成功后才可使用开门功能"];
        return;
    }
    
    TCVisitorInfo *visitorInfo = [[TCVisitorInfo alloc] init];
    visitorInfo.equipIds = [NSArray array];
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchMultiLockKeyWithVisitorInfo:visitorInfo result:^(TCMultiLockKey *multiLockKey, BOOL hasTooManyLocks, NSError *error) {
        if (multiLockKey) {
            [MBProgressHUD hideHUD:YES];
            TCMyLockQRCodeController *vc = [[TCMyLockQRCodeController alloc] initWithLockQRCodeType:TCQRCodeTypeSystem];
            vc.multiLockKey = multiLockKey;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (hasTooManyLocks) {
            [MBProgressHUD hideHUD:YES];
            TCLocksAndVisitorsViewController *lockAndVisitorVC = [[TCLocksAndVisitorsViewController alloc] initWithType:TCLocks];
            lockAndVisitorVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lockAndVisitorVC animated:YES];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"开门失败，%@", reason]];
        }
    }];
}

- (void)handleClickMaintainButton {
    TCRepairsViewController *vc = [[TCRepairsViewController alloc] initWithNibName:@"TCRepairsViewController" bundle:[NSBundle mainBundle]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleUserDidLogin:(NSNotification *)noti {
    [self handleReloadData];
}

- (void)handleUserDidLogout:(NSNotification *)noti {
    [self.messageArr removeAllObjects];
    self.tableView.mj_footer.hidden = YES;
    [self.tableView reloadData];
}

- (void)handleReloadData {
    [self.messageArr removeAllObjects];
    self.tableView.mj_footer.hidden = YES;
    [self.tableView reloadData];
    [self loadDataFirstTime];
}

#pragma mark - Override Methods

- (NSMutableArray *)messageArr {
    if (_messageArr == nil) {
        _messageArr = [NSMutableArray array];
    }
    return _messageArr;
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
