//
//  TCMeetingRoomBookingDetailViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/10/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomBookingDetailViewController.h"
#import "TCMeetingRoomViewController.h"
#import "TCMeetingRoomContactsViewController.h"

#import "TCBookingDetailOrderNumAndStatusCell.h"
#import "TCBookingDetailNameAndTimeCell.h"
#import "TCBookingDetailSchedulerCell.h"
#import "TCBookingDetailMenbersAndDevicesCell.h"
#import "TCMeetingRoomReservationCancelView.h"

#import "TCBuluoApi.h"
#import "TCMeetingRoomReservationDetail.h"

#import <UITableView+FDTemplateLayoutCell.h>
#import <TCCommonLibs/TCDatePickerView.h>

@interface TCMeetingRoomBookingDetailViewController ()<UITableViewDelegate,UITableViewDataSource,
TCMeetingRoomReservationCancelViewDelegate,
TCDatePickerViewDelegate,
TCBookingDetailMenbersAndDevicesCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *leftBtn;

@property (strong, nonatomic) UIButton *rightBtn;

@property (strong, nonatomic) TCMeetingRoomReservationCancelView *cancelView;

@property (strong, nonatomic) TCMeetingRoomReservationDetail *meetingRoomReservationDetail;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) NSTimer *timer;

@property (assign, nonatomic) int64_t maxDelayTime;

@property (strong, nonatomic) TCDatePickerView *datePickerView;

@end

@implementation TCMeetingRoomBookingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
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

- (void)setMeetingRoomReservationDetail:(TCMeetingRoomReservationDetail *)meetingRoomReservationDetail {
    _meetingRoomReservationDetail = meetingRoomReservationDetail;
    
    if (self.isCompany) {
        self.title = @"已完成";
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        return;
    }
    
    NSString *status = meetingRoomReservationDetail.status;
    if ([status isKindOfClass:[NSString class]]) {
        if ([status isEqualToString:@"CANCEL"] || [status isEqualToString:@"PAYED"] || [status isEqualToString:@"PUTOFF_AND_PAYED"]) { //已完成 已延期完成 已取消
        self.leftBtn.hidden = YES;
        self.leftBtn.hidden = YES;
            if ([status isEqualToString:@"CANCEL"]) {
                self.title = @"已取消";
            }else {
                self.title = @"已完成";
            }
            
        }
        return;
    }
    
    NSTimeInterval currentDateTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval cha = meetingRoomReservationDetail.conferenceBeginTime/1000 - currentDateTimeInterval;
    NSInteger min = cha / 60;
    if (min < 30 && min >= 0) {
        self.title = @"预定成功";
        self.leftBtn.enabled = NO;
        self.rightBtn.enabled = NO;
    }else if (min < 0) {
        self.title = @"已开始";
        self.leftBtn.enabled = NO;
        self.rightBtn.enabled = YES;
        //延期
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }else {
        self.title = @"预定成功";
        self.leftBtn.enabled = YES;
        self.rightBtn.enabled = YES;
    }
    
    NSTimeInterval endCha = currentDateTimeInterval - meetingRoomReservationDetail.conferenceEndTime/1000;
    if (endCha >= 0) {
        self.title = @"已结束";
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }
    
}

- (void)modifyOrDelay {
    int64_t startT = self.meetingRoomReservationDetail.conferenceBeginTime/1000;
    int64_t currentT = [[NSDate date] timeIntervalSince1970];
    if (startT > currentT) {  // 修改
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        
        TCMeetingRoomViewController *meetingRoomVC = [[TCMeetingRoomViewController alloc] init];
        meetingRoomVC.meetingRoomReservationDetail = self.meetingRoomReservationDetail;
        meetingRoomVC.startDate = currentDate;
        meetingRoomVC.endDate = [calendar dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentDate options:0];
        meetingRoomVC.modifyBlock = ^{
            [self loadData];
        };
        [self.navigationController pushViewController:meetingRoomVC animated:YES];
    }else {  // 延期
        [MBProgressHUD showHUD:YES];
        @WeakObj(self)
         [[TCBuluoApi api] fetchMeetingRoomReservationDelayTimeWithID:self.meetingRoomReservationDetail.ID result:^(int64_t delayTime, NSError *error) {
            @StrongObj(self)
             if (delayTime) {
                 self.maxDelayTime = delayTime;
                 if (delayTime > self.meetingRoomReservationDetail.conferenceEndTime) {
                     [MBProgressHUD hideHUD:YES];
                     self.datePickerView.datePicker.maximumDate = [NSDate dateWithTimeIntervalSince1970:delayTime/1000];
                     [self.datePickerView show];
                 }else {
                     [MBProgressHUD showHUDWithMessage:@"无法延迟" afterDelay:1.0];
                 }
             }else {
                 NSString *reason = error.localizedDescription ?: @"请稍后再试";
                 [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
             }
         }];
    }
}

- (void)updateRightBtn {
    NSTimeInterval currentT = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval chaT = self.meetingRoomReservationDetail.conferenceEndTime/1000 - currentT;
    if (chaT < 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        self.title = @"已结束";
        return;
    }
    NSInteger hour = chaT / 3600;
    NSInteger min = ((int64_t)chaT % 3600)/60;
    NSInteger sec = ((int64_t)chaT % 3600)%60;
    NSString *hourStr = hour ? [NSString stringWithFormat:@"%ld:",(long)hour] : @"";
    NSString *timeStr = [NSString stringWithFormat:@"%@%.2ld:%.2ld",hourStr,(long)min,(long)sec];
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@  %@",timeStr,@"延期"]];
    NSTextAttachment *nameAttch = [[NSTextAttachment alloc] init];
    nameAttch.bounds = CGRectMake(0, -1, 11, 11);
    nameAttch.image = [UIImage imageNamed:@"meeting_room_timer_icon"];
    NSAttributedString *nameStr = [NSAttributedString attributedStringWithAttachment:nameAttch];
    NSMutableAttributedString *mutableNameStr = [[NSMutableAttributedString alloc] initWithAttributedString:nameStr];
    [mutableNameStr appendAttributedString:attStr];
    
    [self.rightBtn setAttributedTitle:mutableNameStr forState:UIControlStateNormal];
}

#pragma mark TCDatePickerViewDelegate

- (void)didClickConfirmButtonInDatePickerView:(TCDatePickerView *)view {
    NSTimeInterval timestamp = [view.datePicker.date timeIntervalSince1970];
    // 调延迟接口
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] delayMeetingRoomReservationWithID:self.meetingRoomReservationDetail.ID delayTime:timestamp result:^(BOOL isSuccess, NSError *error) {
     @StrongObj(self)
        if (isSuccess) {
            [MBProgressHUD showHUDWithMessage:@"延迟成功" afterDelay:1.0];
            [self loadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"延迟失败，%@", reason]];
        }
    }];
}

#pragma mark TCMeetingRoomReservationCancelViewDelegate

- (void)cancelViewDidClickCancelBtn {
    [self.cancelView removeFromSuperview];
    [MBProgressHUD showHUD:YES];
    @WeakObj(self)
    [[TCBuluoApi api] cancelMeetingRoomReservationWithID:self.meetingRoomReservationDetail.ID result:^(BOOL isSuccess, NSError *error) {
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
    if (self.meetingRoomReservationDetail.planEndTime != self.meetingRoomReservationDetail.conferenceEndTime) {
        return 9;
    }
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
        cell.delegate = self;
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
    }else if (indexPath.section == 7) {
        TCBookingDetailSchedulerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBookingDetailSchedulerCell" forIndexPath:indexPath];
        cell.title = @"下单时间";
        cell.content = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.meetingRoomReservationDetail.createTime/1000]];
        return cell;
    }else {
        TCBookingDetailSchedulerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBookingDetailSchedulerCell" forIndexPath:indexPath];
        cell.title = @"延迟时间";
        cell.content = [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.meetingRoomReservationDetail.conferenceEndTime/1000]];
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

#pragma mark TCBookingDetailMenbersAndDevicesCellDelegate

- (void)didClickShowParticipants {
    TCMeetingRoomContactsViewController *contactsVC = [[TCMeetingRoomContactsViewController alloc] initWithControllerType:TCMeetingRoomContactsViewControllerTypeShow];
    contactsVC.participants = [NSMutableArray arrayWithArray:self.meetingRoomReservationDetail.conferenceParticipants];
    [self.navigationController pushViewController:contactsVC animated:YES];
}

#pragma mark UITableViewDelegate

- (void)setUpViews {
    self.view.backgroundColor = TCRGBColor(239, 245, 245);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
//        make.bottom.equalTo(self.leftBtn.mas_top);
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
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn addTarget:self action:@selector(modifyOrDelay) forControlEvents:UIControlEventTouchUpInside];
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
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
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
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 80+49)];
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

- (NSTimer *)timer {
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateRightBtn) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (TCDatePickerView *)datePickerView {
    if (_datePickerView == nil) {
        _datePickerView = [[TCDatePickerView alloc] initWithController:self];
        _datePickerView.datePicker.date = [NSDate date];
        
        _datePickerView.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        _datePickerView.datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:self.meetingRoomReservationDetail.conferenceEndTime/1000];
        _datePickerView.datePicker.minuteInterval = 30;
        _datePickerView.delegate = self;
    }
    return _datePickerView;
}

- (void)dealloc {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    NSLog(@"--- TCMeetingRoomBookingDetailViewController --- dealloc ");
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
