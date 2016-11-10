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
#import "TCProfileBgImageChangeView.h"

#import "TCPhotoPicker.h"
#import "TCBuluoApi.h"

#import "UIImage+Category.h"

@interface TCProfileViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
TCProfileHeaderViewDelegate,
TCProfileBgImageChangeViewDelegate,
TCPhotoPickerDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (copy, nonatomic) NSArray *fodderArray;

@property (nonatomic) BOOL needsLightContentStatusBar;

@property (nonatomic) CGFloat headerViewHeight;
@property (nonatomic) CGFloat topBarHeight;

/** 点击更换背景图片时弹出的半透明背景视图 */
@property (weak, nonatomic) UIView *translucenceBgView;
/** 点击更换背景图片时弹出的选择视图 */
@property (weak, nonatomic) TCProfileBgImageChangeView *bgImageChangeView;

@property (strong, nonatomic) TCPhotoPicker *photoPicker;

@end

@implementation TCProfileViewController {
    __weak TCProfileViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    weakSelf = self;
    self.headerViewHeight = 240.0;
    self.topBarHeight = 64.0;
    
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

- (void)setupNavBar {
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    self.navigationItem.rightBarButtonItems = @[messageItem, settingItem];
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
    headerView.delegate = self;
    tableView.tableHeaderView = headerView;
    
    UINib *nib = [UINib nibWithNibName:@"TCProfileViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"TCProfileViewCell"];
    nib = [UINib nibWithNibName:@"TCProfileProcessViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"TCProfileProcessViewCell"];
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
    } else {
        self.navigationController.navigationBar.translucent = NO;
    }
    if (alpha > 0.7) {
        self.needsLightContentStatusBar = YES;
        tintColor = [UIColor whiteColor];
        titleColor = [UIColor whiteColor];
    } else {
        self.needsLightContentStatusBar = NO;
        tintColor = TCRGBColor(65, 65, 65);
        titleColor = [UIColor clearColor];
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

#pragma mark - TCProfileHeaderViewDelegate

- (void)didTapBioInProfileHeaderView:(TCProfileHeaderView *)view {
    TCBiographyViewController *vc = [[TCBiographyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didClickCardButtonInProfileHeaderView:(TCProfileHeaderView *)view {
    TCLog(@"点击了名片按钮");
}

- (void)didClickCollectButtonInProfileHeaderView:(TCProfileHeaderView *)view {
    TCLog(@"点击了收藏按钮");
}

- (void)didClickGradeButtonInProfileHeaderView:(TCProfileHeaderView *)view {
    TCLog(@"点击了等级按钮");
}

- (void)didClickPhotographButtonInProfileHeaderView:(TCProfileHeaderView *)view {
    [self showBgImageChangeView];
}

#pragma mark - TCProfileBgImageChangeViewDelegate

- (void)didClickPhotographButtonInProfileBgImageChangeView:(TCProfileBgImageChangeView *)view {
    [self dismissBgImageChangeView];
    TCPhotoPicker *photoPicker = [[TCPhotoPicker alloc] initWithSourceController:self];
    photoPicker.delegate = self;
    [photoPicker showPhotoPikerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    self.photoPicker = photoPicker;
}

- (void)didClickAlbumButtonInProfileBgImageChangeView:(TCProfileBgImageChangeView *)view {
    [self dismissBgImageChangeView];
    TCPhotoPicker *photoPicker = [[TCPhotoPicker alloc] initWithSourceController:self];
    photoPicker.delegate = self;
    [photoPicker showPhotoPikerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    self.photoPicker = photoPicker;
}

- (void)didClickCancelButtonInProfileBgImageChangeView:(TCProfileBgImageChangeView *)view {
    [self dismissBgImageChangeView];
}

#pragma mark - TCPhotoPickerDelegate

- (void)photoPicker:(TCPhotoPicker *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    TCLog(@"do something...");
    [photoPicker dismissPhotoPicker];
    self.photoPicker = nil;
}

- (void)photoPickerDidCancel:(TCPhotoPicker *)photoPicker {
    TCLog(@"photoPickerDidCancel");
    [photoPicker dismissPhotoPicker];
    self.photoPicker = nil;
}

#pragma mark - Show BgImageChangeView

- (void)showBgImageChangeView {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *translucenceBgView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    translucenceBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [keyWindow addSubview:translucenceBgView];
    self.translucenceBgView = translucenceBgView;
    
    TCProfileBgImageChangeView *bgImageChangeView = [[NSBundle mainBundle] loadNibNamed:@"TCProfileBgImageChangeView" owner:nil options:nil][0];
    bgImageChangeView.delegate = self;
    bgImageChangeView.frame = CGRectMake(0, TCScreenHeight, TCScreenWidth, 182);
    [keyWindow addSubview:bgImageChangeView];
    self.bgImageChangeView = bgImageChangeView;
    
    [UIView animateWithDuration:0.25 animations:^{
        translucenceBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.82];
        bgImageChangeView.y = TCScreenHeight - bgImageChangeView.height;
    }];
}

- (void)dismissBgImageChangeView {
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.translucenceBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        weakSelf.bgImageChangeView.y = TCScreenHeight;
    } completion:^(BOOL finished) {
        [weakSelf.translucenceBgView removeFromSuperview];
        [weakSelf.bgImageChangeView removeFromSuperview];
    }];
}

#pragma mark - Actions

- (void)handleClickQRCodeButton:(UIBarButtonItem *)sender {
    TCLog(@"点击了扫码按钮");
}

- (void)handleClickSettingButton:(UIBarButtonItem *)sender {
    TCLog(@"点击了设置按钮");
    TCLoginViewController *vc = [[TCLoginViewController alloc] initWithNibName:@"TCLoginViewController" bundle:[NSBundle mainBundle]];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)handleClickMessageButton:(UIBarButtonItem *)sender {
    TCLog(@"点击了消息按钮");
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
