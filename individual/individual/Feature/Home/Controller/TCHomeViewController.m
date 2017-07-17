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

#import "TCHomeSearchBarView.h"
#import "TCHomeToolBarView.h"
#import "TCHomeToolsView.h"
#import "TCHomeBannerView.h"

#import <TCCommonLibs/UIImage+Category.h>

#define toolsViewH     96
#define bannerViewH    (TCRealValue(75) + 7.5)

@interface TCHomeViewController ()
<UITableViewDataSource,
UITableViewDelegate,
TCHomeSearchBarViewDelegate,
TCHomeToolBarViewDelegate,
TCHomeToolsViewDelegate>

@property (weak, nonatomic) UIView *navBarView;
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCHomeSearchBarView *searchBarView;
@property (weak, nonatomic) TCHomeToolBarView *toolBarView;
@property (weak, nonatomic) TCHomeToolsView *toolsView;
@property (weak, nonatomic) TCHomeBannerView *bannerView;

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.bannerView imagePlayerStartPlaying];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.bannerView imagePlayerStopPlaying];
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
    tableView.contentInset = UIEdgeInsetsMake(insetTop, 0, 0, 0);
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(insetTop, 0, 0, 0);
    [tableView setContentOffset:CGPointMake(0, -insetTop)];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view insertSubview:tableView belowSubview:self.toolBarView];
    self.tableView = tableView;
    
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = TCRandomColor;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - TCHomeSearchBarViewDelegate

- (void)didClickSearchBarInHomeSearchBarView:(TCHomeSearchBarView *)view {
    NSLog(@"%s", __func__);
    [self showSearchViewController];
}

#pragma mark - TCHomeToolBarViewDelegate

- (void)didClickScanButtonInHomeToolBarView:(TCHomeToolBarView *)view {
    NSLog(@"%s", __func__);
}

- (void)didClickUnlockButtonInHomeToolBarView:(TCHomeToolBarView *)view {
    NSLog(@"%s", __func__);
}

- (void)didClickMaintainButtonInHomeToolBarView:(TCHomeToolBarView *)view {
    NSLog(@"%s", __func__);
}

- (void)didClickSearchButtonInHomeToolBarView:(TCHomeToolBarView *)view {
    NSLog(@"%s", __func__);
    [self showSearchViewController];
}

#pragma mark - TCHomeToolsViewDelegate

- (void)didClickScanButtonInHomeToolsView:(TCHomeToolsView *)view {
    NSLog(@"%s", __func__);
}

- (void)didClickUnlockButtonInHomeToolsView:(TCHomeToolsView *)view {
    NSLog(@"%s", __func__);
}

- (void)didClickMaintainButtonInHomeToolsView:(TCHomeToolsView *)view {
    NSLog(@"%s", __func__);
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

#pragma mark - Actions

- (void)showSearchViewController {
    TCSearchViewController *vc = [[TCSearchViewController alloc] init];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:NO completion:nil];
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
