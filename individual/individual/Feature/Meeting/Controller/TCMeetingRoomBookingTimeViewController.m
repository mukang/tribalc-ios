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


#import <TCCommonLibs/TCCommonButton.h>

#define bookingTimeCount 30

@interface TCMeetingRoomBookingTimeViewController () <TCBookingDateViewDelegate, TCBookingTimeViewDelegate>

@property (weak, nonatomic) TCBookingDateView *dateView;
@property (weak, nonatomic) TCBookingTimeView *timeView;
@property (weak, nonatomic) TCBookingTimeNoteView *noteView;
@property (weak, nonatomic) TCCommonButton *confirmButton;

@property (strong, nonatomic) TCBookingDate *currentBookingDate;

@property (copy, nonatomic) NSArray *bookingTimeNameArray;
@property (copy, nonatomic) NSArray *bookingTimeStrArray;

@property (strong, nonatomic) NSMutableArray *bookingTimeArray;

@property (strong, nonatomic) NSCalendar *currentCalendar;
@property (strong, nonatomic) NSDateFormatter *timeFormatter;

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
    TCBookingDateView *dateView = [[TCBookingDateView alloc] initWithStartDate:self.startDate endDate:self.endDate selectedDate:self.selectedDate];
    dateView.delegate = self;
    [self.view addSubview:dateView];
    
    TCBookingTimeNoteView *noteView = [[TCBookingTimeNoteView alloc] init];
    [self.view addSubview:noteView];
    
    TCBookingTimeView *timeView = [[TCBookingTimeView alloc] init];
    timeView.bookingTimedelegate = self;
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

#pragma mark - 获取预定时间信息

- (void)loadBookingDateInfoWithDate:(NSDate *)date {
    [MBProgressHUD showHUD:YES];
    long long searchDate = [date timeIntervalSince1970] * 1000;
    [[TCBuluoApi api] fetchBookingDateInfoWithMeetingRoomID:self.meetingRoomID searchDate:searchDate result:^(TCBookingDateInfo *bookingDateInfo, NSError *error) {
        if (bookingDateInfo) {
            [MBProgressHUD hideHUD:YES];
            [weakSelf createBookingTimeArrayWithBookingDateInfo:bookingDateInfo];
        } else {
            NSString *message = error.localizedDescription ?: @"获取数据失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
            [self createBookingTimeArrayWithNoBookingDateInfo];
        }
    }];
}

- (void)createBookingTimeArrayWithBookingDateInfo:(TCBookingDateInfo *)bookingDateInfo {
    [self.bookingTimeArray removeAllObjects];
    NSDate *currentDate = [NSDate date];
    for (int i=0; i<bookingTimeCount; i++) {
        TCBookingTime *bookingTime = [[TCBookingTime alloc] init];
        NSString *name = self.bookingTimeNameArray[i];
        NSArray *timeStrs = self.bookingTimeStrArray[i];
        bookingTime.num = i;
        bookingTime.name = name;
        bookingTime.startTimeStr = [timeStrs firstObject];
        bookingTime.endTimeStr = [timeStrs lastObject];
        if ([bookingDateInfo valueForKey:name]) {
            bookingTime.status = TCBookingTimeStatusDisabled;
        } else {
            bookingTime.status = TCBookingTimeStatusNormal;
        }
        if ([self.currentCalendar compareDate:self.currentBookingDate.date toDate:currentDate toUnitGranularity:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay] == NSOrderedSame) {
            if ([bookingTime.startTimeStr compare:[self.timeFormatter stringFromDate:currentDate]] != NSOrderedDescending) {
                bookingTime.status = TCBookingTimeStatusDisabled;
            }
        }
        [self.bookingTimeArray addObject:bookingTime];
    }
    
    BOOL hasSelectedByOther = NO;
    if ([self.currentBookingDate.date isEqualToDate:self.bookingDate.date]) {
        for (int i=self.startBookingTime.num; i<=self.endBookingTime.num; i++) {
            TCBookingTime *bookingTime = self.bookingTimeArray[i];
            if (bookingTime.status == TCBookingTimeStatusDisabled) {
                hasSelectedByOther = YES;
                break;
            }
            bookingTime.status = TCBookingTimeStatusSelected;
        }
    }
    
    if (hasSelectedByOther) {
        for (NSInteger i=self.startBookingTime.num; i<=self.endBookingTime.num; i++) {
            TCBookingTime *bookingTime = self.bookingTimeArray[i];
            if (bookingTime.status == TCBookingTimeStatusSelected) {
                bookingTime.status = TCBookingTimeStatusNormal;
            }
        }
        self.bookingDate = nil;
        self.startBookingTime = nil;
        self.endBookingTime = nil;
        
        [MBProgressHUD showHUDWithMessage:@"您选择的会议时间已被他人预定，请重新选择"];
        [self.dateView setNewSelectedDate:nil];
    }
    
    [self.timeView reloadDataWithBookingTimeArray:self.bookingTimeArray];
}

- (void)createBookingTimeArrayWithNoBookingDateInfo {
    [self.bookingTimeArray removeAllObjects];
    for (int i=0; i<bookingTimeCount; i++) {
        TCBookingTime *bookingTime = [[TCBookingTime alloc] init];
        NSArray *timeStrs = self.bookingTimeStrArray[i];
        bookingTime.num = i;
        bookingTime.startTimeStr = [timeStrs firstObject];
        bookingTime.endTimeStr = [timeStrs lastObject];
        bookingTime.status = TCBookingTimeStatusDisabled;
        [self.bookingTimeArray addObject:bookingTime];
    }
    
    [self.timeView reloadDataWithBookingTimeArray:self.bookingTimeArray];
}

#pragma mark - 预定时间操作

- (void)handleBookingTime:(TCBookingTime *)bookingTime {
    if (bookingTime.status == TCBookingTimeStatusDisabled) {
        return;
    }
    
    if (bookingTime.status == TCBookingTimeStatusNormal) {
        if (!self.startBookingTime || ![self.currentBookingDate.date isEqualToDate:self.bookingDate.date]) {
            [self.dateView setNewSelectedDate:self.currentBookingDate.date];
            self.bookingDate = self.currentBookingDate;
            bookingTime.status = TCBookingTimeStatusSelected;
            self.startBookingTime = bookingTime;
            self.endBookingTime = bookingTime;
        } else {
            if (bookingTime.num > self.startBookingTime.num) {
                for (int i=self.startBookingTime.num+1; i<bookingTime.num; i++) {
                    TCBookingTime *tempBookingTime = self.bookingTimeArray[i];
                    if (tempBookingTime.status == TCBookingTimeStatusDisabled) {
                        [MBProgressHUD showHUDWithMessage:@"您选择的时间范围内已有别人预定的时间，请重新选择"];
                        return;
                    }
                }
                for (int i=self.startBookingTime.num+1; i<=bookingTime.num; i++) {
                    TCBookingTime *tempBookingTime = self.bookingTimeArray[i];
                    tempBookingTime.status = TCBookingTimeStatusSelected;
                }
                self.endBookingTime = bookingTime;
            } else {
                for (int i=bookingTime.num+1; i<self.startBookingTime.num; i++) {
                    TCBookingTime *tempBookingTime = self.bookingTimeArray[i];
                    if (tempBookingTime.status == TCBookingTimeStatusDisabled) {
                        [MBProgressHUD showHUDWithMessage:@"您选择的时间范围内已有别人预定的时间，请重新选择"];
                        return;
                    }
                }
                for (int i=bookingTime.num; i<self.startBookingTime.num; i++) {
                    TCBookingTime *tempBookingTime = self.bookingTimeArray[i];
                    tempBookingTime.status = TCBookingTimeStatusSelected;
                }
                self.startBookingTime = bookingTime;
            }
        }
    } else {
        bookingTime.status = TCBookingTimeStatusNormal;
        if (self.startBookingTime.num == self.endBookingTime.num) {
            [self.dateView setNewSelectedDate:nil];
            self.bookingDate = nil;
            self.startBookingTime = nil;
            self.endBookingTime = nil;
        } else if (bookingTime.num == self.startBookingTime.num) {
            self.startBookingTime = self.bookingTimeArray[self.startBookingTime.num + 1];
        } else {
            for (int i=bookingTime.num + 1; i<=self.endBookingTime.num; i++) {
                TCBookingTime *tempBookingTime = self.bookingTimeArray[i];
                tempBookingTime.status = TCBookingTimeStatusNormal;
            }
            self.endBookingTime = self.bookingTimeArray[bookingTime.num - 1];
        }
    }
    
    [self.timeView reloadDataWithBookingTimeArray:self.bookingTimeArray];
}

#pragma mark - TCBookingDateViewDelegate

- (void)bookingDateView:(TCBookingDateView *)view didScrollToNewBookingDate:(TCBookingDate *)newBookingDate {
    self.currentBookingDate = newBookingDate;
    [self loadBookingDateInfoWithDate:newBookingDate.date];
}

#pragma mark - TCBookingTimeViewDelegate

- (void)bookingTimeView:(TCBookingTimeView *)view didTapBookingTimeCellWithBookingTime:(TCBookingTime *)bookingTime {
    [self handleBookingTime:bookingTime];
}

#pragma mark - Actions

- (void)handleClickConfirmButton {
    if ([self.delegate respondsToSelector:@selector(didClickConfirmButtonInBookingTimeViewController:)]) {
        [self.delegate didClickConfirmButtonInBookingTimeViewController:self];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Override Methods

- (NSMutableArray *)bookingTimeArray {
    if (_bookingTimeArray == nil) {
        _bookingTimeArray = [NSMutableArray arrayWithCapacity:bookingTimeCount];
    }
    return _bookingTimeArray;
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

- (NSCalendar *)currentCalendar {
    if (_currentCalendar == nil) {
        _currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _currentCalendar;
}

- (NSDateFormatter *)timeFormatter {
    if (_timeFormatter == nil) {
        _timeFormatter = [[NSDateFormatter alloc] init];
        _timeFormatter.calendar = self.currentCalendar;
        _timeFormatter.dateFormat = @"HH:mm";
    }
    return _timeFormatter;
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
