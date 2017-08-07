//
//  TCPrivilegeInstructionViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPrivilegeInstructionViewController.h"

#import "TCPrivilegeInstructionViewCell.h"
#import "TCPrivilegeViewCell.h"

#import "TCBuluoApi.h"

#import <UITableView+FDTemplateLayoutCell.h>

@interface TCPrivilegeInstructionViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCListStore *storeInfo;

@end

@implementation TCPrivilegeInstructionViewController {
    __weak TCPrivilegeInstructionViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    
    [self setupSubviews];
    [self loadNetData];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(239, 244, 245);
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCPrivilegeInstructionViewCell class] forCellReuseIdentifier:@"TCPrivilegeInstructionViewCell"];
    [tableView registerClass:[TCPrivilegeViewCell class] forCellReuseIdentifier:@"TCPrivilegeViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)loadNetData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchStorePrivilegeByStoreID:self.storeID isValid:YES result:^(TCListStore *storeInfo, NSError *error) {
        if (storeInfo) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.navigationItem.title = storeInfo.storeName;
            weakSelf.storeInfo = storeInfo;
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出该页面重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.storeInfo.privileges.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    if (indexPath.section == 0) {
        TCPrivilegeInstructionViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCPrivilegeInstructionViewCell" forIndexPath:indexPath];
        cell.instructionStr = @"优惠买单仅限到店支付，请勿提前购买\n以下优惠都是能与店铺优惠同享，请您向商家咨询\n如同要发票，请您在消费时向商户咨询";
        currentCell = cell;
    } else {
        TCPrivilegeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCPrivilegeViewCell" forIndexPath:indexPath];
        cell.privilege = self.storeInfo.privileges[indexPath.row];
        currentCell = cell;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 40;
    } else {
        return [tableView fd_heightForCellWithIdentifier:@"TCPrivilegeInstructionViewCell"
                                        cacheByIndexPath:indexPath
                                           configuration:^(TCPrivilegeInstructionViewCell *cell) {
                                               cell.instructionStr = @"优惠买单仅限到店支付，请勿提前购买\n以下优惠都是能与店铺优惠同享，请您向商家咨询\n如同要发票，请您在消费时向商户咨询";
                                           }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 27;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 27)];
    containerView.backgroundColor = [UIColor clearColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = section ? @"买单优惠" : @"规则说明";
    titleLabel.textColor = TCBlackColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [containerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(containerView).offset(20);
        make.centerY.equalTo(containerView);
    }];
    
    return containerView;
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
