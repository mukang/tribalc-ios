//
//  TCProfileViewController.m
//  individual
//
//  Created by 穆康 on 2017/8/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCProfileViewController.h"
#import "TCLoginViewController.h"
#import "TCBiographyViewController.h"
#import "TCWalletViewController.h"
#import "TCIDAuthViewController.h"
#import "TCIDAuthDetailViewController.h"
#import "TCCompanyViewController.h"
#import "TCCompanyApplyViewController.h"
#import "TCSettingViewController.h"
#import "TCUserReserveViewController.h"
#import "TCPropertyManageListController.h"
#import "TCQRCodeViewController.h"
#import "TCNavigationController.h"
#import "TCOrderViewController.h"
#import "TCSignInHistoryViewController.h"
#import "TCCompanyWalletViewController.h"
#import "TCApartmentViewController.h"

#import "TCProfileHeaderView.h"
#import "TCProfileViewCell.h"
#import "TCNavigationBar.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/UIImage+Category.h>
#import<AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

#define headerViewH TCRealValue(229)
#define footerViewH TCRealValue(167)
#define navBarH     64.0

@interface TCProfileViewController () <UITableViewDataSource, UITableViewDelegate, TCProfileHeaderViewDelegate, TCProfileViewCellDelegate>

@property (weak, nonatomic) TCNavigationBar *navBar;
@property (weak, nonatomic) UINavigationItem *navItem;

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCProfileHeaderView *headerView;
@property (strong, nonatomic) UIView *footerView;

@property (copy, nonatomic) NSArray *materialsArray;

@property (copy, nonatomic) NSDictionary *unreadMessageNumDic;

@end

@implementation TCProfileViewController {
    __weak TCProfileViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
    [self updateNavigationBarWithAlpha:0.0];
    [self registerNotifications];
    [self reloadUserData];
    [self loadUnReadPushNumber];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    [self removeNotifications];
}

#pragma mark - Private Methods

- (void)subtractUnreadNum:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSNumber *num = dic[@"unreadNum"];
        NSString *type = dic[@"type"];
        if ([num isKindOfClass:[NSNumber class]] && [type isKindOfClass:[NSString class]]) {
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:self.unreadMessageNumDic];
            NSDictionary *messageTypeCountDic = self.unreadMessageNumDic[@"messageTypeCount"];
            if ([messageTypeCountDic isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *mutableMessageTypeCountDic = [NSMutableDictionary dictionaryWithDictionary:messageTypeCountDic];
                [mutableMessageTypeCountDic setObject:@0 forKey:type];
                mutableDic[@"messageTypeCount"] = mutableMessageTypeCountDic;
                self.unreadMessageNumDic = mutableDic;
            }
        }
    }
}

- (void)setUnreadMessageNumDic:(NSDictionary *)unreadMessageNumDic {
    _unreadMessageNumDic = unreadMessageNumDic;
    
    [self.tableView reloadData];
}

- (void)loadUnReadPushNumber {
    if (![[TCBuluoApi api] needLogin]) {
        [[TCBuluoApi api] fetchUnReadPushMessageNumberWithResult:^(NSDictionary *unreadNumDic, NSError *error) {
            if ([unreadNumDic isKindOfClass:[NSDictionary class]]) {
                weakSelf.unreadMessageNumDic = unreadNumDic;
            }
        }];
    }
}

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    TCNavigationBar *navBar = [[TCNavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, navBarH)];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile_nav_setting_item_white"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(handleClickSettingButton:)];
    navItem.rightBarButtonItem = settingItem;
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(239, 244, 245);
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[TCProfileViewCell class] forCellReuseIdentifier:@"TCProfileViewCell"];
    tableView.contentInset = UIEdgeInsetsMake(headerViewH, 0, 0, 0);
    [tableView setContentOffset:CGPointMake(0, -headerViewH) animated:NO];
    [self.view insertSubview:tableView belowSubview:self.navBar];
    self.tableView = tableView;
    
    TCProfileHeaderView *headerView = [[TCProfileHeaderView alloc] init];
    headerView.delegate = self;
    [tableView addSubview:headerView];
    self.headerView = headerView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(tableView);
        make.top.equalTo(tableView).offset(-headerViewH);
        make.height.mas_equalTo(headerViewH);
    }];
}

- (void)reloadUserData {
    self.navItem.title = [[TCBuluoApi api] currentUserSession].userInfo.nickname;
    [self.headerView reloadData];
}

- (void)updateHeaderView {
    CGFloat offsetY = self.tableView.contentOffset.y;
    if (offsetY > 0) return;
    if (offsetY > -headerViewH) {
        offsetY = -headerViewH;
    }
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView).offset(offsetY);
        make.height.mas_equalTo(-offsetY);
    }];
}

#pragma mark - Navigation Bar

- (void)updateNavigationBar {
    CGFloat minOffsetY = -headerViewH;
    CGFloat offsetY = self.tableView.contentOffset.y;
    CGFloat alpha = (offsetY - minOffsetY) / (headerViewH - navBarH);
    if (alpha > 1.0) alpha = 1.0;
    if (alpha < 0.0) alpha = 0.0;
    [self updateNavigationBarWithAlpha:alpha];
}

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha {
    UIColor *tintColor = nil;
    UIColor *titleColor = nil;
    if (alpha > 0.7) {
        tintColor = TCBlackColor;
        titleColor = TCBlackColor;
    } else {
        tintColor = [UIColor whiteColor];
        titleColor = [UIColor clearColor];
    }
    [self.navBar setTintColor:tintColor];
    self.navBar.titleTextAttributes = @{
                                        NSFontAttributeName : [UIFont systemFontOfSize:16],
                                        NSForegroundColorAttributeName : titleColor
                                        };
    
    UIImage *bgImage = [UIImage imageWithColor:[UIColor colorWithWhite:1.0 alpha:alpha]];
    UIImage *shadowImage = [UIImage imageWithColor:TCARGBColor(221, 221, 221, alpha)];
    [self.navBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    [self.navBar setShadowImage:shadowImage];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.materialsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCProfileViewCell" forIndexPath:indexPath];
    cell.materials = self.materialsArray[indexPath.row];
    cell.delegate = self;
    if (indexPath.row == 0) {
        cell.unReadNumDic = self.unreadMessageNumDic;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TCRealValue(106);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TCRealValue(7.5);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return footerViewH;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return self.footerView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
    [self updateNavigationBar];
}

#pragma mark - TCProfileHeaderViewDelegate

- (void)didClickAvatarViewInProfileHeaderView:(TCProfileHeaderView *)view {
    [self handleClickAvatarView];
}

#pragma mark - TCProfileViewCellDelegate

- (void)profileViewCell:(TCProfileViewCell *)cell didClickFeatureButtonWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == 0) {
        switch (index) {
            case 0:
                [self handleClickWalletButton];
                break;
            case 1:
                [self handleClickScanButton];
                break;
            case 2:
                [self handleClickOrderButton];
                break;
            case 3:
                [self handleClickSigninButton];
                break;
                
            default:
                break;
        }
    } else if (indexPath.row == 1) {
        switch (index) {
            case 0:
                [self handleClickIdentityButton];
                break;
            case 1:
                [self handleClickCompanyButton];
                break;
            case 2:
                [self handleClickApartmentButton];
                break;
            case 3:
                [self handleClickActivityButton];
                break;
                
            default:
                break;
        }
    } else {
        [self handleClickRepairsButton];
    }
}

#pragma mark - Actions

- (void)handleClickSettingButton:(UIBarButtonItem *)sender {
    TCSettingViewController *vc = [[TCSettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickAvatarView {
    TCBiographyViewController *vc = [[TCBiographyViewController alloc] init];
    vc.bioEditBlock = ^() {
        [weakSelf reloadUserData];
    };
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickWalletButton {
    TCUserInfo *userInfo = [[TCBuluoApi api] currentUserSession].userInfo;
    if ([userInfo.authorizedStatus isEqualToString:@"SUCCESS"]) {
        TCWalletViewController *vc = [[TCWalletViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"
                                                                                 message:@"未进行身份认证，暂不能使用“钱包”功能"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *authAction = [UIAlertAction actionWithTitle:@"身份认证"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               TCIDAuthViewController *vc = [[TCIDAuthViewController alloc] initWithNibName:@"TCIDAuthViewController" bundle:[NSBundle mainBundle]];
                                                               vc.hidesBottomBarWhenPushed = YES;
                                                               [weakSelf.navigationController pushViewController:vc animated:YES];
                                                           }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:authAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
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

- (void)setUpUnreadMessageNumber:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    if ([dic isKindOfClass:[NSDictionary class]]) {
        self.unreadMessageNumDic = dic;
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


- (void)handleClickSigninButton {
    TCSignInHistoryViewController *signInHistoryVc = [[TCSignInHistoryViewController alloc] init];
    signInHistoryVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signInHistoryVc animated:YES];
}

- (void)handleClickOrderButton {
    TCOrderViewController *vc = [[TCOrderViewController alloc] initWithGoodsOrderStatus:TCGoodsOrderStatusAll];
    vc.fromController = self;
    vc.unreadNumDic = self.unreadMessageNumDic;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickRepairsButton {
    TCPropertyManageListController *propertyListVc = [[TCPropertyManageListController alloc] init];
    propertyListVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:propertyListVc animated:YES];
}

- (void)handleClickIdentityButton {
    TCUserInfo *userInfo = [[TCBuluoApi api] currentUserSession].userInfo;
    UIViewController *currentVC;
    if ([userInfo.authorizedStatus isEqualToString:@"PROCESSING"]) {
        TCIDAuthDetailViewController *vc = [[TCIDAuthDetailViewController alloc] initWithIDAuthStatus:TCIDAuthStatusProcessing];
        currentVC = vc;
    } else if ([userInfo.authorizedStatus isEqualToString:@"SUCCESS"] || [userInfo.authorizedStatus isEqualToString:@"FAILURE"]) {
        TCIDAuthDetailViewController *vc = [[TCIDAuthDetailViewController alloc] initWithIDAuthStatus:TCIDAuthStatusFinished];
        currentVC = vc;
    } else {
        TCIDAuthViewController *vc = [[TCIDAuthViewController alloc] initWithNibName:@"TCIDAuthViewController" bundle:[NSBundle mainBundle]];
        currentVC = vc;
    }
    currentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:currentVC animated:YES];
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

- (void)handleClickActivityButton {
    [self btnClickUnifyTips];
}

- (void)handleUserDidLogin:(id)sender {
    [self reloadUserData];
    [self loadUnReadPushNumber];
}

- (void)handleUserDidLogout:(id)sender {
    [self reloadUserData];
}

- (void)handleUserInfoDidUpdate:(id)sender {
    [self reloadUserData];
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserDidLogin:) name:TCBuluoApiNotificationUserDidLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserDidLogout:) name:TCBuluoApiNotificationUserDidLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoDidUpdate:) name:TCBuluoApiNotificationUserInfoDidUpdate object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subtractUnreadNum:) name:@"TCSubtractCurrentUnReadNum" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUpUnreadMessageNumber:) name:@"TCFetchUnReadMessageNumber" object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Override Methods

- (UIView *)footerView {
    if (_footerView == nil) {
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, footerViewH)];
        containerView.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile_bottom_image"]];
        [containerView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(containerView);
        }];
        
        _footerView = containerView;
    }
    return _footerView;
}

- (NSArray *)materialsArray {
    if (_materialsArray == nil) {
        _materialsArray = @[
                            @[
                                @{@"title": @"钱包", @"imageName": @"profile_wallet_icon"},
                                @{@"title": @"付款", @"imageName": @"profile_scan_icon"},
                                @{@"title": @"订单", @"imageName": @"profile_order_icon"},
                                @{@"title": @"签到", @"imageName": @"profile_signin_icon"}
                              ],
                            @[
                                @{@"title": @"身份认证", @"imageName": @"profile_identity_icon"},
                                @{@"title": @"我的公司", @"imageName": @"profile_company_icon"},
                                @{@"title": @"我的公寓", @"imageName": @"profile_apartment_icon"},
                                @{@"title": @"活动", @"imageName": @"profile_activity_icon"}
                              ],
                            @[
                                @{@"title": @"报修", @"imageName": @"profile_repairs_icon"}
                              ]
                            ];
    }
    return _materialsArray;
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
