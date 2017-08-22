//
//  TCShopViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/7/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCShopViewController.h"
#import "TCStoreDetailViewController.h"

#import "TCBuluoApi.h"
#import "TCStoreCell.h"
#import "TCStoreWrapper.h"
#import <TCCommonLibs/TCRefreshHeader.h>
#import <TCCommonLibs/TCRefreshFooter.h>
#import "TCStoreDetailViewController.h"

@interface TCShopViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCStoreWrapper *storeWrapper;

@property (copy, nonatomic) NSArray *stores;

@end

@implementation TCShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = nil;
    [self setUpViews];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessOrFail) name:TCBuluoApiNotificationUserDidLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:TCBuluoApiNotificationUserDidLogout object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark private action

- (void)logOut {
    self.stores = nil;
    [self.tableView reloadData];
}

- (void)loginSuccessOrFail {
    self.stores = nil;
    [self.tableView reloadData];
    [self loadData];
}

- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}

- (void)loadData {
    @WeakObj(self)
    [[TCBuluoApi api] fetchStoreListWithSellingPointId:nil limitSize:0 sortSkip:0 sort:nil result:^(TCStoreWrapper *storeWrapper, NSError *error) {
        @StrongObj(self)
        if (storeWrapper) {
            self.storeWrapper = storeWrapper;
            self.stores = storeWrapper.content;
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
            if ([self.stores isKindOfClass:[NSArray class]] && self.stores.count > 0) {
                self.tableView.mj_footer.hidden = NO;
            }else {
                self.tableView.mj_footer.hidden = YES;
            }
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];

}

- (void)loadOldData {
    @WeakObj(self)
    [[TCBuluoApi api] fetchStoreListWithSellingPointId:nil limitSize:0 sortSkip:self.storeWrapper.nextSkip sort:nil result:^(TCStoreWrapper *storeWrapper, NSError *error) {
        @StrongObj(self)
        if (storeWrapper) {
            self.storeWrapper = storeWrapper;
            if (!storeWrapper.hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.stores];
            [mutableArr addObjectsFromArray:storeWrapper.content];
            self.stores = mutableArr;
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }else {
            [self.tableView.mj_footer endRefreshing];
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];
}

#pragma mark UITableViewDelegate 

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.stores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCStoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStoreCell" forIndexPath:indexPath];
    cell.store = self.stores[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TCListStore *store = self.stores[indexPath.row];
    TCStoreDetailViewController *vc = [[TCStoreDetailViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.storeID = store.ID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark Getter

- (void)setupTableViewRefreshView {
    @WeakObj(self)
    TCRefreshHeader *refreshHeader = [TCRefreshHeader headerWithRefreshingBlock:^(void) {
        @StrongObj(self)
        [self loadData];
    }];
    _tableView.mj_header = refreshHeader;
    
    TCRefreshFooter *refreshFooter = [TCRefreshFooter footerWithRefreshingBlock:^(void) {
        @StrongObj(self)
        if (self.storeWrapper.hasMore) {
            [self loadOldData];
        }else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    refreshFooter.hidden = YES;
    _tableView.mj_footer = refreshFooter;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
//        CGFloat width = self.view.bounds.size.width;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = TCRealValue(252);
        [_tableView registerClass:[TCStoreCell class] forCellReuseIdentifier:@"TCStoreCell"];
        [self setupTableViewRefreshView];
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, TCRealValue(48))];
//        _tableView.tableHeaderView = headerView;
//        
//        UILabel *label1 = [[UILabel alloc] init];
//        label1.text = @"向·你·推·荐";
//        label1.font = [UIFont systemFontOfSize:12];
//        label1.textColor = TCGrayColor;
//        label1.textAlignment = NSTextAlignmentCenter;
//        label1.frame = CGRectMake(0, TCRealValue(10), width, 15);
//        [headerView addSubview:label1];
//        
//        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), width, 10)];
//        label2.textAlignment = NSTextAlignmentCenter;
//        label2.textColor = TCLightGrayColor;
//        label2.text = @"美味就是要分享";
//        label2.font = [UIFont systemFontOfSize:9];
//        [headerView addSubview:label2];
        
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
