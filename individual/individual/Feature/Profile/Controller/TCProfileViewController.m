//
//  TCProfileViewController.m
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCProfileViewController.h"
#import "TCLoginViewController.h"
#import "TCBiographyViewController.h"

#import "TCProfileHeaderView.h"
#import "TCProfileViewCell.h"
#import "TCProfileProcessViewCell.h"

#import "UIImage+Category.h"

@interface TCProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *fodderArray;
@property (nonatomic) CGFloat headerViewHeight;
@property (nonatomic) CGFloat topBarHeight;

@end

@implementation TCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.headerViewHeight = 240.0;
    self.topBarHeight = 64.0;
    
    [self setupNavBar];
    [self setupSubviews];
    [self updateNavigationBar];
}

- (void)setupNavBar {
    self.extendedLayoutIncludesOpaqueBars = YES;
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile_nav_QRcode_item"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickQRCodeButton:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile_nav_setting_item"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(handleClickSettingButton:)];
    UIBarButtonItem *messageItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile_nav_message_item"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(handleClickMessageButton:)];
    self.navigationItem.rightBarButtonItems = @[settingItem, messageItem];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 49, 0);
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    TCProfileHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"TCProfileHeaderView" owner:nil options:nil] firstObject];
    tableView.tableHeaderView = headerView;
    
    UINib *nib = [UINib nibWithNibName:@"TCProfileViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"TCProfileViewCell"];
    nib = [UINib nibWithNibName:@"TCProfileProcessViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"TCProfileProcessViewCell"];
}

#pragma mark - Navigation Bar

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
    UIColor *tintColor = nil;
    if (alpha < 1.0) {
        self.navigationController.navigationBar.translucent = YES;
    } else {
        self.navigationController.navigationBar.translucent = NO;
    }
    if (alpha > 0.7) {
        tintColor = [UIColor whiteColor];
    } else {
        tintColor = TCRGBColor(65, 65, 65);
    }
    [self.navigationController.navigationBar setTintColor:tintColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName : [UIFont systemFontOfSize:16],
                                                                    NSForegroundColorAttributeName : tintColor
                                                                    };
    UIImage *bgImage = [UIImage imageWithColor:TCARGBColor(42, 42, 42, alpha)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Status Bar



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 7;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TCProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCProfileViewCell" forIndexPath:indexPath];
            NSDictionary *fodder = self.fodderArray[indexPath.section][indexPath.row];
            cell.titleLabel.text = fodder[@"title"];
            cell.iconImageView.image = [UIImage imageNamed:fodder[@"icon"]];
            cell.titleLabel.font = [UIFont systemFontOfSize:16];
            currentCell = cell;
        } else {
            TCProfileProcessViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCProfileProcessViewCell" forIndexPath:indexPath];
            currentCell = cell;
        }
    } else {
        TCProfileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCProfileViewCell" forIndexPath:indexPath];
        NSDictionary *fodder = self.fodderArray[indexPath.section][indexPath.row];
        cell.titleLabel.text = fodder[@"title"];
        cell.iconImageView.image = [UIImage imageNamed:fodder[@"icon"]];
        cell.titleLabel.font = [UIFont systemFontOfSize:14];
        currentCell = cell;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            height = 40;
        } else {
            height = 80;
        }
    } else {
        height = 54;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 14;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateNavigationBar];
}

#pragma mark - Actions

- (IBAction)handleTapLoginButton:(UIButton *)sender {
    
    TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (IBAction)handleTaoBiographyButton:(UIButton *)sender {
    TCBiographyViewController *vc = [[TCBiographyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickQRCodeButton:(UIBarButtonItem *)sender {
    
}

- (void)handleClickSettingButton:(UIBarButtonItem *)sender {
    
}

- (void)handleClickMessageButton:(UIBarButtonItem *)sender {
    
}

#pragma mark - Override Methods

- (NSArray *)fodderArray {
    if (_fodderArray == nil) {
        _fodderArray = @[
                         @[@{@"title": @"我的订单", @"icon": @"profile_order_icon"},
                           @{@"title": @"", @"icon": @""}],
                         @[@{@"title": @"我的钱包", @"icon": @"profile_wallet_icon"},
                           @{@"title": @"身份认证", @"icon": @"profile_identity_icon"},
                           @{@"title": @"审核事项", @"icon": @"profile_check_icon"},
                           @{@"title": @"我的活动", @"icon": @"profile_activity_icon"},
                           @{@"title": @"优惠券", @"icon": @"profile_coupon_icon"},
                           @{@"title": @"我的公司", @"icon": @"profile_company_icon"},
                           @{@"title": @"足迹", @"icon": @"profile_footprint_icon"}],
                         @[@{@"title": @"我的关注", @"icon": @"profile_attention_icon"}]
                         ];
    }
    return _fodderArray;
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
