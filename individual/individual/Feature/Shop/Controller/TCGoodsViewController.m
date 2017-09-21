//
//  TCGoodsViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/9/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsViewController.h"
#import "TCGoodsDetailViewController.h"
#import "TCStoreGoodsCell.h"
#import "TCBuluoApi.h"

#import <MJRefresh/MJRefresh.h>


@interface TCGoodsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCGoodsWrapper *goodsWrapper;

@property (strong, nonatomic) NSMutableArray *mutableGoodsArr;

@end

@implementation TCGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    [self loadData];
}

- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TCGoods *goodInfo = self.mutableGoodsArr[indexPath.row];
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

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mutableGoodsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCStoreGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreGoodsCell" forIndexPath:indexPath];
    cell.goods = self.mutableGoodsArr[indexPath.row];
    return cell;
}

- (void)loadData {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi alloc] fetchGoodsWrapper:20 sortSkip:nil storeId:self.storeId result:^(TCGoodsWrapper *goodsWrapper, NSError *error) {
        @StrongObj(self)
        [self.tableView.mj_header endRefreshing];
        if (goodsWrapper) {
            [MBProgressHUD hideHUD:YES];
            [self.mutableGoodsArr removeAllObjects];
            self.goodsWrapper = goodsWrapper;
            if ([goodsWrapper.content isKindOfClass:[NSArray class]]) {
                [self.mutableGoodsArr addObjectsFromArray:goodsWrapper.content];
            }
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请退出该页面重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

- (void)loadOldData {
    @WeakObj(self)
    [[TCBuluoApi alloc] fetchGoodsWrapper:20 sortSkip:self.goodsWrapper.nextSkip storeId:self.storeId result:^(TCGoodsWrapper *goodsWrapper, NSError *error) {
        @StrongObj(self)
        [self.tableView.mj_footer endRefreshing];
        if (goodsWrapper) {
            if (!goodsWrapper.hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            self.goodsWrapper = goodsWrapper;
            if ([goodsWrapper.content isKindOfClass:[NSArray class]]) {
                [self.mutableGoodsArr addObjectsFromArray:goodsWrapper.content];
            }
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请退出该页面重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

- (NSMutableArray *)mutableGoodsArr {
    if (_mutableGoodsArr == nil) {
        _mutableGoodsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _mutableGoodsArr;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 112.5;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TCStoreGoodsCell class] forCellReuseIdentifier:@"TCStoreGoodsCell"];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 11)];
        view.backgroundColor = TCRGBColor(239, 245, 245);
        [_tableView addSubview:view];
        
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
        refreshFooter.stateLabel.textColor = TCGrayColor;
        refreshFooter.stateLabel.font = [UIFont systemFontOfSize:14];
        [refreshFooter setTitle:@"-我是有底线的-" forState:MJRefreshStateNoMoreData];
        refreshFooter.hidden = YES;
        _tableView.mj_footer = refreshFooter;
        
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        refreshHeader.stateLabel.textColor = TCBlackColor;
        refreshHeader.stateLabel.font = [UIFont systemFontOfSize:14];
        refreshHeader.lastUpdatedTimeLabel.textColor = TCBlackColor;
        refreshHeader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        _tableView.mj_header = refreshHeader;
        
    }
    return _tableView;
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
