//
//  TCUserReserveViewController.m
//  individual
//
//  Created by WYH on 16/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUserReserveViewController.h"
#import "TCGetNavigationItem.h"
#import "TCUserReserveTableViewCell.h"
#import "TCComponent.h"

@interface TCUserReserveViewController ()

@end

@implementation TCUserReserveViewController {
    NSArray *userReserveOrderArr;
    UITableView *reserveTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self forgeData];
    [self initNavigationBar];
    [self initTableView];
    
}


- (void)initNavigationBar {
    UIButton *backBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:@"back"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn addTarget:self  action:@selector(touchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.titleView = [TCGetNavigationItem getTitleItemWithText:@"我的预订"];
}

- (void)initTableView {
    reserveTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    reserveTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    reserveTableView.delegate = self;
    reserveTableView.dataSource = self;
    reserveTableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:reserveTableView];
    
}

- (UIColor *)getHeaderStatusTextColor:(NSString *)text {
    if ([text isEqualToString:@"订座处理中"]) {
        return TCRGBColor(242, 68, 69);
    } else if ([text isEqualToString:@"订座失败"]) {
        return TCRGBColor(154, 154, 154);
    } else {
        return TCRGBColor(81, 199, 209);
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return userReserveOrderArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *identifier = [NSString stringWithFormat:@"%li", (long)section];
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    NSDictionary *orderDic = userReserveOrderArr[section];
    UILabel *statusLab = [TCComponent createLabelWithFrame:CGRectMake(22.5, 0, TCScreenWidth - 45, 42) AndFontSize:14 AndTitle:orderDic[@"status"]];
    statusLab.textColor = [self getHeaderStatusTextColor:statusLab.text];
    [headerView addSubview:statusLab];
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 42 - 0.5, TCScreenWidth, 0.5)];
    [headerView addSubview:topLineView];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *identifier = [NSString stringWithFormat:@"%li", (long)section];
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!footerView) {
        footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 7)];
    backView.backgroundColor = TCRGBColor(242, 242, 242);
    [footerView addSubview:backView];
    
    return footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%li", (long)indexPath.row];
    TCUserReserveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TCUserReserveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *orderInfo = userReserveOrderArr[indexPath.section];
    cell.storeImageView.image = [UIImage imageNamed:orderInfo[@"leftImage"]];
    [cell setTitleLabText:orderInfo[@"title"]];
    [cell setBrandLabText:orderInfo[@"brand"]];
    [cell setPlaceLabText:orderInfo[@"place"]];
    cell.timeLab.text = orderInfo[@"time"];
    cell.personNumberLab.text = orderInfo[@"number"];
    
    return cell;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 143;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 7;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Click

- (void)touchBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)forgeData {
    
    NSDictionary *dic1 = @{ @"status":@"订座处理中", @"leftImage":@"good_placeholder", @"title":@"FNRON", @"brand":@"西餐", @"place":@"安定门", @"time":@"2016-11-01 16:50", @"number":@"3" };
    
    NSDictionary *dic2 = @{ @"status":@"订座失败", @"leftImage":@"good_placeholder", @"title":@"FNdwDW失败失败失败失败失败失败失败失败失败失败DWDWDWDRON", @"brand":@"西餐", @"place":@"安定门", @"time":@"2016-11-01 16:50", @"number":@"3" };
    
    NSDictionary *dic3 = @{ @"status":@"订座成功", @"leftImage":@"good_placeholder", @"title":@"FNROOUHBIGHUWBWBHJDN", @"brand":@"西餐", @"place":@"安定门", @"time":@"2016-11-01 16:50", @"number":@"3" };
    
    NSDictionary *dic4 = @{ @"status":@"订座成功", @"leftImage":@"good_placeholder", @"title":@"FNRDHU圣诞晚dwdwwww呜呜呜呜呜呜呜呜我问问", @"brand":@"西餐", @"place":@"安定门", @"time":@"2016-11-01 16:50", @"number":@"3" };
    
    userReserveOrderArr = @[ dic1, dic2, dic3, dic4 ];
}



@end
