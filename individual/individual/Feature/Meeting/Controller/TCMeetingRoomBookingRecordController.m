//
//  TCMeetingRoomBookingRecordController.m
//  individual
//
//  Created by 王帅锋 on 2017/10/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomBookingRecordController.h"
#import "TCMeetingRoomBookingDetailViewController.h"

#import "TCMeetingRoomBookingRecordCell.h"

#import "TCMeetingRoomReservationWrapper.h"
#import "TCBuluoApi.h"

#import <MJRefresh/MJRefresh.h>

@interface TCMeetingRoomBookingRecordController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCMeetingRoomReservationWrapper *meetingRoomReservationWrapper;

@property (strong, nonatomic) NSMutableArray *meetingRoomReservationArr;

@end

@implementation TCMeetingRoomBookingRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预定记录";
    [self setUpViews];
    [self loadData];
}

- (void)loadData {
    [MBProgressHUD showHUD:YES];
    @WeakObj(self)
    [[TCBuluoApi api] fetchMeetingRoomReservationWrapperWithSortSkip:nil limitSize:20 result:^(TCMeetingRoomReservationWrapper *meetingRoomReservationWrapper, NSError *error) {
        @StrongObj(self)
        if (meetingRoomReservationWrapper) {
            [MBProgressHUD hideHUD:YES];
            self.meetingRoomReservationWrapper = meetingRoomReservationWrapper;
            if ([meetingRoomReservationWrapper.content isKindOfClass:[NSArray class]]) {
                [self.meetingRoomReservationArr addObjectsFromArray:meetingRoomReservationWrapper.content];
            }
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];
}

- (void)loadNewData {
    @WeakObj(self)
    [[TCBuluoApi api] fetchMeetingRoomReservationWrapperWithSortSkip:_meetingRoomReservationWrapper.nextSkip limitSize:20 result:^(TCMeetingRoomReservationWrapper *meetingRoomReservationWrapper, NSError *error) {
        @StrongObj(self)
        [self.tableView.mj_header endRefreshing];
        if (meetingRoomReservationWrapper) {
            [self.meetingRoomReservationArr removeAllObjects];
            self.meetingRoomReservationWrapper = meetingRoomReservationWrapper;
            if ([meetingRoomReservationWrapper.content isKindOfClass:[NSArray class]]) {
                [self.meetingRoomReservationArr addObjectsFromArray:meetingRoomReservationWrapper.content];
            }
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];
}

- (void)loadOldData {
    @WeakObj(self)
    [[TCBuluoApi api] fetchMeetingRoomReservationWrapperWithSortSkip:_meetingRoomReservationWrapper.nextSkip limitSize:20 result:^(TCMeetingRoomReservationWrapper *meetingRoomReservationWrapper, NSError *error) {
        @StrongObj(self)
        if (meetingRoomReservationWrapper) {
            self.meetingRoomReservationWrapper = meetingRoomReservationWrapper;
            if ([meetingRoomReservationWrapper.content isKindOfClass:[NSArray class]]) {
                [self.meetingRoomReservationArr addObjectsFromArray:meetingRoomReservationWrapper.content];
            }
            [self.tableView reloadData];
            if (!meetingRoomReservationWrapper.hasMore) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [self.tableView.mj_footer endRefreshing];
            }
        }else {
            [self.tableView.mj_footer endRefreshing];
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.meetingRoomReservationArr.count;
//    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMeetingRoomBookingRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomBookingRecordCell" forIndexPath:indexPath];
    cell.meetingRoomReservation = self.meetingRoomReservationArr[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 167;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = TCRGBColor(243, 243, 243);
    return view;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMeetingRoomReservation *reservation = self.meetingRoomReservationArr[indexPath.section];
    TCMeetingRoomBookingDetailViewController *detailVC = [[TCMeetingRoomBookingDetailViewController alloc] init];
    detailVC.reservationID = reservation.ID;
    detailVC.block = ^{
        [self loadNewData];
    };
    [self.navigationController pushViewController:detailVC animated:YES];
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
        _tableView.backgroundColor = TCRGBColor(243, 243, 243);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TCMeetingRoomBookingRecordCell class] forCellReuseIdentifier:@"TCMeetingRoomBookingRecordCell"];
        
        MJRefreshAutoNormalFooter *refreshFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadOldData)];
        refreshFooter.stateLabel.textColor = TCGrayColor;
        refreshFooter.stateLabel.font = [UIFont systemFontOfSize:14];
//        [refreshFooter setTitle:@"-我是有底线的-" forState:MJRefreshStateNoMoreData];
        refreshFooter.automaticallyHidden = YES;
        _tableView.mj_footer = refreshFooter;
        
        MJRefreshNormalHeader *refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        refreshHeader.stateLabel.textColor = TCBlackColor;
        refreshHeader.stateLabel.font = [UIFont systemFontOfSize:14];
        refreshHeader.lastUpdatedTimeLabel.textColor = TCBlackColor;
        refreshHeader.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
        _tableView.mj_header = refreshHeader;
    }
    return _tableView;
}

- (NSMutableArray *)meetingRoomReservationArr {
    if (_meetingRoomReservationArr == nil) {
        _meetingRoomReservationArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _meetingRoomReservationArr;
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