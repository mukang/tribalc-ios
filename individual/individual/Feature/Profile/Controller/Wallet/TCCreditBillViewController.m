//
//  TCCreditBillViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreditBillViewController.h"
#import "TCCreditBillViewCell.h"
#import "TCBuluoApi.h"
#import <TCCommonLibs/TCRefreshHeader.h>
#import <TCCommonLibs/TCRefreshFooter.h>

@interface TCCreditBillViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (copy, nonatomic) NSString *sortSkip;

@property (strong, nonatomic) NSMutableArray *dataList;

@property (assign, nonatomic) int64_t sinceTime;

@end

@implementation TCCreditBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史账单";
    // Do any additional setup after loading the view.
    [self setUpViews];
}

- (void)loadDataFirstTime {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    
    [[TCBuluoApi api] fetchCreditBillListByWalletID:self.walletID limit:20 sinceTime:nil result:^(TCCreditBillWrapper *creditBillWrapper, NSError *error) {
        @StrongObj(self)
        if (creditBillWrapper) {
            [MBProgressHUD hideHUD:YES];
            self.sortSkip = creditBillWrapper.nextSkip;
            if (creditBillWrapper.hasMore) {
                self.tableView.mj_footer.hidden = NO;
            }
            [self.dataList removeAllObjects];
            for (TCCreditBill *creditBill in creditBillWrapper.content) {
                NSMutableArray *temp = [self.dataList lastObject];
                if (!temp) {
                    temp = [NSMutableArray array];
                    [temp addObject:creditBill];
                    [self.dataList addObject:temp];
                } else {
                    TCWalletBill *lastBill = [temp lastObject];
                    if ([creditBill.monthDate isEqualToString:lastBill.monthDate]) {
                        [temp addObject:creditBill];
                    } else {
                        NSMutableArray *newTemp = [NSMutableArray array];
                        [newTemp addObject:creditBill];
                        [self.dataList addObject:newTemp];
                    }
                }
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取订单失败！"];
        }
    }];
}

- (void)loadNewData {
    @WeakObj(self)
    [[TCBuluoApi api] fetchCreditBillListByWalletID:self.walletID limit:20 sinceTime:nil result:^(TCCreditBillWrapper *creditBillWrapper, NSError *error) {
        @StrongObj(self)
        [self.tableView.mj_header endRefreshing];
        if (creditBillWrapper) {
            self.sortSkip = creditBillWrapper.nextSkip;
            if (creditBillWrapper.hasMore) {
                self.tableView.mj_footer.hidden = NO;
            }
            [self.dataList removeAllObjects];
            for (TCCreditBill *creditBill in creditBillWrapper.content) {
                NSMutableArray *temp = [self.dataList lastObject];
                if (!temp) {
                    temp = [NSMutableArray array];
                    [temp addObject:creditBill];
                    [self.dataList addObject:temp];
                } else {
                    TCWalletBill *lastBill = [temp lastObject];
                    if ([creditBill.monthDate isEqualToString:lastBill.monthDate]) {
                        [temp addObject:creditBill];
                    } else {
                        NSMutableArray *newTemp = [NSMutableArray array];
                        [newTemp addObject:creditBill];
                        [self.dataList addObject:newTemp];
                    }
                }
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取帐单失败！"];
        }
    }];
}

- (void)loadOldData {
    @WeakObj(self)
    [[TCBuluoApi api] fetchCreditBillListByWalletID:self.walletID limit:20 sinceTime:self.sortSkip result:^(TCCreditBillWrapper *creditBillWrapper, NSError *error) {
        @StrongObj(self)
        [self.tableView.mj_footer endRefreshing];
        if (creditBillWrapper) {
            self.sortSkip = creditBillWrapper.nextSkip;
            if (!creditBillWrapper.hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            for (TCCreditBill *creditBill in creditBillWrapper.content) {
                NSMutableArray *temp = [self.dataList lastObject];
                if (!temp) {
                    temp = [NSMutableArray array];
                    [temp addObject:creditBill];
                    [self.dataList addObject:temp];
                } else {
                    TCWalletBill *lastBill = [temp lastObject];
                    if ([creditBill.monthDate isEqualToString:lastBill.monthDate]) {
                        [temp addObject:creditBill];
                    } else {
                        NSMutableArray *newTemp = [NSMutableArray array];
                        [newTemp addObject:creditBill];
                        [self.dataList addObject:newTemp];
                    }
                }
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取帐单失败！"];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 23;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *temp = self.dataList[section];
    return temp.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCCreditBillViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCreditBillViewCell" forIndexPath:indexPath];
    NSMutableArray *temp = self.dataList[indexPath.section];
    cell.creditBill = temp[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSMutableArray *temp = self.dataList[section];
    TCCreditBill *walletBill = temp[0];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = TCBackgroundColor;
    UILabel *label = [[UILabel alloc] init];
    label.text = walletBill.yearDate;
    label.textColor = TCBlackColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.frame = CGRectMake(20, 0, 100, 23);
    [view addSubview:label];
    return view;
}

- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, CGFLOAT_MIN)];
        _tableView.tableHeaderView = headerView;
        [_tableView registerClass:[TCCreditBillViewCell class] forCellReuseIdentifier:@"TCCreditBillViewCell"];
        _tableView.mj_header = [TCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_footer = [TCRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
        _tableView.mj_footer.hidden = YES;
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
