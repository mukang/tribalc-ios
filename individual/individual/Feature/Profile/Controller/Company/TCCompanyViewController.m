//
//  TCCompanyViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/7.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCompanyViewController.h"

#import "TCCompanyHeaderView.h"
#import "TCCompanyIntroViewCell.h"

#import "TCUserCompanyInfo.h"

#import "UIImage+Category.h"

#import <UITableView+FDTemplateLayoutCell.h>

@interface TCCompanyViewController () <UITableViewDataSource, UITableViewDelegate, TCCompanyIntroViewCellDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCCompanyHeaderView *headerView;

@property (nonatomic) CGFloat headerViewHeight;
@property (nonatomic) CGFloat topBarHeight;

@property (nonatomic) BOOL needsLightContentStatusBar;

@property (nonatomic) BOOL companyIntroFold;

@end

@implementation TCCompanyViewController {
    __weak TCCompanyViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    self.headerViewHeight = TCRealValue(270);
    self.topBarHeight = 64.0;
    self.companyIntroFold = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateNavigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (![[self.navigationController.childViewControllers lastObject] isEqual:self]) {
        [self restoreNavigationBar];
    } else {
        // TODO:
    }
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleCickBackButton:)];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(242, 242, 242);
    tableView.separatorColor = TCRGBColor(221, 221, 221);
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tableView registerClass:[TCCompanyIntroViewCell class] forCellReuseIdentifier:@"TCCompanyIntroViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCCompanyHeaderView *headerView = [[TCCompanyHeaderView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, self.headerViewHeight)];
    tableView.tableHeaderView = headerView;
}

#pragma mark - Navigation Bar

- (void)restoreNavigationBar {
    [self updateNavigationBarWithAlpha:1.0];
}

- (void)updateNavigationBar {
    if ([[self.navigationController.childViewControllers lastObject] isEqual:self]) {
        CGFloat offsetY = self.tableView.contentOffset.y;
        CGFloat alpha = offsetY / (self.headerViewHeight - self.topBarHeight);
        alpha = roundf(alpha * 100) / 100;
        if (alpha > 1.0) alpha = 1.0;
        if (alpha < 0.0) alpha = 0.0;
        [self updateNavigationBarWithAlpha:alpha];
    }
}

- (void)updateNavigationBarWithAlpha:(CGFloat)alpha {
    UIColor *tintColor = nil, *titleColor = nil;
    if (alpha < 1.0) {
        self.navigationController.navigationBar.translucent = YES;
        self.needsLightContentStatusBar = NO;
        tintColor = TCRGBColor(65, 65, 65);
        titleColor = [UIColor clearColor];
    } else {
        self.navigationController.navigationBar.translucent = NO;
        self.needsLightContentStatusBar = YES;
        tintColor = [UIColor whiteColor];
        titleColor = [UIColor whiteColor];
    }
    [self.navigationController.navigationBar setTintColor:tintColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName : [UIFont systemFontOfSize:16],
                                                                    NSForegroundColorAttributeName : titleColor
                                                                    };
    UIImage *bgImage = [UIImage imageWithColor:TCARGBColor(42, 42, 42, alpha)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Status Bar

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.needsLightContentStatusBar ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

- (void)setNeedsLightContentStatusBar:(BOOL)needsLightContentStatusBar {
    BOOL statusBarNeedsUpdate = (needsLightContentStatusBar != _needsLightContentStatusBar);
    _needsLightContentStatusBar = needsLightContentStatusBar;
    if (statusBarNeedsUpdate) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCCompanyIntroViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCompanyIntroViewCell" forIndexPath:indexPath];
    cell.fold = self.companyIntroFold;
    cell.companyInfo = self.userCompanyInfo.company;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"TCCompanyIntroViewCell" configuration:^(id cell) {
        TCCompanyIntroViewCell *companyIntroViewCell = cell;
        companyIntroViewCell.fold = self.companyIntroFold;
        companyIntroViewCell.companyInfo = weakSelf.userCompanyInfo.company;
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateNavigationBar];
}

#pragma mark - TCCompanyIntroViewCellDelegate

- (void)companyIntroViewCell:(TCCompanyIntroViewCell *)cell didClickUnfoldButtonWithFold:(BOOL)fold {
    self.companyIntroFold = !fold;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Actions

- (void)handleCickBackButton:(UIBarButtonItem *)sender {
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
