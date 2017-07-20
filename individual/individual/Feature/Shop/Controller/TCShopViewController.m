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

@interface TCShopViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCStoreWrapper *storeWrapper;

@property (copy, nonatomic) NSArray *stores;

@end

@implementation TCShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self setUpViews];
    [self loadDataIsMore:NO];
}

- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
    }];
}

- (void)loadDataIsMore:(BOOL)isMore {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchStoreListWithSellingPointId:nil limitSize:0 sortSkip:0 sort:nil result:^(TCStoreWrapper *storeWrapper, NSError *error) {
        @StrongObj(self)
        if (storeWrapper) {
            [MBProgressHUD hideHUD:YES];
            self.storeWrapper = storeWrapper;
            
            if (!storeWrapper.hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (isMore) {
                NSMutableArray *mutableArr = [NSMutableArray arrayWithArray:self.stores];
                [mutableArr addObjectsFromArray:storeWrapper.content];
                self.stores = mutableArr;
                [self.tableView.mj_footer endRefreshing];
            }else {
                self.stores = storeWrapper.content;
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer.hidden = NO;
            }
            [self.tableView reloadData];
            
        }else {
            if (isMore) {
                [self.tableView.mj_footer endRefreshing];
            }else {
                [self.tableView.mj_header endRefreshing];
            }
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
    vc.storeID = store.ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupTableViewRefreshView {
    @WeakObj(self)
    TCRefreshHeader *refreshHeader = [TCRefreshHeader headerWithRefreshingBlock:^(void) {
        @StrongObj(self)
        [self loadDataIsMore:NO];
    }];
    _tableView.mj_header = refreshHeader;
    
    TCRefreshFooter *refreshFooter = [TCRefreshFooter footerWithRefreshingBlock:^(void) {
        @StrongObj(self)
        if (self.storeWrapper.hasMore) {
            [self loadDataIsMore:YES];
        }else {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    refreshFooter.hidden = YES;
    _tableView.mj_footer = refreshFooter;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        CGFloat width = self.view.bounds.size.width;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TCStoreCell class] forCellReuseIdentifier:@"TCStoreCell"];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, TCRealValue(48))];
        _tableView.tableHeaderView = headerView;
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = @"向你推荐";
        label1.font = [UIFont systemFontOfSize:12];
        label1.textColor = TCGrayColor;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.frame = CGRectMake(0, TCRealValue(10), width, 15);
        [headerView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label1.frame), width, 10)];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.textColor = TCLightGrayColor;
        label2.text = @"美味就是要分享";
        label2.font = [UIFont systemFontOfSize:9];
        [headerView addSubview:label2];
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
