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

#import "TCHomeSearchBarView.h"
#import "TCHomeToolBarView.h"
#import "TCHomeToolsView.h"
#import "TCHomeBannerView.h"
#import "TCHomeCoverView.h"
#import "TCHomeMessageCell.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/UIImage+Category.h>
#import <MJRefresh/MJRefresh.h>
#import <UITableView+FDTemplateLayoutCell.h>

#define toolsViewH     96
#define bannerViewH    (TCRealValue(75) + 7.5)

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
    [self loadData];
    [self registerNotifications];
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
    navBarView.backgroundColor = TCRGBColor(151, 171, 234);
    [self.view addSubview:navBarView];
    self.navBarView = navBarView;
    
    TCHomeSearchBarView *searchBarView = [[TCHomeSearchBarView alloc] initWithFrame:navBarView.frame];
    searchBarView.delegate = self;
    searchBarView.titleLabel.text = @"热门电影：乘风破浪";
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
    [self.view insertSubview:tableView belowSubview:self.toolBarView];
    self.tableView = tableView;
    
    
    MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    refreshFooter.stateLabel.textColor = TCBlackColor;
    refreshFooter.stateLabel.font = [UIFont systemFontOfSize:14];
    refreshFooter.automaticallyHidden = YES;
    [refreshFooter setTitle:@"-我是有底线的-" forState:MJRefreshStateNoMoreData];
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

- (void)loadData {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchHomeMessageWrapperByPullType:TCDataListPullFirstTime count:20 sinceTime:0 result:^(TCHomeMessageWrapper *messageWrapper, NSError *error) {
        @StrongObj(self)
        if (messageWrapper) {
            [MBProgressHUD hideHUD:YES];
            [self.messageArr addObjectsFromArray:messageWrapper.content];
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

- (void)loadNewData {
    @WeakObj(self)
    TCHomeMessage *firstMessage = (TCHomeMessage *)self.messageArr.firstObject;
    [[TCBuluoApi api] fetchHomeMessageWrapperByPullType:TCDataListPullFirstTime count:20 sinceTime:firstMessage.createDate result:^(TCHomeMessageWrapper *messageWrapper, NSError *error) {
        @StrongObj(self)
        [self.tableView.mj_header endRefreshing];
        if (messageWrapper) {
            [self.messageArr insertObjects:messageWrapper.content atIndexes:[NSIndexSet indexSetWithIndex:0]];
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取失败，%@", reason]];
        }
    }];
}

- (void)loadOldData {
    @WeakObj(self)
    TCHomeMessage *lastMessage = (TCHomeMessage *)self.messageArr.lastObject;
    [[TCBuluoApi api] fetchHomeMessageWrapperByPullType:TCDataListPullFirstTime count:20 sinceTime:lastMessage.createDate result:^(TCHomeMessageWrapper *messageWrapper, NSError *error) {
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
    TCHomeMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCHomeMessageCell" forIndexPath:indexPath];
    cell.homeMessage = self.messageArr[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"TCHomeMessageCell" configuration:^(TCHomeMessageCell *cell) {
        cell.homeMessage = self.messageArr[indexPath.row];
    }];
}

#pragma mark - UITableViewDelegate


#pragma mark - TCHomeMessageCellDelegate

- (void)didClickMoreActionBtnWithMessageCell:(UITableViewCell *)cell {
    TCHomeMessageCell *messageCell = (TCHomeMessageCell *)cell;
    CGRect rect = [messageCell convertRect:messageCell.bounds toView:self.tabBarController.view];
    NSLog(@"%@", NSStringFromCGRect(rect));
    self.coverView.rect = rect;
    self.coverView.currentCell = (TCHomeMessageCell *)cell;
    self.coverView.homeMessage = messageCell.homeMessage;
    self.coverView.hidden = NO;
}

#pragma mark - TCHomeCoverViewDelegate

- (void)didClickNeverShowMessage:(TCHomeMessage *)message {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] ignoreAParticularTypeHomeMessageByMessageType:message.messageBody.homeMessageType.homeMessageTypeEnum result:^(BOOL success, NSError *error) {
        @StrongObj(self)
        if (success) {
            self.coverView.hidden = YES;
            [MBProgressHUD showHUDWithMessage:@"忽略成功" afterDelay:0.5];
            [self loadData];
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
            self.coverView.hidden = YES;
            [MBProgressHUD hideHUD:YES];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:self.messageArr];
            [arr removeObject:message];
            self.messageArr = arr;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            NSArray *indexPathArr = [NSArray arrayWithObjects:indexPath, nil];
            [self.tableView deleteRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationFade];
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
    NSLog(@"%s", __func__);
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
    [self.messageArr removeAllObjects];
    [self loadData];
}

- (void)handleUserDidLogout:(NSNotification *)noti {
    [self.messageArr removeAllObjects];
    [self.tableView reloadData];
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
