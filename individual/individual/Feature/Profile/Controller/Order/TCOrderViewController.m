//
//  TCOrderViewController.m
//  individual
//
//  Created by 穆康 on 2017/2/15.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCOrderViewController.h"
#import "TCOrderDetailViewController.h"
#import "TCNavigationController.h"

#import "TCGoodsOrderViewCell.h"
#import "TCGoodsOrderHeaderView.h"
#import "TCGoodsOrderFooterView.h"

#import <TCCommonLibs/TCTabView.h>
#import <TCCommonLibs/TCRefreshHeader.h>
#import <TCCommonLibs/TCRefreshFooter.h>

#import "TCBuluoApi.h"

@interface TCOrderViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) TCTabView *tabView;
@property (weak, nonatomic) UICollectionView *collectionView;

@property (copy, nonatomic) NSString *currentStatus;
@property (nonatomic) NSInteger limitSize;
@property (copy, nonatomic) NSString *sortSkip;

@property (strong, nonatomic) NSMutableArray *dataList;

@property (nonatomic) BOOL originalInteractivePopGestureEnabled;

@end

@implementation TCOrderViewController {
    __weak TCOrderViewController *weakSelf;
}

- (instancetype)initWithGoodsOrderStatus:(TCGoodsOrderStatus)goodsOrderStatus {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _goodsOrderStatus = goodsOrderStatus;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"我的订单";
    self.limitSize = 20;
    
    [self setupSubviews];
    [self.tabView selectIndex:self.goodsOrderStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.fromController) {
        TCNavigationController *nav = (TCNavigationController *)self.navigationController;
        self.originalInteractivePopGestureEnabled = nav.enableInteractivePopGesture;
        nav.enableInteractivePopGesture = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.fromController) {
        TCNavigationController *nav = (TCNavigationController *)self.fromController.navigationController;
        nav.enableInteractivePopGesture = self.originalInteractivePopGestureEnabled;
    }
}

- (void)dealloc {
    self.collectionView.dataSource = nil;
    self.collectionView.delegate = nil;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    TCTabView *tabView = [[TCTabView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 40) titleArr:@[@"全部", @"待付款", @"待收货", @"已完成"]];
    tabView.tapBlock = ^(NSInteger index) {
        weakSelf.currentStatus = [weakSelf getCurrentStatusWithIndex:index];
        [weakSelf loadNewData];
    };
    [self.view addSubview:tabView];
    self.tabView = tabView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(TCScreenWidth, 78.5);
    layout.minimumLineSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(TCScreenWidth, 49);
    layout.footerReferenceSize = CGSizeMake(TCScreenWidth, 51);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = TCBackgroundColor;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[TCGoodsOrderViewCell class] forCellWithReuseIdentifier:@"TCGoodsOrderViewCell"];
    [collectionView registerClass:[TCGoodsOrderHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"TCGoodsOrderHeaderView"];
    [collectionView registerClass:[TCGoodsOrderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"TCGoodsOrderFooterView"];
    collectionView.mj_header = [TCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    collectionView.mj_footer = [TCRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).with.offset(40);
        make.left.bottom.right.equalTo(weakSelf.view);
    }];
}

- (NSString *)getCurrentStatusWithIndex:(NSInteger)index {
    NSString *currentStatus = nil;
    switch (index) {
        case 0:
            currentStatus = nil;
            break;
        case 1:
            currentStatus = @"NO_SETTLE";
            break;
        case 2:
            currentStatus = @"DELIVERY";
            break;
        case 3:
            currentStatus = @"RECEIVED";
            break;
            
        default:
            break;
    }
    return currentStatus;
}

- (void)loadNewData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchOrderWrapper:self.currentStatus limiSize:self.limitSize sortSkip:nil result:^(TCOrderWrapper *orderWrapper, NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        if (orderWrapper) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.sortSkip = orderWrapper.nextSkip;
            [weakSelf.dataList removeAllObjects];
            [weakSelf.dataList addObjectsFromArray:orderWrapper.content];
            [weakSelf.collectionView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取订单数据失败，%@", reason]];
        }
    }];
}

- (void)loadOldData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchOrderWrapper:self.currentStatus limiSize:self.limitSize sortSkip:self.sortSkip result:^(TCOrderWrapper *orderWrapper, NSError *error) {
        if (orderWrapper) {
            [MBProgressHUD hideHUD:YES];
            if (orderWrapper.hasMore) {
                [weakSelf.collectionView.mj_footer endRefreshing];
            } else {
                [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
            }
            weakSelf.sortSkip = orderWrapper.nextSkip;
            [weakSelf.dataList addObjectsFromArray:orderWrapper.content];
            [weakSelf.collectionView reloadData];
        } else {
            [weakSelf.collectionView.mj_footer endRefreshing];
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取订单数据失败，%@", reason]];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    TCOrder *goodsOrder = self.dataList[section];
    return goodsOrder.itemList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCGoodsOrderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCGoodsOrderViewCell" forIndexPath:indexPath];
    TCOrder *goodsOrder = self.dataList[indexPath.section];
    TCOrderItem *orderItem = goodsOrder.itemList[indexPath.row];
    cell.orderItem = orderItem;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    TCOrder *goodsOrder = self.dataList[indexPath.section];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TCGoodsOrderHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TCGoodsOrderHeaderView" forIndexPath:indexPath];
        view.order = goodsOrder;
        return view;
    } else {
        TCGoodsOrderFooterView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"TCGoodsOrderFooterView" forIndexPath:indexPath];
        view.order = goodsOrder;
        return view;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TCOrder *goodsOrder = self.dataList[indexPath.section];
    TCOrderDetailViewController *vc = [[TCOrderDetailViewController alloc] init];
    vc.goodsOrder = goodsOrder;
    vc.statusChangeBlock = ^(TCOrder *goodsOrder) {
        if (weakSelf.currentStatus == nil) {
            for (int i=0; i<weakSelf.dataList.count; i++) {
                TCOrder *order = weakSelf.dataList[i];
                if ([order.ID isEqualToString:goodsOrder.ID]) {
                    [weakSelf.dataList replaceObjectAtIndex:i withObject:goodsOrder];
                    break;
                }
            }
        } else {
            for (int i=0; i<weakSelf.dataList.count; i++) {
                TCOrder *order = weakSelf.dataList[i];
                if ([order.ID isEqualToString:goodsOrder.ID]) {
                    [weakSelf.dataList removeObjectAtIndex:i];
                    break;
                }
            }
        }
        [weakSelf.collectionView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    if (self.fromController) {
        [self.navigationController popToViewController:self.fromController animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Override Methods

- (NSMutableArray *)dataList {
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
