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
#import "TCUserReserveDetailViewController.h"
#import "TCComponent.h"
#import "TCBuluoApi.h"
#import "TCRecommendHeader.h"
#import "TCRecommendFooter.h"

@interface TCUserReserveViewController ()

@end

@implementation TCUserReserveViewController {
    TCReservationWrapper *userReserveWrapper;
//    NSArray *userReserveOrderArr;
    UITableView *reserveTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initReservationData];
    
    [self initNavigationBar];
    [self initTableView];
    
}


- (void)initReservationData {
    [[TCBuluoApi api] fetchReservationWrapper:nil limiSize:10 sortSkip:nil result:^(TCReservationWrapper *wrapper, NSError *error) {
        userReserveWrapper = wrapper;
        
        [reserveTableView reloadData];
        [reserveTableView.mj_header endRefreshing];
        
    }];
}

- (void)loadReservationData {
    [[TCBuluoApi api] fetchReservationWrapper:nil limiSize:10 sortSkip:userReserveWrapper.nextSkip result:^(TCReservationWrapper *wrapper, NSError *error) {
        
        if (userReserveWrapper.hasMore) {
            NSArray *contentArr = userReserveWrapper.content;
            userReserveWrapper = wrapper;
            userReserveWrapper.content = [contentArr arrayByAddingObjectsFromArray:wrapper.content];
            
            [reserveTableView reloadData];
        } else {
            TCRecommendFooter *footer = (TCRecommendFooter *)reserveTableView.mj_footer;
            [footer setTitle:@"已加载全部" forState:MJRefreshStateRefreshing];
        }
        [reserveTableView.mj_footer endRefreshing];

    }];

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
    [self initRefreshTableView];
    
    [self.view addSubview:reserveTableView];
    
}

- (void)initRefreshTableView {
    TCRecommendHeader *refreshHeader = [TCRecommendHeader headerWithRefreshingBlock:^(void) {
        [self initReservationData];
    }];
    reserveTableView.mj_header = refreshHeader;
    
    TCRecommendFooter *refreshFooter = [TCRecommendFooter footerWithRefreshingBlock:^(void) {
        [self loadReservationData];
    }];
    reserveTableView.mj_footer = refreshFooter;
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
    NSArray *reserveArr = userReserveWrapper.content;
    return reserveArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *identifier = [NSString stringWithFormat:@"header%li", (long)section];
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:identifier];
    }
    NSArray *userReserveOrderArr = userReserveWrapper.content;
    TCReservation *reservation = userReserveOrderArr[section];
    UILabel *statusLab = [TCComponent createLabelWithFrame:CGRectMake(22.5, 0, TCScreenWidth - 45, 42) AndFontSize:14 AndTitle:reservation.status];
    statusLab.textColor = [self getHeaderStatusTextColor:statusLab.text];
    [headerView addSubview:statusLab];
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 42 - 0.5, TCScreenWidth, 0.5)];
    [headerView addSubview:topLineView];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *identifier = [NSString stringWithFormat:@"footer%li", (long)section];
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
    NSString *identifier = [NSString stringWithFormat:@"cell%li", (long)indexPath.section];
    TCUserReserveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TCUserReserveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSArray *userReserveOrderArr = userReserveWrapper.content;
    TCReservation *reservation = userReserveOrderArr[indexPath.section];
    cell.storeImageView.image = [UIImage imageNamed:@"good_placeholder"];
    [cell setTitleLabText:reservation.storeName];
    [cell setBrandLabText:@"西餐"];
    [cell setPlaceLabText:reservation.markPlace];
    cell.timeLab.text = @"2016-11-01 16:05";
    cell.personNumberLab.text = [NSString stringWithFormat:@"%li", (long)reservation.personNum];
    
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
    
    TCReservation *reservation = userReserveWrapper.content[indexPath.section];
    TCUserReserveDetailViewController *reserveDetailViewController = [[TCUserReserveDetailViewController alloc] initWithReservationId:reservation.ID];
    [self.navigationController pushViewController:reserveDetailViewController animated:YES];
}

#pragma mark - Click

- (void)touchBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
