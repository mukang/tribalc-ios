//
//  TCStoreDetailViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreDetailViewController.h"
#import "TCStorePayViewController.h"
#import "TCGoodsViewController.h"
#import "TCGoodsDetailViewController.h"

#import "TCStoreHeaderView.h"
#import "TCStoreDescViewCell.h"
#import "TCStoreTagsViewCell.h"
#import "TCStorePrivilegeViewCell.h"
#import "TCStoreGoodsCell.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/UIImage+Category.h>
#import <TCCommonLibs/TCCommonButton.h>
#import <UITableView+FDTemplateLayoutCell.h>

#define headerViewH TCRealValue(252)
#define navBarH     64.0

@interface TCStoreDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) UINavigationItem *navItem;

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCStoreHeaderView *headerView;

@property (strong, nonatomic) UIView *footerView;

@property (strong, nonatomic) TCListStore *storeInfo;

@property (strong, nonatomic) NSMutableArray *mutableGoodsArr;

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
    [self loadGoodsData];
    [self updateNavigationBarWithAlpha:0.0];
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
    [tableView registerClass:[TCStoreGoodsCell class] forCellReuseIdentifier:@"TCStoreGoodsCell"];
    [tableView setContentOffset:CGPointMake(0, -headerViewH) animated:NO];
    [self.view insertSubview:tableView belowSubview:self.navBar];
    self.tableView = tableView;
    
    TCStoreHeaderView *headerView = [[TCStoreHeaderView alloc] init];
    [self.tableView addSubview:headerView];
    self.headerView = headerView;
    
    TCCommonButton *payButton = [TCCommonButton bottomButtonWithTitle:@"买  单"
                                                                color:TCCommonButtonColorPurple
                                                               target:self
                                                               action:@selector(handleClickPaybutton)];
    [self.view addSubview:payButton];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(payButton.mas_top);
    }];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(tableView);
        make.top.equalTo(tableView).offset(-headerViewH);
        make.height.mas_equalTo(headerViewH);
    }];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)loadGoodsData {
    [[TCBuluoApi api] fetchGoodsWrapper:3 sortSkip:nil storeId:self.storeID result:^(TCGoodsWrapper *goodsWrapper, NSError *error) {
        if ([goodsWrapper isKindOfClass:[TCGoodsWrapper class]]) {
            NSArray *arr = goodsWrapper.content;
            if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
                [weakSelf.mutableGoodsArr addObjectsFromArray:arr];
                if (weakSelf.storeInfo) {
                    weakSelf.tableView.tableFooterView = weakSelf.footerView;
                    [weakSelf.tableView reloadData];
                }
            }
        }else {
            NSString *reason = error.localizedDescription ?: @"请退出该页面重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
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
            if (weakSelf.mutableGoodsArr.count > 0) {
                weakSelf.tableView.tableFooterView = weakSelf.footerView;
            }
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
    return 3+self.mutableGoodsArr.count;
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
            
        default:
        {
            TCStoreGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreGoodsCell" forIndexPath:indexPath];
            cell.goods = self.mutableGoodsArr[indexPath.row-3];
            return cell;
        }
            break;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 2) {
        TCGoods *goodInfo = self.mutableGoodsArr[indexPath.row-3];
        TCGoodsDetail *goodsDetail = [[TCGoodsDetail alloc] init];
        goodsDetail.name = goodInfo.name;
        goodsDetail.brand = goodInfo.brand;
        goodsDetail.mainPicture = goodInfo.mainPicture;
        goodsDetail.originPrice = goodInfo.originPrice;
        goodsDetail.salePrice = goodInfo.salePrice;
        
        TCGoodsDetailViewController *vc = [[TCGoodsDetailViewController alloc] init];
        vc.goodsID = goodInfo.ID;
        vc.goodsDetail = goodsDetail;
        [self.navigationController pushViewController:vc animated:YES];

    }
}

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
            
        default:
            height = 112.5;
            break;
    }
    return height;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
    [self updateNavigationBar];
}

#pragma mark - Actions 

- (void)handleClickMoreGoods {
    TCGoodsViewController *goodsVC = [[TCGoodsViewController alloc] init];
    goodsVC.storeId = self.storeID;
    goodsVC.title = self.storeInfo.name;
    [self.navigationController pushViewController:goodsVC animated:YES];
}

- (void)handleClickPaybutton {
    TCStorePayViewController *vc = [[TCStorePayViewController alloc] init];
    vc.storeID = self.storeID;
    vc.fromController = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)footerView {
    if (_footerView == nil) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 80)];
        _footerView.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 10, TCScreenWidth-30, 0.5)];
        lineView.backgroundColor = TCSeparatorLineColor;
        [_footerView addSubview:lineView];
        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [moreBtn setBackgroundColor:[UIColor whiteColor]];
        [moreBtn setTitle:@"更多商品 >" forState:UIControlStateNormal];
        [moreBtn setTitleColor:TCBlackColor forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(handleClickMoreGoods) forControlEvents:UIControlEventTouchUpInside];
        moreBtn.layer.borderColor = TCBlackColor.CGColor;
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        moreBtn.layer.borderWidth = 0.5;
        moreBtn.frame = CGRectMake((TCScreenWidth-100)/2, 20, 100, 27);
        [_footerView addSubview:moreBtn];
    }
    return _footerView;
}

- (NSMutableArray *)mutableGoodsArr {
    if (_mutableGoodsArr == nil) {
        _mutableGoodsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _mutableGoodsArr;
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
