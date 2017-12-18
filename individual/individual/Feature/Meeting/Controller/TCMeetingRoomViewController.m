//
//  TCMeetingRoomViewController.m
//  individual
//
//  Created by 穆康 on 2017/10/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomViewController.h"
#import "TCMeetingRoomBookingTimeViewController.h"
#import "TCMeetingRoomRemindViewController.h"
#import "TCMeetingRoomContactsViewController.h"
#import "TCMeetingRoomBookingRecordController.h"

#import "TCMeetingRoomSubjectViewCell.h"
#import "TCMeetingRoomSelectViewCell.h"
#import "TCMeetingRoomSupportedViewCell.h"
#import "TCMeetingRoomInfoViewCell.h"
#import "TCMeetingRoomTitleViewCell.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <UITableView+FDTemplateLayoutCell.h>
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <TCCommonLibs/UIImage+Category.h>
#import <UIImageView+WebCache.h>

#define bookingTimeCount 30

@interface TCMeetingRoomViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TCMeetingRoomBookingTimeViewControllerDelegate, TCMeetingRoomRemindViewControllerDelegate, TCMeetingRoomContactsViewControllerDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIImageView *headerView;
@property (weak, nonatomic) TCCommonButton *nextButton;

@property (nonatomic) CGFloat duration; // 以小时为单位
@property (strong, nonatomic) NSCalendar *currentCalendar;
@property (strong, nonatomic) TCBookingDate *bookingDate;
@property (strong, nonatomic) TCBookingTime *startBookingTime;
@property (strong, nonatomic) TCBookingTime *endBookingTime;
@property (strong, nonatomic) TCMeetingRoomRemind *currentRemind;

/** 原始的起始时间，修改时间时使用 */
@property (strong, nonatomic) TCBookingDate *originalBookingDate;
@property (strong, nonatomic) TCBookingTime *originalStartBookingTime;
@property (strong, nonatomic) TCBookingTime *originalEndBookingTime;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (copy, nonatomic) NSArray *bookingTimeNameArray;
@property (copy, nonatomic) NSArray *bookingTimeStrArray;
@property (copy, nonatomic) NSArray *remindArray;

@property (strong, nonatomic) TCBookingRequestInfo *bookingRequestInfo;

@end

@implementation TCMeetingRoomViewController {
    __weak TCMeetingRoomViewController *weakSelf;
}

- (instancetype)initWithControllerType:(TCMeetingRoomViewControllerType)type {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _controllerType = type;
        weakSelf = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"会议室预定";
    
    [self setupSubviews];
    [self setupConstraints];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCMeetingRoomSubjectViewCell class] forCellReuseIdentifier:@"TCMeetingRoomSubjectViewCell"];
    [tableView registerClass:[TCMeetingRoomTitleViewCell class] forCellReuseIdentifier:@"TCMeetingRoomTitleViewCell"];
    [tableView registerClass:[TCMeetingRoomSelectViewCell class] forCellReuseIdentifier:@"TCMeetingRoomSelectViewCell"];
    [tableView registerClass:[TCMeetingRoomSupportedViewCell class] forCellReuseIdentifier:@"TCMeetingRoomSupportedViewCell"];
    [tableView registerClass:[TCMeetingRoomInfoViewCell class] forCellReuseIdentifier:@"TCMeetingRoomInfoViewCell"];
    [self.view addSubview:tableView];
    
    UIImageView *headerView = [[UIImageView alloc] init];
    headerView.frame = CGRectMake(0, 0, TCScreenWidth, TCRealValue(215));
    tableView.tableHeaderView = headerView;
    NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:self.meetingRoom.pictures];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(TCScreenWidth, TCRealValue(215))];
    [headerView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    
    UILabel *footerView = [[UILabel alloc] init];
    footerView.text = @"您可在会议开始30分钟前取消订单";
    footerView.textColor = TCGrayColor;
    footerView.textAlignment = NSTextAlignmentCenter;
    footerView.font = [UIFont systemFontOfSize:14];
    footerView.frame = CGRectMake(0, 0, TCScreenWidth, 80);
    tableView.tableFooterView = footerView;
    
    NSString *title = (self.controllerType == TCMeetingRoomViewControllerTypeBooking) ? @"下一步" : @"修改";
    TCCommonButton *nextButton = [TCCommonButton buttonWithTitle:title
                                                           color:TCCommonButtonColorPurple
                                                          target:self
                                                          action:@selector(handleClickNextButton)];
    [self.view addSubview:nextButton];
    
    self.tableView = tableView;
    self.headerView = headerView;
    self.nextButton = nextButton;
}

- (void)setupConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.nextButton.mas_top);
    }];
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)setMeetingRoomReservationDetail:(TCMeetingRoomReservationDetail *)meetingRoomReservationDetail {
    _meetingRoomReservationDetail = meetingRoomReservationDetail;
    
    TCMeetingRoom *meetingRoom = [[TCMeetingRoom alloc] init];
    meetingRoom.ID = meetingRoomReservationDetail.conferenceId;
    meetingRoom.openTime = meetingRoomReservationDetail.openTime;
    meetingRoom.closeTime = meetingRoomReservationDetail.closeTime;
    meetingRoom.equipments = meetingRoomReservationDetail.equipmentList;
    meetingRoom.pictures = meetingRoomReservationDetail.picture;
    meetingRoom.floor = meetingRoomReservationDetail.floor;
    meetingRoom.fee = meetingRoomReservationDetail.fee;
    meetingRoom.galleryful = meetingRoomReservationDetail.galleryful;
    meetingRoom.maxGalleryful = meetingRoomReservationDetail.maxGalleryful;
    self.meetingRoom = meetingRoom;
    
    self.bookingRequestInfo.subject = meetingRoomReservationDetail.subject;
    self.bookingRequestInfo.reminderTime = meetingRoomReservationDetail.reminderTime;
    self.bookingRequestInfo.conferenceBeginTime = meetingRoomReservationDetail.conferenceBeginTime;
    self.bookingRequestInfo.conferenceEndTime = meetingRoomReservationDetail.conferenceEndTime;
    self.bookingRequestInfo.conferenceParticipants = meetingRoomReservationDetail.conferenceParticipants;
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:meetingRoomReservationDetail.conferenceBeginTime / 1000.0];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:meetingRoomReservationDetail.conferenceEndTime / 1000.0];
    TCBookingDate *bookingDate = [[TCBookingDate alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    bookingDate.dateStr = [self.dateFormatter stringFromDate:startDate];
    bookingDate.date = [self.dateFormatter dateFromString:bookingDate.dateStr];
    bookingDate.isSelected = YES;
    self.bookingDate = bookingDate;
    self.originalBookingDate = bookingDate;
    
    self.dateFormatter.dateFormat = @"HH:mm";
    TCBookingTime *startBookingTime = [[TCBookingTime alloc] init];
    TCBookingTime *endBookingTime = [[TCBookingTime alloc] init];
    NSString *startTimeStr = [self.dateFormatter stringFromDate:startDate];
    NSString *endTimeStr = [self.dateFormatter stringFromDate:endDate];
    for (int i=0; i<bookingTimeCount; i++) {
        NSArray *tempArray = self.bookingTimeStrArray[i];
        NSString *first = [tempArray firstObject];
        NSString *last = [tempArray lastObject];
        if ([first isEqualToString:startTimeStr]) {
            startBookingTime.num = i;
            startBookingTime.name = self.bookingTimeNameArray[i];
            startBookingTime.startTimeStr = first;
            startBookingTime.endTimeStr = last;
        }
        if ([last isEqualToString:endTimeStr]) {
            endBookingTime.num = i;
            endBookingTime.name = self.bookingTimeNameArray[i];
            endBookingTime.startTimeStr = first;
            endBookingTime.endTimeStr = last;
        }
    }
    self.startBookingTime = startBookingTime;
    self.endBookingTime = endBookingTime;
    self.originalStartBookingTime = startBookingTime;
    self.originalEndBookingTime = endBookingTime;
    self.duration = (endBookingTime.num - startBookingTime.num + 1) * 0.5;
    
    for (TCMeetingRoomRemind *remind in self.remindArray) {
        if (remind.remindTime == meetingRoomReservationDetail.reminderTime) {
            self.currentRemind = remind;
            break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell = nil;
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0) {
        switch (row) {
            case 0:
            {
                TCMeetingRoomTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomTitleViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = self.meetingRoom.name;
                currentCell = cell;
            }
                break;
            case 1:
            {
                TCMeetingRoomSubjectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomSubjectViewCell" forIndexPath:indexPath];
                cell.textField.text = self.bookingRequestInfo.subject;
                cell.textField.delegate = self;
                currentCell = cell;
            }
                break;
            case 2:
            {
                TCMeetingRoomSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomSelectViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"预定日期和时间";
                if (self.bookingDate) {
                    cell.subTitleLabel.text = [NSString stringWithFormat:@"%@ %@-%@", self.bookingDate.dateStr, self.startBookingTime.startTimeStr, self.endBookingTime.endTimeStr];
                } else {
                    cell.subTitleLabel.text = @"请选择";
                }
                currentCell = cell;
            }
                break;
            case 3:
            {
                TCMeetingRoomSupportedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomSupportedViewCell" forIndexPath:indexPath];
                cell.meetingRoom = self.meetingRoom;
                currentCell = cell;
            }
                break;
            case 4:
            {
                TCMeetingRoomInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomInfoViewCell" forIndexPath:indexPath];
                cell.titleLabel.text = @"预订人";
                TCUserInfo *userInfo = [[TCBuluoApi api] currentUserSession].userInfo;
                cell.subTitleLabel.text = [NSString stringWithFormat:@"%@ %@", userInfo.name, userInfo.phone];
                currentCell = cell;
            }
                break;
                
            default:
                break;
        }
    } else if (section == 1) {
        TCMeetingRoomSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomSelectViewCell" forIndexPath:indexPath];
        if (row == 0) {
            cell.titleLabel.text = @"参会人";
            if (self.bookingRequestInfo.conferenceParticipants.count) {
                cell.subTitleLabel.text = [NSString stringWithFormat:@"%zd人", self.bookingRequestInfo.conferenceParticipants.count];
            } else {
                cell.subTitleLabel.text = @"添加参会人";
            }
        } else {
            cell.titleLabel.text = @"提醒";
            cell.subTitleLabel.text = self.currentRemind ? self.currentRemind.remindStr : @"添加提醒";
        }
        currentCell = cell;
    } else {
        TCMeetingRoomInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomInfoViewCell" forIndexPath:indexPath];
        if (section == 2) {
            cell.titleLabel.text = @"企业支付";
            TCUserInfo *userInfo = [[TCBuluoApi api] currentUserSession].userInfo;
            cell.subTitleLabel.text = userInfo.companyName;
        } else {
            cell.titleLabel.text = @"费用估计";
            cell.subTitleLabel.text = [NSString stringWithFormat:@"¥ %0.2f", self.meetingRoom.fee * self.duration];
        }
        currentCell = cell;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 3) {
        return [tableView fd_heightForCellWithIdentifier:@"TCMeetingRoomSupportedViewCell" configuration:^(TCMeetingRoomSupportedViewCell *cell) {
            cell.meetingRoom = weakSelf.meetingRoom;
        }];
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 7.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView endEditing:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            TCMeetingRoomBookingTimeViewController *vc = [[TCMeetingRoomBookingTimeViewController alloc] init];
            vc.meetingRoomID = self.meetingRoom.ID;
            vc.startDate = self.startDate;
            vc.endDate = self.endDate;
            vc.selectedDate = self.bookingDate.date;
            vc.bookingDate = self.bookingDate;
            vc.startBookingTime = self.startBookingTime;
            vc.endBookingTime = self.endBookingTime;
            if (self.controllerType == TCMeetingRoomViewControllerTypeModification) {
                vc.originalStartBookingTime = self.originalStartBookingTime;
                vc.originalEndBookingTime = self.originalEndBookingTime;
                vc.originalBookingDate = self.originalBookingDate;
            }
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            TCMeetingRoomContactsViewController *vc = [[TCMeetingRoomContactsViewController alloc] initWithControllerType:TCMeetingRoomContactsViewControllerTypeAdd];
            vc.participants = [NSMutableArray arrayWithArray:self.bookingRequestInfo.conferenceParticipants];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            TCMeetingRoomRemindViewController *vc = [[TCMeetingRoomRemindViewController alloc] init];
            vc.currentRemind = self.currentRemind;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.bookingRequestInfo.subject = textField.text;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}

#pragma mark - TCMeetingRoomBookingTimeViewControllerDelegate

- (void)didClickConfirmButtonInBookingTimeViewController:(TCMeetingRoomBookingTimeViewController *)vc {
    self.bookingDate = vc.bookingDate;
    self.startBookingTime = vc.startBookingTime;
    self.endBookingTime = vc.endBookingTime;
    self.duration = (self.endBookingTime.num - self.startBookingTime.num + 1) * 0.5;
    
    [self.tableView reloadData];
}

#pragma mark - TCMeetingRoomRemindViewControllerDelegate

- (void)didClickConfirmButtonInMeetingRoomRemindViewController:(TCMeetingRoomRemindViewController *)vc {
    self.currentRemind = vc.currentRemind;
    
    [self.tableView reloadData];
}

#pragma mark - TCMeetingRoomContactsViewControllerDelegate

- (void)didClickBackButtonInMeetingRoomContactsViewController:(TCMeetingRoomContactsViewController *)vc {
    self.bookingRequestInfo.conferenceParticipants = [vc.participants copy];
    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)handleClickNextButton {
    if (self.bookingRequestInfo.subject.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请填写会议主题"];
        return;
    }
    if (!self.bookingDate) {
        [MBProgressHUD showHUDWithMessage:@"请选择会议日期和时间"];
        return;
    }
    
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *startStr = [NSString stringWithFormat:@"%@ %@", self.bookingDate.dateStr, self.startBookingTime.startTimeStr];
    NSString *endStr = [NSString stringWithFormat:@"%@ %@", self.bookingDate.dateStr, self.endBookingTime.endTimeStr];
    NSDate *startDate = [self.dateFormatter dateFromString:startStr];
    NSDate *endDate = [self.dateFormatter dateFromString:endStr];
    
    self.bookingRequestInfo.conferenceBeginTime = [startDate timeIntervalSince1970] * 1000;
    self.bookingRequestInfo.conferenceEndTime = [endDate timeIntervalSince1970] * 1000;
    
    self.bookingRequestInfo.reminderTime = self.currentRemind.remindTime;
    self.bookingRequestInfo.attendance = (int)self.bookingRequestInfo.conferenceParticipants.count + 1;
    
    [MBProgressHUD showHUD:YES];
    if (self.controllerType == TCMeetingRoomViewControllerTypeBooking) {
        [[TCBuluoApi api] commitBookingRequestInfo:self.bookingRequestInfo meetingRoomID:self.meetingRoom.ID result:^(BOOL success, NSError *error) {
            if (success) {
                [MBProgressHUD showHUDWithMessage:@"预定成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    TCMeetingRoomBookingRecordController *vc = [[TCMeetingRoomBookingRecordController alloc] initWithMeetingRoomBookingRecordType:TCMeetingRoomContactsViewControllerTypeIndividual companyId:nil];
                    vc.isFromMeetingRoomVC = YES;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                });
            } else {
                NSString *message = error.localizedDescription ?: @"预定失败，请稍后再试";
                [MBProgressHUD showHUDWithMessage:message];
            }
        }];
    } else {
        [[TCBuluoApi api] modifyMeetingRoomBookingInfo:self.bookingRequestInfo bookingOrderID:self.meetingRoomReservationDetail.ID result:^(BOOL success, NSError *error) {
            if (success) {
                [MBProgressHUD showHUDWithMessage:@"修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf.modifyBlock) {
                        weakSelf.modifyBlock();
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            } else {
                NSString *message = error.localizedDescription ?: @"修改失败，请稍后再试";
                [MBProgressHUD showHUDWithMessage:message];
            }
        }];
    }
}

#pragma mark - Override Methods

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _dateFormatter;
}

- (TCBookingRequestInfo *)bookingRequestInfo {
    if (_bookingRequestInfo == nil) {
        _bookingRequestInfo = [[TCBookingRequestInfo alloc] init];
    }
    return _bookingRequestInfo;
}

- (NSArray *)bookingTimeNameArray {
    if (_bookingTimeNameArray == nil) {
        _bookingTimeNameArray = @[@"t08A", @"t08B", @"t09A", @"t09B", @"t10A", @"t10B", @"t11A", @"t11B", @"t12A", @"t12B", @"t13A", @"t13B", @"t14A", @"t14B", @"t15A", @"t15B", @"t16A", @"t16B", @"t17A", @"t17B", @"t18A", @"t18B", @"t19A", @"t19B", @"t20A", @"t20B", @"t21A", @"t21B", @"t22A", @"t22B"];
    }
    return _bookingTimeNameArray;
}

- (NSArray *)bookingTimeStrArray {
    if (_bookingTimeStrArray == nil) {
        _bookingTimeStrArray = @[
                                 @[@"08:00", @"08:30"],
                                 @[@"08:30", @"09:00"],
                                 @[@"09:00", @"09:30"],
                                 @[@"09:30", @"10:00"],
                                 @[@"10:00", @"10:30"],
                                 @[@"10:30", @"11:00"],
                                 @[@"11:00", @"11:30"],
                                 @[@"11:30", @"12:00"],
                                 @[@"12:00", @"12:30"],
                                 @[@"12:30", @"13:00"],
                                 @[@"13:00", @"13:30"],
                                 @[@"13:30", @"14:00"],
                                 @[@"14:00", @"14:30"],
                                 @[@"14:30", @"15:00"],
                                 @[@"15:00", @"15:30"],
                                 @[@"15:30", @"16:00"],
                                 @[@"16:00", @"16:30"],
                                 @[@"16:30", @"17:00"],
                                 @[@"17:00", @"17:30"],
                                 @[@"17:30", @"18:00"],
                                 @[@"18:00", @"18:30"],
                                 @[@"18:30", @"19:00"],
                                 @[@"19:00", @"19:30"],
                                 @[@"19:30", @"20:00"],
                                 @[@"20:00", @"20:30"],
                                 @[@"20:30", @"21:00"],
                                 @[@"21:00", @"21:30"],
                                 @[@"21:30", @"22:00"],
                                 @[@"22:00", @"22:30"],
                                 @[@"22:30", @"23:00"]
                                 ];
    }
    return _bookingTimeStrArray;
}

- (NSArray *)remindArray {
    if (_remindArray == nil) {
        TCMeetingRoomRemind *remind01 = [TCMeetingRoomRemind remindWithRemindTime:0 remindStr:@"无需提醒"];
        TCMeetingRoomRemind *remind02 = [TCMeetingRoomRemind remindWithRemindTime:300 remindStr:@"提前5分钟"];
        TCMeetingRoomRemind *remind03 = [TCMeetingRoomRemind remindWithRemindTime:900 remindStr:@"提前15分钟"];
        TCMeetingRoomRemind *remind04 = [TCMeetingRoomRemind remindWithRemindTime:1800 remindStr:@"提前30分钟"];
        TCMeetingRoomRemind *remind05 = [TCMeetingRoomRemind remindWithRemindTime:3600 remindStr:@"提前1小时"];
        _remindArray = @[remind01, remind02, remind03, remind04, remind05];
    }
    return _remindArray;
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
