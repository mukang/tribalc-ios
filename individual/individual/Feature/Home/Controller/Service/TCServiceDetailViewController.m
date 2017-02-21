//
//  TCServiceDetailViewController.m
//  individual
//
//  Created by 穆康 on 2017/2/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceDetailViewController.h"

#import "TCServiceHeaderView.h"

#import "UIImage+Category.h"

#import "TCBuluoApi.h"

#define headerViewH TCRealValue(270)
#define navBarH     64.0

@interface TCServiceDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) UINavigationItem *navItem;

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCServiceHeaderView *headerView;

@property (strong, nonatomic) TCServiceDetail *serviceDetail;

@end

@implementation TCServiceDetailViewController {
    __weak TCServiceDetailViewController *weakSelf;
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
    [navBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [navBar setTintColor:[UIColor whiteColor]];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"首页"];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickBackButton:)];
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
    
    [self updateNavigationBarWithAlpha:0.0];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(242, 242, 242);
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(headerViewH, 0, 0, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [tableView setContentOffset:CGPointMake(0, -headerViewH) animated:NO];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCServiceHeaderView *headerView = [[TCServiceHeaderView alloc] init];
    [self.tableView addSubview:headerView];
    self.headerView = headerView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.width.equalTo(tableView);
        make.top.equalTo(tableView).offset(-headerViewH);
        make.height.mas_equalTo(headerViewH);
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

- (void)loadNetData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchServiceDetail:self.serviceID result:^(TCServiceDetail *serviceDetail, NSError *error) {
        if (serviceDetail) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.serviceDetail = serviceDetail;
            weakSelf.headerView.detailStore = serviceDetail.detailStore;
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出该页面重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

#pragma mark - Navigation Bar

- (void)updateNavigationBar {
    CGFloat maxOffsetY = TCRealValue(270);
    CGFloat offsetY = self.tableView.contentOffset.y;
    CGFloat alpha = offsetY / maxOffsetY;
    if (alpha > 1.0) alpha = 1.0;
    if (alpha < 0.0) alpha = 0.0;
    [self updateNavigationBarWithAlpha:alpha];
}

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha {
    UIColor *titleColor = nil;
    if (alpha > 0.7) {
        titleColor = [UIColor whiteColor];
    } else {
        titleColor = [UIColor clearColor];
    }
    self.navBar.titleTextAttributes = @{
                                        NSFontAttributeName : [UIFont systemFontOfSize:16],
                                        NSForegroundColorAttributeName : titleColor
                                        };
    
    UIImage *bgImage = [UIImage imageWithColor:TCARGBColor(42, 42, 42, alpha)];
    [self.navBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
}

#pragma mark - Actions

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
