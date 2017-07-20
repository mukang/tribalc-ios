//
//  TCStoreDetailViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreDetailViewController.h"

#import "TCStoreHeaderView.h"
#import "TCStoreDescViewCell.h"
#import "TCStoreTagsViewCell.h"
#import "TCStorePrivilegeViewCell.h"
#import "TCStorePayViewCell.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/UIImage+Category.h>
#import <UITableView+FDTemplateLayoutCell.h>

#define headerViewH TCRealValue(252)
#define navBarH     64.0

@interface TCStoreDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TCStorePayViewCellDelegate>

@property (weak, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) UINavigationItem *navItem;

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCStoreHeaderView *headerView;

@property (strong, nonatomic) TCListStore *storeInfo;

@end

@implementation TCStoreDetailViewController {
    __weak TCStoreDetailViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
    [self loadNetData];
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, navBarH)];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    UIImage *backImage = [[UIImage imageNamed:@"nav_back_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickBackButton:)];
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
    
    [self updateNavigationBarWithAlpha:0.0];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(headerViewH, 0, 0, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCStoreDescViewCell class] forCellReuseIdentifier:@"TCStoreDescViewCell"];
    [tableView registerClass:[TCStoreTagsViewCell class] forCellReuseIdentifier:@"TCStoreTagsViewCell"];
    [tableView registerClass:[TCStorePrivilegeViewCell class] forCellReuseIdentifier:@"TCStorePrivilegeViewCell"];
    [tableView registerClass:[TCStorePayViewCell class] forCellReuseIdentifier:@"TCStorePayViewCell"];
    [self.tableView setContentOffset:CGPointMake(0, -headerViewH) animated:NO];
    [self.view insertSubview:tableView belowSubview:self.navBar];
    self.tableView = tableView;
    
    TCStoreHeaderView *headerView = [[TCStoreHeaderView alloc] init];
    [self.tableView addSubview:headerView];
    self.headerView = headerView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);
    }];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(tableView);
        make.top.equalTo(tableView).offset(-headerViewH);
        make.height.mas_equalTo(headerViewH);
    }];
}

- (void)loadNetData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchStoreInfoByStoreID:self.storeID result:^(TCListStore *storeInfo, NSError *error) {
        if (storeInfo) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.navItem.title = storeInfo.name;
            weakSelf.storeInfo = storeInfo;
            weakSelf.headerView.pictures = storeInfo.pictures;
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出该页面重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

- (void)updateHeaderView {
    CGFloat offsetY = self.tableView.contentOffset.y;
    if (offsetY > 0) return;
    if (offsetY > -headerViewH) {
        offsetY = -headerViewH;
    }
    
    [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableView).offset(offsetY);
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
    UIColor *titleColor = nil;
    if (alpha > 0.7) {
        titleColor = TCBlackColor;
    } else {
        titleColor = [UIColor clearColor];
    }
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
    if (self.storeInfo) {
        return 1;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    switch (indexPath.row) {
        case 0:
        {
            TCStoreDescViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreDescViewCell" forIndexPath:indexPath];
            cell.storeInfo = self.storeInfo;
            currentCell = cell;
        }
            break;
        case 1:
        {
            TCStoreTagsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreTagsViewCell" forIndexPath:indexPath];
            cell.sellingPoint = self.storeInfo.sellingPoint;
            currentCell = cell;
        }
            break;
        case 2:
        {
            TCStorePrivilegeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStorePrivilegeViewCell" forIndexPath:indexPath];
            cell.storeInfo = self.storeInfo;
            currentCell = cell;
        }
            break;
        case 3:
        {
            TCStorePayViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStorePayViewCell" forIndexPath:indexPath];
            cell.delegate = self;
            currentCell = cell;
        }
            break;
            
        default:
            break;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
        {
            height = [tableView fd_heightForCellWithIdentifier:@"TCStoreDescViewCell"
                                              cacheByIndexPath:indexPath
                                                 configuration:^(TCStoreDescViewCell *cell) {
                                                     cell.storeInfo = weakSelf.storeInfo;
                                                 }];
        }
            break;
        case 1:
        {
            height = [tableView fd_heightForCellWithIdentifier:@"TCStoreTagsViewCell"
                                              cacheByIndexPath:indexPath
                                                 configuration:^(TCStoreTagsViewCell *cell) {
                                                     cell.sellingPoint = weakSelf.storeInfo.sellingPoint;
                                                 }];
        }
            break;
        case 2:
        {
            height = [tableView fd_heightForCellWithIdentifier:@"TCStorePrivilegeViewCell"
                                              cacheByIndexPath:indexPath
                                                 configuration:^(TCStorePrivilegeViewCell *cell) {
                                                     cell.storeInfo = weakSelf.storeInfo;
                                                 }];
        }
            break;
        case 3:
            return 92;
            break;
            
        default:
            break;
    }
    return height;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
    [self updateNavigationBar];
}

#pragma mark - TCStorePayViewCellDelegate

- (void)didClickPayButtonInStorePayViewCell:(TCStorePayViewCell *)cell {
    
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
