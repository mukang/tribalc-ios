//
//  TCSignInHistoryViewController.m
//  individual
//
//  Created by 王帅锋 on 17/5/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSignInHistoryViewController.h"
#import <FSCalendar/FSCalendar.h>
#import "TCBuluoApi.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <UIImageView+WebCache.h>

#define navBarH     64.0

@interface TCSignInHistoryViewController ()<FSCalendarDelegate,FSCalendarDataSource>

@property (weak, nonatomic) UINavigationBar *navBar;

@property (weak, nonatomic) UINavigationItem *navItem;

@property (strong, nonatomic) UIImageView *bgImageView;

@property (strong, nonatomic) UIImageView *topBgImageView;

@property (strong, nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) TCSigninRecordMonth *signinRecordMonth;

@property (strong, nonatomic) UIView *continuityDaysView;

@property (strong, nonatomic) UILabel *dayLabel;

@property (strong, nonatomic) UILabel *daysNumLabel;

@property (strong, nonatomic) UILabel *continuityTitleLabel;

@property (strong, nonatomic) UIImageView *iconImageView;

@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation TCSignInHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的签到";
    [self setUpSubviews];
    [self loadData];
}

- (void)loadData {
    @WeakObj(self)
    [[TCBuluoApi api] fetchSigninRecordMonth:^(TCSigninRecordMonth *signinRecordMonth, NSError *error) {
        @StrongObj(self)
        if (signinRecordMonth) {
            self.signinRecordMonth = signinRecordMonth;
            [self.calendar reloadData];
            if (signinRecordMonth.continuityDays) {
                self.daysNumLabel.text = [NSString stringWithFormat:@"%ld", (long)signinRecordMonth.continuityDays];
            }
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];
}

- (void)setUpSubviews {
 
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.calendar];
    [self.view addSubview:self.continuityDaysView];
    [self.view addSubview:self.continuityTitleLabel];
    
    [self.continuityDaysView addSubview:self.daysNumLabel];
    [self.continuityDaysView addSubview:self.dayLabel];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(TCRealValue(28));
        make.width.height.equalTo(@(TCRealValue(68)));
        make.centerX.equalTo(self.view);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(TCRealValue(15));
        make.height.equalTo(@(TCRealValue(20)));
        make.centerX.width.equalTo(self.view);
    }];

    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@300);
        make.top.equalTo(self.view).offset(TCRealValue(150));
    }];
    
    [self.continuityDaysView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(TCRealValue(40)));
        make.centerX.equalTo(self.view);
        make.width.equalTo(@(TCRealValue(47)));
        make.height.equalTo(@(TCRealValue(52)));
    }];
    
    [self.daysNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.centerX.equalTo(self.continuityDaysView);
        make.height.equalTo(@(TCRealValue(32)));
    }];
    
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.continuityDaysView);
        make.top.equalTo(self.daysNumLabel.mas_bottom).offset(TCRealValue(2));
        make.height.width.equalTo(@(TCRealValue(16)));
    }];
    
    [self.continuityTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.continuityDaysView.mas_top).offset(-3);
        make.height.equalTo(@(TCRealValue(15)));
        make.width.centerX.equalTo(self.view);
    }];
    
    for (UIView *view in self.calendar.subviews) {
        view.backgroundColor = [UIColor clearColor];
    }
    
}


#pragma mark FSCalendarDataSource
- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date {
    
    FSCalendarCell *cell = [calendar cellForDate:date atMonthPosition:FSCalendarMonthPositionCurrent];
    
    [cell.contentView bringSubviewToFront:cell.titleLabel];
    cell.imageView.contentMode = UIViewContentModeCenter;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    if (self.signinRecordMonth) {
        if ([self.signinRecordMonth.monthRecords isKindOfClass:[NSArray class]]) {
            for (TCSigninRecordDay *signinRecordDay in self.signinRecordMonth.monthRecords) {
                if ([signinRecordDay isKindOfClass:[TCSigninRecordDay class]]) {
                    
                    NSArray *arr = [str componentsSeparatedByString:@"-"];
                    if (arr.count >= 3) {
                        NSString *day = arr[2];
                        if ([day isKindOfClass:[NSString class]]) {
                            if (signinRecordDay.dayNumber == day.integerValue) {
                                if ([[NSCalendar currentCalendar] isDateInToday:date]) {
                                    cell.titleLabel.textColor = [UIColor whiteColor];
                                    return [UIImage imageNamed:@"signinedToday"];
                                }else {
                                    cell.titleLabel.textColor = TCRGBColor(237, 134, 40);
                                    return [UIImage imageNamed:@"signinedNoToday"];
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    if ([[NSCalendar currentCalendar] isDateInToday:date]) {
        cell.titleLabel.textColor = [UIColor whiteColor];
        return [UIImage imageNamed:@""];
    }
    return nil;
}


#pragma mark FSCalendarDelegate

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    return NO;
}

- (FSCalendar *)calendar {
    if (_calendar == nil) {
        _calendar = [[FSCalendar alloc] init];
        _calendar.delegate = self;
        _calendar.dataSource = self;
        _calendar.scrollEnabled = NO;
        _calendar.appearance.headerDateFormat = @"yyyy年MM月";
        _calendar.appearance.headerTitleColor = TCBlackColor;
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
        _calendar.appearance.weekdayTextColor = TCBlackColor;
        _calendar.appearance.separators = FSCalendarSeparatorBelowWeekdays;
        _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        _calendar.scrollDirection = FSCalendarScrollDirectionVertical;
        _calendar.today = nil;
    }
    return _calendar;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"signinBG"];
    }
    return _bgImageView;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.layer.cornerRadius = (TCRealValue(68))/2;
        _iconImageView.layer.borderWidth = TCRealValue(3);
        _iconImageView.layer.borderColor = TCBackgroundColor.CGColor;
        _iconImageView.clipsToBounds = YES;
        TCUserInfo *userInfo = [[TCBuluoApi api] currentUserSession].userInfo;
        if (userInfo.picture) {
            NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:userInfo.picture];
            [_iconImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
        } else {
            [_iconImageView setImage:[UIImage imageNamed:@"profile_default_avatar_icon"]];
        }
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = TCRGBColor(162, 162, 162);
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        TCUserInfo *userInfo = [[TCBuluoApi api] currentUserSession].userInfo;
        _nameLabel.text = userInfo.nickname;
    }
    return _nameLabel;
}

- (UIView *)continuityDaysView {
    if (_continuityDaysView == nil) {
        _continuityDaysView = [[UIView alloc] init];
        _continuityDaysView.backgroundColor = [UIColor colorWithRed:69/255.0 green:201/255.0 blue:186/255.0 alpha:1.0];
    }
    return _continuityDaysView;
}

- (UILabel *)dayLabel {
    if (_dayLabel == nil) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.font = [UIFont systemFontOfSize:8];
        _dayLabel.textColor = TCBackgroundColor;
        _dayLabel.layer.cornerRadius = TCRealValue(8);
        _dayLabel.clipsToBounds = YES;
        _dayLabel.text = @"天";
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.backgroundColor = [UIColor colorWithRed:77/255.0 green:210/255.0 blue:189/255.0 alpha:1.0];
    }
    return _dayLabel;
}

- (UILabel *)daysNumLabel {
    if (_daysNumLabel == nil) {
        _daysNumLabel = [[UILabel alloc] init];
        _daysNumLabel.textColor = TCBackgroundColor;
        _daysNumLabel.font = [UIFont systemFontOfSize:28];
        _daysNumLabel.textAlignment = NSTextAlignmentCenter;
        _daysNumLabel.text = @"0";
    }
    return _daysNumLabel;
}

- (UILabel *)continuityTitleLabel {
    if (_continuityTitleLabel == nil) {
        _continuityTitleLabel = [[UILabel alloc] init];
        _continuityTitleLabel.font = [UIFont systemFontOfSize:10];
        _continuityTitleLabel.textColor = TCBackgroundColor;
        _continuityTitleLabel.textAlignment = NSTextAlignmentCenter;
        _continuityTitleLabel.text = @"连续签到";
    }
    return _continuityTitleLabel;
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
