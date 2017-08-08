//
//  TCRentPlanItemsViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRentPlanItemsViewController.h"
#import "TCApartmentPayViewController.h"
#import "TCCompanyRentPayViewController.h"

#import "TCRentPlanItemsHeaderView.h"
#import "TCRentPlanItemViewCell.h"

#import "TCBuluoApi.h"

@interface TCRentPlanItemsViewController () <UITableViewDataSource, UITableViewDelegate, TCRentPlanItemViewCellDelegate>

@property (copy, nonatomic) NSArray *planItems;

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCRentPlanItemsViewController {
    __weak TCRentPlanItemsViewController *weakSelf;
}

- (instancetype)initWithRentPlanItemsType:(TCRentPlanItemsType)type {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"付款计划";
    self.view.backgroundColor = TCBackgroundColor;
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadRentPlanItems];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCRentPlanItemViewCell class] forCellReuseIdentifier:@"TCRentPlanItemViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    if (self.type == TCRentPlanItemsTypeIndividual) {
        TCRentPlanItemsHeaderView *headerView = [[TCRentPlanItemsHeaderView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 71)];
        headerView.rentProtocol = self.rentProtocol;
        self.tableView.tableHeaderView = headerView;
    } else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 40)];
        headerView.backgroundColor = [UIColor whiteColor];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = self.companyName;
        nameLabel.textColor = TCBlackColor;
        nameLabel.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:nameLabel];
        self.tableView.tableHeaderView = headerView;
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(20);
            make.centerY.equalTo(headerView);
        }];
    }
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
}

- (void)loadRentPlanItems {
    [MBProgressHUD showHUD:YES];
    NSString *rentProtocolID = (self.type == TCRentPlanItemsTypeIndividual) ? self.rentProtocol.ID : self.rentProtocolID;
    [[TCBuluoApi api] fetchRentPlanItemListByRentProtocolID:rentProtocolID result:^(NSArray *rentPlanItemList, NSError *error) {
        if (rentPlanItemList) {
            [MBProgressHUD hideHUD:YES];
            TCRentPlanItem *lastPlanItem = nil;
            for (int i=0; i<rentPlanItemList.count; i++) {
                TCRentPlanItem *planItem = rentPlanItemList[i];
                if (planItem.finished == NO && (lastPlanItem.finished || !lastPlanItem)) {
                    planItem.currentItem = YES;
                } else {
                    planItem.currentItem = NO;
                }
                lastPlanItem = planItem;
            }
            weakSelf.planItems = rentPlanItemList;
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.planItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCRentPlanItemViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRentPlanItemViewCell" forIndexPath:indexPath];
    TCRentPlanItem *item = self.planItems[indexPath.row];
    cell.planItem = item;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - TCRentPlanItemViewCellDelegate

- (void)rentPlanItemViewCell:(TCRentPlanItemViewCell *)cell didClickPayButtonWithPlanItem:(TCRentPlanItem *)planItem {
    if (self.type == TCRentPlanItemsTypeIndividual) {
        TCApartmentPayViewController *vc = [[TCApartmentPayViewController alloc] init];
        vc.rentProtocol = self.rentProtocol;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        TCCompanyRentPayViewController *vc = [[TCCompanyRentPayViewController alloc] init];
        vc.companyID = self.companyID;
        vc.companyName = self.companyName;
        [self.navigationController pushViewController:vc animated:YES];
    }
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
