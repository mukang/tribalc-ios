//
//  TCMeetingRoomBookingDetailViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/10/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomBookingDetailViewController.h"

#import "TCBookingDetailOrderNumAndStatusCell.h"
#import "TCBookingDetailNameAndTimeCell.h"
#import "TCBookingDetailSchedulerCell.h"
#import "TCBookingDetailMenbersAndDevicesCell.h"
#import "TCMeetingRoomReservationCancelView.h"

#import "TCBuluoApi.h"
#import "TCMeetingRoomReservationDetail.h"

#import <UITableView+FDTemplateLayoutCell.h>

@interface TCMeetingRoomBookingDetailViewController ()<UITableViewDelegate,UITableViewDataSource,TCMeetingRoomReservationCancelViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *leftBtn;

@property (strong, nonatomic) UIButton *rightBtn;

@property (strong, nonatomic) TCMeetingRoomReservationCancelView *cancelView;

@property (strong, nonatomic) TCMeetingRoomReservationDetail *meetingRoomReservationDetail;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TCMeetingRoomBookingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    [self loadData];
}

- (void)loadData {
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchMeetingRoomReservationDetailWithID:self.reservationID result:^(TCMeetingRoomReservationDetail *meetingRoomReservationDetail, NSError *error) {
        @StrongObj(self)
        if (meetingRoomReservationDetail) {
            [MBProgressHUD hideHUD:YES];
            self.meetingRoomReservationDetail = meetingRoomReservationDetail;
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];
}

- (void)handleCancelClick {
    [self.navigationController.view addSubview:self.cancelView];
    [self.cancelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.navigationController.view);
    }];
}

#pragma mark TCMeetingRoomReservationCancelViewDelegate

- (void)cancelViewDidClickCancelBtn {
    [self.cancelView removeFromSuperview];
    [MBProgressHUD showHUD:YES];
    @WeakObj(self)
    [[TCBuluoApi api] cancelMeetingRoomReservationWithID:@"" result:^(BOOL isSuccess, NSError *error) {
        @StrongObj(self)
        if (isSuccess) {
            [MBProgressHUD hideHUD:YES];
            if (self.block) {
                self.block();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"取消失败，%@", reason]];
        }
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        TCBookingDetailOrderNumAndStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBookingDetailOrderNumAndStatusCell" forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 1) {
        TCBookingDetailNameAndTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBookingDetailNameAndTimeCell" forIndexPath:indexPath];
        cell.meetingRoomReservationDetail = self.meetingRoomReservationDetail;
        return cell;
    }else if (indexPath.section == 2) {
        TCBookingDetailSchedulerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBookingDetailSchedulerCell" forIndexPath:indexPath];
        cell.title = @"预定人：";
        cell.content = [NSString stringWithFormat:@"%@  %@",self.meetingRoomReservationDetail.personName,self.meetingRoomReservationDetail.personPhone];
        return cell;
    }else if (indexPath.section == 3) {
        TCBookingDetailSchedulerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBookingDetailSchedulerCell" forIndexPath:indexPath];
        cell.title = @"会议主旨";
        cell.content = self.meetingRoomReservationDetail.subject;
        return cell;
    }else if (indexPath.section == 4) {
        TCBookingDetailMenbersAndDevicesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBookingDetailMenbersAndDevicesCell" forIndexPath:indexPath];
        cell.meetingRoomReservationDetail = self.meetingRoomReservationDetail;
        return cell;
    }else if (indexPath.section == 5) {
        TCBookingDetailSchedulerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBookingDetailSchedulerCell" forIndexPath:indexPath];
        cell.title = @"支付类型";
        cell.content = @"企业支付";
        return cell;
    }else if (indexPath.section == 6) {
        TCBookingDetailSchedulerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBookingDetailSchedulerCell" forIndexPath:indexPath];
        cell.title = @"费用估计";
        cell.content = [NSString stringWithFormat:@"¥%@",@(self.meetingRoomReservationDetail.totalFee)];
        return cell;
    }else {
        TCBookingDetailSchedulerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBookingDetailSchedulerCell" forIndexPath:indexPath];
        cell.title = @"下单时间";
        cell.content = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.meetingRoomReservationDetail.createTime/1000]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 4) {
        return [tableView fd_heightForCellWithIdentifier:@"TCBookingDetailMenbersAndDevicesCell" configuration:^(TCBookingDetailMenbersAndDevicesCell *cell) {
            cell.meetingRoomReservationDetail = self.meetingRoomReservationDetail;
        }];
    }
    
    if (indexPath.section == 1) {
        return [tableView fd_heightForCellWithIdentifier:@"TCBookingDetailNameAndTimeCell" configuration:^(TCBookingDetailNameAndTimeCell *cell) {
            cell.meetingRoomReservationDetail = self.meetingRoomReservationDetail;
        }];
    }
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }else {
        return 8;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = TCRGBColor(243, 243, 243);
    return view;
}

#pragma mark UITableViewDelegate

- (void)setUpViews {
    self.view.backgroundColor = TCRGBColor(239, 245, 245);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.leftBtn.mas_top);
    }];
    
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.right.equalTo(self.rightBtn.mas_left);
        make.height.equalTo(@49);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftBtn.mas_right);
        make.bottom.width.height.equalTo(self.leftBtn);
        make.right.equalTo(self.view);
    }];
}

- (TCMeetingRoomReservationCancelView *)cancelView {
    if (_cancelView == nil) {
        _cancelView = [[TCMeetingRoomReservationCancelView alloc] init];
        _cancelView.delegate = self;
    }
    return _cancelView;
}

- (UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"修   改" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setBackgroundColor:TCRGBColor(111, 128, 217)];
    }
    return _rightBtn;
}

- (UIButton *)leftBtn {
    if (_leftBtn == nil) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_leftBtn setBackgroundColor:TCRGBColor(149, 168, 233)];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(handleCancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[TCBookingDetailOrderNumAndStatusCell class] forCellReuseIdentifier:@"TCBookingDetailOrderNumAndStatusCell"];
        [_tableView registerClass:[TCBookingDetailNameAndTimeCell class] forCellReuseIdentifier:@"TCBookingDetailNameAndTimeCell"];
        [_tableView registerClass:[TCBookingDetailSchedulerCell class] forCellReuseIdentifier:@"TCBookingDetailSchedulerCell"];
        [_tableView registerClass:[TCBookingDetailMenbersAndDevicesCell class] forCellReuseIdentifier:@"TCBookingDetailMenbersAndDevicesCell"];
        _tableView.backgroundColor = TCRGBColor(239, 245, 245);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 80)];
        footerLabel.text = @"您可以在会议开始30分钟前取消订单";
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.font = [UIFont systemFontOfSize:12];
        footerLabel.textColor = TCGrayColor;
        footerLabel.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = footerLabel;
    }
    return _tableView;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
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
