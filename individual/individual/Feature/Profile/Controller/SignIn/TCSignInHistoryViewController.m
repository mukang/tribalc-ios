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

#define navBarH     64.0

@interface TCSignInHistoryViewController ()<FSCalendarDelegate,FSCalendarDataSource>

@property (weak, nonatomic) UINavigationBar *navBar;

@property (weak, nonatomic) UINavigationItem *navItem;

@property (strong, nonatomic) UIImageView *bgImageView;

@property (strong, nonatomic) UIImageView *topBgImageView;

@property (strong, nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) TCSigninRecordMonth *signinRecordMonth;

@end

@implementation TCSignInHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubviews];
    [self setupNavBar];
    [self loadData];
}

- (void)loadData {
    @WeakObj(self)
    [[TCBuluoApi api] fetchSigninRecordMonth:^(TCSigninRecordMonth *signinRecordMonth, NSError *error) {
        @StrongObj(self)
        if (signinRecordMonth) {
            self.signinRecordMonth = signinRecordMonth;
            [self.calendar reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];
}

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, navBarH)];
    [navBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [navBar setBackgroundImage:[UIImage imageNamed:@"TransparentPixel"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"我的签到"];
    navBar.titleTextAttributes = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:16],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]
                                   };
    UIImage *backImage = [[UIImage imageNamed:@"nav_back_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickBackButton:)];
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
}

- (void)setUpSubviews {
 
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.topBgImageView];
    [self.view addSubview:self.calendar];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.topBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.height.equalTo(@300);
        make.top.equalTo(self.view).offset(250);
    }];
    
}

#pragma mark FSCalendarDataSource
- (UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date {
    if ([[NSCalendar currentCalendar] isDateInToday:date]) {
        return [UIImage imageNamed:@""];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    
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
        _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        _calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    }
    return _calendar;
}

- (UIImageView *)bgImageView {
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"lock_QR_code_bg"];
    }
    return _bgImageView;
}

- (UIImageView *)topBgImageView {
    if (_topBgImageView == nil) {
        _topBgImageView = [[UIImageView alloc] init];
        _topBgImageView.image = [UIImage imageNamed:@"myLockQRBackgroundImage"];
    }
    return _topBgImageView;
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
