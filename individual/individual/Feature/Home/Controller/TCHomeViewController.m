//
//  TCHomeViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeViewController.h"
#import "TCHomeCommodityTableViewCell.h"
#import "TCRepairsViewController.h"
#import "TCNavigationController.h"
#import "TCServiceListViewController.h"
#import "TCMyLockQRCodeController.h"
#import "TCGoodSelectView.h"


#import "TCPropertyManageListController.h"
#import "TCLoginViewController.h"
#import "TCRepairsViewController.h"

#import <MBProgressHUD.h>
#import "TCQRCodeViewController.h"
#import <TCCommonLibs/TCImagePlayerView.h>

#import "TCLocksAndVisitorsViewController.h"

#import <TCCommonLibs/UIImage+Category.h>

@interface TCHomeViewController () {
    NSDictionary *homeInfoDic;
    UIScrollView *titleScrollView;
    UIScrollView *homeScrollView;
    NSTimer *titleScrollTimer;
}

@property (nonatomic, strong) TCImagePlayerView *cycleImageView;

@property (weak, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) UINavigationItem *navItem;
@property (nonatomic) BOOL needsLightContentStatusBar;

@end

@implementation TCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    [self setupNavBar];
    [self forgeData];
    
    homeScrollView = [self getHomeScrollViewWithFrame:CGRectMake(0, 0, TCScreenWidth, TCScreenHeight - self.tabBarController.tabBar.size.height)];
    [self.view insertSubview:homeScrollView belowSubview:self.navBar];
    
    [self setupTitleImageScrollViewWithFrame:CGRectMake(0, 0, self.view.width, TCRealValue(265))];
    [homeScrollView addSubview:_cycleImageView];
    
    UIView *expressView = [self getExpressViewWithFrame:CGRectMake(0, _cycleImageView.y + _cycleImageView.height, TCScreenWidth, TCRealValue(33))];
    [homeScrollView addSubview:expressView];
    
    UIView *propertyView = [self getPropertyFunctionViewWithFrame:CGRectMake(0, expressView.y + expressView.height + TCRealValue(5), TCScreenWidth, TCRealValue(88))];
    [homeScrollView addSubview:propertyView];
    
    UITableView *commodityTableView = [self getHomeTableViewWithFrame:CGRectMake(0, propertyView.y + propertyView.height, TCScreenWidth, TCRealValue(943.5))];
    [homeScrollView addSubview:commodityTableView];
    
    homeScrollView.contentSize = CGSizeMake(TCScreenWidth, commodityTableView.y + commodityTableView.height);
    
}



- (UIScrollView *)getHomeScrollViewWithFrame:(CGRect)frame {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.backgroundColor = TCBackgroundColor;
    scrollView.delegate = self;
    
    return scrollView;
}

- (UITableView *)getHomeTableViewWithFrame:(CGRect)frame {
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return tableView;
}

- (void)setupTitleImageScrollViewWithFrame:(CGRect)frame {
    
    TCImagePlayerView *scrollView = [[TCImagePlayerView alloc] initWithFrame:frame];
    [scrollView setPictures:homeInfoDic[@"pictures"] isLocal:YES];
    [scrollView startPlaying];
    _cycleImageView = scrollView;
}

- (UIView *)getPropertyFunctionViewWithFrame:(CGRect)frame {
    UIView *propertyView = [self getGrayBorderViewWithFrame:frame];
    propertyView.backgroundColor = [UIColor whiteColor];
    UIButton *unclockBtn = [self getPropertyButtonWithFrame:CGRectMake((TCScreenWidth - (TCRealValue(50 * 4))) / 5, TCRealValue(11), TCRealValue(50), TCRealValue(64)) AndImgName:@"home_unlock" AndTitle:@"社区开门" AndAction:@selector(touchCommunityUnlockBtn:)];
    [propertyView addSubview:unclockBtn];
    
    UIButton *officeReserveBtn = [self getPropertyButtonWithFrame:CGRectMake(unclockBtn.x * 2 + unclockBtn.width, TCRealValue(11), TCRealValue(50), TCRealValue(64)) AndImgName:@"home_office_reservation" AndTitle:@"访客授权" AndAction:@selector(touchOfficeReserveBtn:)];
    [propertyView addSubview:officeReserveBtn];
    UIButton *repairBtn = [self getPropertyButtonWithFrame:CGRectMake(unclockBtn.x + officeReserveBtn.x + officeReserveBtn.width, TCRealValue(11), TCRealValue(50), TCRealValue(64)) AndImgName:@"home_ estate_repair" AndTitle:@"物业报修" AndAction:@selector(touchEstateRepair:)];
    [propertyView addSubview:repairBtn];
    UIButton *scanPayBtn = [self getPropertyButtonWithFrame:CGRectMake(unclockBtn.x + repairBtn.x + repairBtn.width, TCRealValue(11), TCRealValue(50), TCRealValue(64)) AndImgName:@"home_scan_pay" AndTitle:@"扫码支付" AndAction:@selector(touchScanPayBtn:)];
    [propertyView addSubview:scanPayBtn];
    
    return propertyView;
}

- (UIView *)getGrayBorderViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.layer.borderColor = TCSeparatorLineColor.CGColor;
    view.layer.borderWidth = TCRealValue(0.5);
    view.frame = CGRectMake(frame.origin.x - TCRealValue(0.5), frame.origin.y, frame.size.width + TCRealValue(1), frame.size.height);
    return view;
}

- (UIButton *)getPropertyButtonWithFrame:(CGRect)frame AndImgName:(NSString *)imgName AndTitle:(NSString *)title AndAction:(SEL)action {
    UIButton *propertyBtn = [[UIButton alloc] initWithFrame:frame];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - TCRealValue(35) / 2, TCRealValue(7), TCRealValue(35), TCRealValue(35))];
    imgView.image = [UIImage imageNamed:imgName];
    [propertyBtn addSubview:imgView];
    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(0, imgView.y + imgView.height + TCRealValue(6), frame.size.width, TCRealValue(12)) AndFontSize:TCRealValue(12) AndTitle:title];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [propertyBtn addSubview:titleLab];
    
    [propertyBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return propertyBtn;
}

- (UIScrollView *)getTitleImageScrollViewWithFrame:(CGRect)frame {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    
    
    return scrollView;
}

- (UIView *)getExpressViewWithFrame:(CGRect)frame {
    UIView *expressView = [[UIView alloc] initWithFrame:frame];
    expressView.backgroundColor = [UIColor whiteColor];
    UIButton *expressImgBtn = [TCComponent createImageBtnWithFrame:CGRectMake(TCRealValue(15), frame.size.height / 2 - TCRealValue(12) / 2, TCRealValue(10), TCRealValue(12)) AndImageName:@"home_express"];
    [expressView addSubview:expressImgBtn];
    
    UILabel *expressLab = [TCComponent createLabelWithFrame:CGRectMake(expressImgBtn.x + expressImgBtn.width + TCRealValue(5), 0, TCRealValue(50), frame.size.height) AndFontSize:TCRealValue(12) AndTitle:@"部落快报" AndTextColor:TCBlackColor];
    [expressView addSubview:expressLab];
    
    UIView *activityView = [self getExpressActivityViewWithFrame:CGRectMake(expressLab.x + expressLab.width + TCRealValue(3), 0, TCScreenWidth - expressLab.x - expressLab.width - TCRealValue(3), frame.size.height)];
    [expressView addSubview:activityView];
    
    UIView *downLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, expressView.height - TCRealValue(0.5), TCScreenWidth, TCRealValue(0.5))];
    [expressView addSubview:downLineView];
    
    return expressView;
}

- (UIView *)getExpressActivityViewWithFrame:(CGRect)frame {
    UIView *activityView = [[UIView alloc] initWithFrame:frame];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height / 2 - TCRealValue(17.5) / 2, TCRealValue(0.5), TCRealValue(17.5))];
    lineView.backgroundColor = TCGrayColor;
    [activityView addSubview:lineView];
    
    UILabel *activityLab = [TCComponent createLabelWithFrame:CGRectMake(lineView.x + lineView.width + TCRealValue(5), 0, frame.size.width - lineView.x - lineView.width - TCRealValue(5), frame.size.height) AndFontSize:12 AndTitle:@"活动 : 10月9日午餐新活动" AndTextColor:TCGrayColor];
    [activityView addSubview:activityLab];
    
    return activityView;
}


- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [navBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"首页"];
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
    
    [self updateNavigationBarWithAlpha:0.0];
    self.needsLightContentStatusBar = YES;
}


- (UIButton *)createButtonWithFrame:(CGRect)frame AndText:(NSString *)text AndAction:(SEL)action{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    return button;
}

- (UIView *)getHeaderTitleViewWithImgName:(NSString *)imgName AndTitle:(NSString *)title {
    UIView *view = [[UIView alloc] init];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    imgView.frame = CGRectMake(0, TCRealValue(34.5) / 2 - TCRealValue(14) / 2, TCRealValue(14), TCRealValue(14));
    [view addSubview:imgView];
    
    UILabel *titleLabel = [TCComponent createLabelWithText:title AndFontSize:TCRealValue(16)];
    titleLabel.font = [UIFont fontWithName:BOLD_FONT size:TCRealValue(16)];
    titleLabel.origin = CGPointMake(imgView.x + imgView.width + TCRealValue(2), 0);
    titleLabel.height = TCRealValue(34.5);
    [view addSubview:titleLabel];
    
    view.frame = CGRectMake(TCScreenWidth / 2 - titleLabel.x / 2 - titleLabel.width / 2, 0, titleLabel.x + titleLabel.width, TCRealValue(34.5));
    
    return view;
}

- (BOOL)checkUserNeedLogin {
    if ([[TCBuluoApi api] needLogin]) {
        [self showLoginViewController];
    }
    return [[TCBuluoApi api] needLogin];
}

- (void)showLoginViewController {
    TCLoginViewController *vc = [[TCLoginViewController alloc] initWithNibName:@"TCLoginViewController" bundle:[NSBundle mainBundle]];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (UIView *)getHeaderLineViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor blackColor];
    
    return view;
}


- (void)setCommodityTargetWithLeftBtn:(UIButton *)leftBtn AndRightTopBtn:(UIButton *)rightTopBtn AndRightDownBtn:(UIButton *)rightDownBtn AndIndex:(NSInteger)index {
    if (index == 0) {
        [leftBtn addTarget:self action:@selector(touchShoppingBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rightTopBtn addTarget:self action:@selector(touchShoppingBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rightDownBtn addTarget:self action:@selector(touchShoppingBtn:) forControlEvents:UIControlEventTouchUpInside];
    } else if (index == 1) {
        [leftBtn addTarget:self action:@selector(touchRestaurantBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rightTopBtn addTarget:self action:@selector(touchRestaurantBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rightDownBtn addTarget:self action:@selector(touchRestaurantBtn:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [leftBtn addTarget:self action:@selector(touchEntertainmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rightTopBtn addTarget:self action:@selector(touchEntertainmentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [rightDownBtn addTarget:self action:@selector(touchEntertainmentBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setNavigationBarBlack {
    [self.navigationController.navigationBar setTranslucent:NO];
    UIImageView *barImageView = self.navigationController.navigationBar.subviews.firstObject;
    barImageView.backgroundColor = TCBlackColor;
    barImageView.alpha = 1;
}

#pragma mark - Status Bar

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.needsLightContentStatusBar ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

//-(UIStatusBarStyle)preferredStatusBarStyle {
//    if (homeScrollView.contentOffset.y < 130) {
//        UIColor *color = [self colorOfPoint:CGPointMake(TCScreenWidth / 2, 10)];
//        BOOL isLight = [self isLightColor:color];
//        if (!isLight) {
//            return UIStatusBarStyleLightContent;
//        } else {
//            return UIStatusBarStyleDefault;
//        }
//    } else {
//        return UIStatusBarStyleLightContent;
//    }
//
//}

- (void)setNeedsLightContentStatusBar:(BOOL)needsLightContentStatusBar {
    BOOL statusBarNeedsUpdate = (needsLightContentStatusBar != _needsLightContentStatusBar);
    _needsLightContentStatusBar = needsLightContentStatusBar;
    if (statusBarNeedsUpdate) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIColor *)colorOfPoint:(CGPoint)point {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.view.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

- (BOOL) isLightColor:(UIColor*)color {
    CGFloat components[3];
    [self getRGBComponents:components forColor:color];
    
    CGFloat num = components[0] + components[1] + components[2];
    if(num < 382)
        return NO;
    else
        return YES;
}

- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 bitmapInfo);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component];
    }
}

#pragma mark - Navigation Bar

- (void)updateNavigationBarAndStatusBar {
    CGFloat maxOffsetY = 270;
    CGFloat offsetY = homeScrollView.contentOffset.y;
    CGFloat alpha = offsetY / maxOffsetY;
    if (alpha > 1.0) alpha = 1.0;
    if (alpha < 0.0) alpha = 0.0;
    [self updateNavigationBarWithAlpha:alpha];
    
    if (offsetY < -10) {
        self.needsLightContentStatusBar = NO;
    } else {
        self.needsLightContentStatusBar = YES;
    }
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *arr = @[ homeInfoDic[@"shopping"], homeInfoDic[@"food"], homeInfoDic[@"entertainment"] ];
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NSString stringWithFormat:@"%li", (long)section]];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:[NSString stringWithFormat:@"%li", (long)section]];
    }
    UIView *titleView = [self getHeaderTitleViewWithImgName:arr[section][@"image"] AndTitle:arr[section][@"name"]];
    [headerView addSubview:titleView];
    
    UIView *leftLineView = [self getHeaderLineViewWithFrame:CGRectMake(titleView.x - TCRealValue(6) - TCRealValue(42), TCRealValue(34.5) / 2 - TCRealValue(0.5) / 2, TCRealValue(41), TCRealValue(0.5))];
    [headerView addSubview:leftLineView];
    UIView *rightLineView = [self getHeaderLineViewWithFrame:CGRectMake(titleView.x + titleView.width + TCRealValue(6), leftLineView.y, leftLineView.width, leftLineView.height)];
    [headerView addSubview:rightLineView];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSArray *arr = @[ homeInfoDic[@"shopping"], homeInfoDic[@"food"], homeInfoDic[@"entertainment"] ];
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[NSString stringWithFormat:@"%li", (long)section]];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:[NSString stringWithFormat:@"%li", (long)section]];
    }
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, TCRealValue(130))];
    imgView.image = [UIImage imageNamed:arr[section][@"footerImage"]];
    [footerView addSubview:imgView];
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%li", (long)indexPath.section];
    TCHomeCommodityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TCHomeCommodityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSArray *arr = @[ homeInfoDic[@"shopping"], homeInfoDic[@"food"], homeInfoDic[@"entertainment"] ];
    NSDictionary *dic = arr[indexPath.section];
    [cell.leftImgBtn setImage:[UIImage imageNamed:dic[@"leftInfo"][@"picture"]] forState:UIControlStateNormal];
    cell.leftTitleLab.text = dic[@"leftInfo"][@"title"];
    [cell.rightTopImgBtn setImage:[UIImage imageNamed:dic[@"rightTop"][@"picture"]] forState:UIControlStateNormal];
    cell.rightTopTitleLab.text = dic[@"rightTop"][@"title"];
    cell.rightTopSubTitleLab.text = dic[@"rightTop"][@"subTitle"];
    [cell.rightDownImgBtn setImage:[UIImage imageNamed:dic[@"rightDown"][@"picture"]] forState:UIControlStateNormal];
    cell.rightDownTitleLab.text = dic[@"rightDown"][@"title"];
    cell.rightDownSubTitleLab.text = dic[@"rightDown"][@"subTitle"];
    [self setCommodityTargetWithLeftBtn:cell.leftImgBtn AndRightTopBtn:cell.rightTopImgBtn AndRightDownBtn:cell.rightDownImgBtn AndIndex:indexPath.section];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TCRealValue(150);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TCRealValue(34.5);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return TCRealValue(130);
}


#pragma mark - UIScrollDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:homeScrollView]) {
        [self updateNavigationBarAndStatusBar];
        
    }
    //    [self setNeedsStatusBarAppearanceUpdate];
}


#pragma mark - click

/**
 社区开锁
 */
- (void)touchCommunityUnlockBtn:(UIButton *)button {
    if ([self isThereLockPermissions:TCLocks]) {
        [self toLocksView];
    }
}

/**
 访客授权
 */
- (void)touchOfficeReserveBtn:(UIButton *)button {
    if ([self isThereLockPermissions:TCVisitors]) {
        [self toVisitorsView];
    }
}

/**
 是否有开锁权限
 */
- (BOOL)isThereLockPermissions:(TCLocksOrVisitors)lockOrVisitor {
    if ([self checkUserNeedLogin]) return NO;
    
    NSString *featureStr = (lockOrVisitor == TCLocks) ? @"开门" : @"授权";
    TCUserInfo *userInfo = [[TCBuluoApi api] currentUserSession].userInfo;
    if (![userInfo.authorizedStatus isEqualToString:@"SUCCESS"]) {
        [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"身份认证成功后才可使用%@功能", featureStr]];
        return NO;
    }
    if (!userInfo.companyID) {
        [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"绑定公司成功后才可使用%@功能", featureStr]];
        return NO;
    }
    
    return YES;
}

/**
 跳到个人锁设备列表
 */
- (void)toLocksView {
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

/**
 跳到访客列表
 */
- (void)toVisitorsView {
    TCLocksAndVisitorsViewController *lockAndVisitorVC = [[TCLocksAndVisitorsViewController alloc] initWithType:TCVisitors];
    lockAndVisitorVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:lockAndVisitorVC animated:YES];
}

- (void)touchEstateRepair:(UIButton *)button {
    if ([self checkUserNeedLogin]) return;
    TCRepairsViewController *vc = [[TCRepairsViewController alloc] initWithNibName:@"TCRepairsViewController" bundle:[NSBundle mainBundle]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)touchScanPayBtn:(UIButton *)button {
    
    TCQRCodeViewController *qrVC = [[TCQRCodeViewController alloc] init];
    qrVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (void)touchShoppingBtn:(id)sender {
    [self setNavigationBarBlack];
    TCRecommendListViewController *recommend = [[TCRecommendListViewController alloc]init];
    recommend.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recommend animated:YES];
}

- (void)touchRestaurantBtn:(id)sender {
    TCServiceListViewController *vc = [[TCServiceListViewController alloc] initWithServiceType:TCServiceTypeRepast];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchEntertainmentBtn:(id)sender {
    TCServiceListViewController *vc = [[TCServiceListViewController alloc] initWithServiceType:TCServiceTypeOther];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)forgeData {
    homeInfoDic = @{
                    @"pictures":@[ @"home_Carousel",
                                   @"home_Carousel",
                                   @"home_Carousel",
                                   @"home_Carousel",
                                   @"home_Carousel"],
                    @"activity":@[  ],
                    @"shopping":@{
                            @"name":@"购物", @"image":@"home_shopping_icon",
                            @"footerImage":@"home_good_test3",
                            @"leftInfo":@{
                                    @"title":@"今日特惠",
                                    @"price":@"",
                                    @"picture":@"home_shopping_left"
                                    },
                            @"rightTop":@{
                                    @"title":@"今日特惠",
                                    @"subTitle":@"休闲娱乐",
                                    @"picture":@"home_shopping_top"
                                    },
                            @"rightDown":@{
                                    @"title":@"今日特惠",
                                    @"subTitle":@"休闲娱乐",
                                    @"picture":@"home_shopping_down"
                                    }
                            },
                    @"food":@{
                            @"name":@"餐饮", @"image":@"home_food_icon",
                            @"footerImage":@"home_food_footer",
                            @"leftInfo":@{
                                    @"title":@"今日特惠",
                                    @"price":@"",
                                    @"picture":@"home_food_left"
                                    },
                            @"rightTop":@{
                                    @"title":@"今日特惠",
                                    @"subTitle":@"休闲娱乐",
                                    @"picture":@"home_food_top"
                                    },
                            @"rightDown":@{
                                    @"title":@"今日特惠",
                                    @"subTitle":@"休闲娱乐",
                                    @"picture":@"home_food_down"
                                    }
                            },
                    @"entertainment":@{
                            @"name":@"娱乐", @"image":@"home_entertainment_icon",
                            @"footerImage":@"home_entertainment_footer",
                            @"leftInfo":@{
                                    @"title":@"今日特惠",
                                    @"price":@"",
                                    @"picture":@"home_entertainment_left"
                                    },
                            @"rightTop":@{
                                    @"title":@"今日特惠",
                                    @"subTitle":@"休闲娱乐",
                                    @"picture":@"home_entertainment_top"
                                    },
                            @"rightDown":@{
                                    @"title":@"今日特惠",
                                    @"subTitle":@"休闲娱乐",
                                    @"picture":@"home_entertainment_down"
                                    }
                            }
                    };
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
