//
//  TCMeetingRoomBookingTimeViewController.m
//  individual
//
//  Created by 穆康 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomBookingTimeViewController.h"

#import "TCBookingDateView.h"
#import "TCBookingTimeView.h"
#import "TCBookingTimeNoteView.h"

#import "TCBuluoApi.h"
#import "TCBookingTime.h"

#import <TCCommonLibs/TCCommonButton.h>

#define bookingTimeCount 30

@interface TCMeetingRoomBookingTimeViewController () <TCBookingDateViewDelegate>

@property (weak, nonatomic) TCBookingDateView *dateView;
@property (weak, nonatomic) TCBookingTimeView *timeView;
@property (weak, nonatomic) TCBookingTimeNoteView *noteView;
@property (weak, nonatomic) TCCommonButton *confirmButton;

@property (strong, nonatomic) NSDate *currentDate;
@property (strong, nonatomic) NSDate *selectedDate;

@property (copy, nonatomic) NSArray *bookingTimeNameArray;
@property (copy, nonatomic) NSArray *bookingTimeStrArray;

@property (strong, nonatomic) NSMutableArray *currentBookingTimeArray;

@end

@implementation TCMeetingRoomBookingTimeViewController {
    __weak TCMeetingRoomBookingTimeViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weakSelf = self;
    self.navigationItem.title = @"预定时间";
    
    [self setupSubviews];
    [self setupConstraints];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];;
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *startDate = [dateFormatter dateFromString:@"2017-10-26"];
    NSDate *endDate = [dateFormatter dateFromString:@"2017-11-02"];
    NSDate *selectedDate = [dateFormatter dateFromString:@"2017-11-01"];
    self.currentDate = selectedDate;
    TCBookingDateView *dateView = [[TCBookingDateView alloc] initWithStartDate:startDate endDate:endDate selectedDate:selectedDate];
    dateView.delegate = self;
    [self.view addSubview:dateView];
    
    TCBookingTimeNoteView *noteView = [[TCBookingTimeNoteView alloc] init];
    [self.view addSubview:noteView];
    
    TCBookingTimeView *timeView = [[TCBookingTimeView alloc] init];
    [self.view addSubview:timeView];
    
    TCCommonButton *confirmButton = [TCCommonButton bottomButtonWithTitle:@"确  定"
                                                                    color:TCCommonButtonColorPurple
                                                                   target:self
                                                                   action:@selector(handleClickConfirmButton)];
    [self.view addSubview:confirmButton];
    
    self.dateView = dateView;
    self.timeView = timeView;
    self.noteView = noteView;
    self.confirmButton = confirmButton;
}

- (void)setupConstraints {
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(45);
    }];
    [self.noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(38);
    }];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noteView.mas_bottom);
        make.bottom.equalTo(self.confirmButton.mas_top);
        make.left.right.equalTo(self.view);
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
}

- (void)loadBookingDateInfoWithNewDate:(NSDate *)newDate {
    [MBProgressHUD showHUD:YES];
    long long searchDate = [newDate timeIntervalSince1970] * 1000;
    [[TCBuluoApi api] fetchBookingDateInfoWithMeetingRoomID:self.meetingRoomID searchDate:searchDate result:^(TCBookingDateInfo *bookingDateInfo, NSError *error) {
        if (bookingDateInfo) {
            [MBProgressHUD hideHUD:YES];
            [weakSelf createBookingTimeArrayWithBookingDateInfo:bookingDateInfo];
        } else {
            NSString *message = error.localizedDescription ?: @"获取数据失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
        }
    }];
}

- (void)createBookingTimeArrayWithBookingDateInfo:(TCBookingDateInfo *)bookingDateInfo {
    self.currentBookingTimeArray = [NSMutableArray arrayWithCapacity:bookingTimeCount];
    for (int i=0; i<bookingTimeCount; i++) {
        TCBookingTime *bookingTime = [[TCBookingTime alloc] init];
        NSString *name = self.bookingTimeNameArray[i];
        bookingTime.num = i;
        bookingTime.name = name;
        bookingTime.timeStr = self.bookingTimeStrArray[i];
        if ([bookingDateInfo valueForKey:name]) {
            bookingTime.status = TCBookingTimeStatusDisabled;
        } else {
            bookingTime.status = TCBookingTimeStatusNormal;
        }
        [self.currentBookingTimeArray addObject:bookingTime];
    }
}

#pragma mark - TCBookingDateViewDelegate

- (void)bookingDateView:(TCBookingDateView *)view didScrollToNewDate:(NSDate *)newDate {
    self.currentDate = newDate;
    
}

#pragma mark - Actions

- (void)handleClickConfirmButton {
    [self.dateView setNewSelectedDate:self.currentDate];
}

#pragma mark - Override Methods

- (NSArray *)bookingTimeNameArray {
    if (_bookingTimeNameArray == nil) {
        _bookingTimeNameArray = @[@"t08A", @"t08B", @"t09A", @"t09B", @"t10A", @"t10B", @"t11A", @"t11B", @"t12A", @"t12B", @"t13A", @"t13B", @"t14A", @"t14B", @"t15A", @"t15B", @"t16A", @"t16B", @"t17A", @"t17B", @"t18A", @"t18B", @"t19A", @"t19B", @"t20A", @"t20B", @"t21A", @"t21B", @"t22A", @"t22B"];
    }
    return _bookingTimeNameArray;
}

- (NSArray *)bookingTimeStrArray {
    if (_bookingTimeStrArray == nil) {
        _bookingTimeStrArray = @[@"08:00", @"08:30", @"09:00", @"09:30", @"10:00", @"10:30", @"11:00", @"11:30", @"12:00", @"12:30", @"13:00", @"13:30", @"14:00", @"14:30", @"15:00", @"15:30", @"16:00", @"16:30", @"17:00", @"17:30", @"18:00", @"18:30", @"19:00", @"19:30", @"20:00", @"20:30", @"21:00", @"21:30", @"22:00", @"22:30"];
    }
    return _bookingTimeStrArray;
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
