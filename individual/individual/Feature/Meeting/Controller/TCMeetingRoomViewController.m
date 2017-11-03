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

@interface TCMeetingRoomViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TCMeetingRoomBookingTimeViewControllerDelegate, TCMeetingRoomRemindViewControllerDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIImageView *headerView;
@property (weak, nonatomic) TCCommonButton *nextButton;

@property (strong, nonatomic) TCBookingDate *bookingDate;
@property (strong, nonatomic) TCBookingTime *startBookingTime;
@property (strong, nonatomic) TCBookingTime *endBookingTime;
@property (strong, nonatomic) TCMeetingRoomRemind *currentRemind;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) TCBookingRequestInfo *bookingRequestInfo;

@end

@implementation TCMeetingRoomViewController {
    __weak TCMeetingRoomViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weakSelf = self;
    self.navigationItem.title = @"会议室预定";
    self.bookingRequestInfo = [[TCBookingRequestInfo alloc] init];
    
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
    
    TCCommonButton *nextButton = [TCCommonButton buttonWithTitle:@"下一步"
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
            cell.subTitleLabel.text = @"添加参会人";
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
            cell.subTitleLabel.text = [NSString stringWithFormat:@"¥ %0.2f", self.meetingRoom.fee];
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
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
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
    
    [self.tableView reloadData];
}

#pragma mark - TCMeetingRoomRemindViewControllerDelegate

- (void)didClickConfirmButtonInMeetingRoomRemindViewController:(TCMeetingRoomRemindViewController *)vc {
    self.currentRemind = vc.currentRemind;
    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)handleClickNextButton {
    if (!self.bookingDate) {
        [MBProgressHUD showHUDWithMessage:@"请选择会议日期和时间"];
        return;
    }
    
    NSString *startStr = [NSString stringWithFormat:@"%@ %@", self.bookingDate.dateStr, self.startBookingTime.startTimeStr];
    NSString *endStr = [NSString stringWithFormat:@"%@ %@", self.bookingDate.dateStr, self.endBookingTime.endTimeStr];
    NSDate *startDate = [self.dateFormatter dateFromString:startStr];
    NSDate *endDate = [self.dateFormatter dateFromString:endStr];
    
    self.bookingRequestInfo.conferenceBeginTime = [startDate timeIntervalSince1970] * 1000;
    self.bookingRequestInfo.conferenceEndTime = [endDate timeIntervalSince1970] * 1000;
    
    self.bookingRequestInfo.reminderTime = self.currentRemind.remindTime;
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] commitBookingRequestInfo:self.bookingRequestInfo meetingRoomID:self.meetingRoom.ID result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD showHUDWithMessage:@"提交成功"];
        } else {
            [MBProgressHUD showHUDWithMessage:@"提交失败"];
        }
    }];
}

#pragma mark - Override Methods

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
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
