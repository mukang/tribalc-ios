//
//  TCReserveOnlineViewController.m
//  individual
//
//  Created by WYH on 16/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCReserveOnlineViewController.h"
#import "TCComponent.h"
#import "TCGetNavigationItem.h"
#import "TCReserveUserBaseInfoView.h"

@interface TCReserveOnlineViewController () {
    UILabel *timeLab;
    UILabel *personNumberLab;
    
    TCReserveUserBaseInfoView *userInfoView;
    
    UIView *timeSelectView;
    UIView *personNumberSelectView;
    
    UIPickerView *timePickerView;
    UIPickerView *personNumberPickerView;
    
}

@end

@implementation TCReserveOnlineViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self initNavigationBar];
    
    
    [self initUI];
    
}

- (void)initNavigationBar {
    UIButton *backBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:@"back"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    [backBtn addTarget:self  action:@selector(touchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.titleView = [TCGetNavigationItem getTitleItemWithText:@"在线订座"];
}


- (void)initUI {
    
    
    UIView *timeAndPersonNumberView = [self getTimeAndPersonNumberView];
    [self.view addSubview:timeAndPersonNumberView];
    
    [self initPickerView];
    
    userInfoView = [[TCReserveUserBaseInfoView alloc] initWithFrame:CGRectMake(0, timeAndPersonNumberView.y + timeAndPersonNumberView.height + 11, self.view.width, self.view.height - timeAndPersonNumberView.y - timeAndPersonNumberView.height)];
    [self.view addSubview:userInfoView];
    
    UIButton *reserveBtn = [self getReserveButtonWithFrame:CGRectMake(33, self.view.height - 15 - 43 - 64, self.view.width - 66, 43)];
    [reserveBtn bringSubviewToFront:self.view];
    [self.view addSubview:reserveBtn];
    
}



- (UIButton *)getReserveButtonWithFrame:(CGRect)frame {
    UIButton *reserveBtn = [[UIButton alloc] initWithFrame:frame];
    [reserveBtn setTitle:@"预订餐位" forState:UIControlStateNormal];
    reserveBtn.backgroundColor = TCRGBColor(81, 199, 209);
    [reserveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reserveBtn.layer.cornerRadius = 5;
    [reserveBtn addTarget:self action:@selector(touchReserveBtn:) forControlEvents:UIControlEventTouchUpInside];
    return reserveBtn;
}


- (void)initPickerView {
    timeSelectView = [self getSelectViewWithTitle:@"时间和日期" AndTpye:@"time" ];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:timeSelectView];
    
    personNumberSelectView = [self getSelectViewWithTitle:@"1人" AndTpye:@"person"];
    [window addSubview:personNumberSelectView];
}

- (UIView *)getSelectViewWithTitle:(NSString *)title AndTpye:(NSString *)type{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height + 216 + 40)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UIView *titleView = [self getSelectTitleViewWithFrame:CGRectMake(0, self.view.height, self.view.width, 40) AndTitle:title];
    view.hidden = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchCancelSelectBtn:)];
    [view addGestureRecognizer:recognizer];
    
    titleView.backgroundColor = [UIColor whiteColor];
    [view addSubview:titleView];
    
    if ([type isEqualToString:@"time"]) {
        timePickerView = [self getPickerViewWithFrame:CGRectMake(0, titleView.y + titleView.height, self.view.width, 216)];
        [view addSubview:timePickerView];
    } else {
        personNumberPickerView =[self getPickerViewWithFrame:CGRectMake(0, titleView.y + titleView.height, self.view.width, 216)];
        [view addSubview:personNumberPickerView];
    }
    
    
    return view;
}

- (UIPickerView *)getPickerViewWithFrame:(CGRect)frame {
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:frame];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    
    return pickerView;
    
}

- (UIView *)getSelectTitleViewWithFrame:(CGRect)frame AndTitle:(NSString *)title {
    UIView *titleView = [[UIView alloc] initWithFrame:frame];
    UIButton *cancelBtn = [TCComponent createButtonWithFrame:CGRectMake(20, 0, 30, titleView.height) AndTitle:@"取消" AndFontSize:14 AndBackColor:nil AndTextColor:[UIColor blackColor]];
    [cancelBtn addTarget:self action:@selector(touchCancelSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *confirmBtn = [TCComponent createButtonWithFrame:CGRectMake(titleView.width - 20 - 30, 0, 30, titleView.height) AndTitle:@"确定" AndFontSize:14 AndBackColor:nil AndTextColor:[UIColor blackColor]];
    [confirmBtn addTarget:self action:[self getSelectTitleViewConfirmBtnActionWithTitle:title] forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLab = [TCComponent createLabelWithText:title AndFontSize:14];
    titleLab.frame = CGRectMake(50, 0, titleView.width - 50 * 2, titleView.height);
    titleLab.textAlignment = NSTextAlignmentCenter;
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, titleView.height - 0.5, self.view.width, 0.5)];
    [titleView addSubview:lineView];
    [titleView addSubview:cancelBtn];
    [titleView addSubview:confirmBtn];
    [titleView addSubview:titleLab];
    
    return titleView;
}

- (SEL)getSelectTitleViewConfirmBtnActionWithTitle:(NSString *)title {
    if ([title isEqualToString:@"时间和日期"]) {
        return @selector(touchTimeConfirmSelectBtn:);
    } else {
        return @selector(touchAmountConfirmSelectBtn:);
    }
}

- (UIView *)getTimeAndPersonNumberView {
    UIView *timeAndPersonNumberView = [[UIView alloc] init];
    timeAndPersonNumberView.backgroundColor = [UIColor whiteColor];
    UIView *timeButton = [self getTimeButtonWithFrame:CGRectMake(1, 0, self.view.width, 40)];
    [timeAndPersonNumberView addSubview:timeButton];
    
    UIView *personNumberBtn = [self getPersonNumberButtonWithFrame:CGRectMake(1, timeButton.y + timeButton.height, timeButton.width, timeButton.height)];
    [timeAndPersonNumberView addSubview:personNumberBtn];
    
    timeAndPersonNumberView.frame = CGRectMake(-1, 2, self.view.width + 2, 40 * 2 + 1);
    timeAndPersonNumberView.layer.borderWidth = 1;
    timeAndPersonNumberView.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
    
    return timeAndPersonNumberView;
}


- (UIButton *)getTimeButtonWithFrame:(CGRect)frame {
    UIButton *timeButton = [self getTimeAndPersonNumberButtonWithFrame:frame AndText:@"时间" AndAction:@selector(touchTimeBtn:)];
    
    timeLab = [TCComponent createLabelWithText:[self getTimeString] AndFontSize:14];
    timeLab.frame = CGRectMake(20 + 35, 0, timeButton.width - 88, timeButton.height);
    timeLab.textAlignment = NSTextAlignmentRight;
    [timeButton addSubview:timeLab];
    
    UIView *downLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, timeButton.height - 0.5, self.view.width - 40, 0.5)];
    [timeButton addSubview:downLineView];
    
    return timeButton;
}

- (UIButton *)getPersonNumberButtonWithFrame:(CGRect)frame {
    UIButton *personNumberButton = [self getTimeAndPersonNumberButtonWithFrame:frame AndText:@"人数" AndAction:@selector(touchPersonNumberBtn:)];
    
    personNumberLab = [TCComponent createLabelWithText:[self getPersonNumberString:1] AndFontSize:14];
    personNumberLab.frame = CGRectMake(20 + 35, 0, personNumberButton.width - 88, personNumberButton.height);
    personNumberLab.textAlignment = NSTextAlignmentRight;
    [personNumberButton addSubview:personNumberLab];
    
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, personNumberButton.width - 40, 0.5)];
    [personNumberButton addSubview:topLineView];
    
    return personNumberButton;
}

- (UIButton *)getTimeAndPersonNumberButtonWithFrame:(CGRect)frame AndText:(NSString *)text AndAction:(SEL)action {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    UILabel *tagLab = [TCComponent createLabelWithFrame:CGRectMake(20, 0, 30, button.height) AndFontSize:14 AndTitle:text];
    [button addSubview:tagLab];
    UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(button.width - 20 - 9, button.height / 2 - 18 / 2, 9, 18)];
    rightImgView.image = [UIImage imageNamed:@"goods_select_standard"];
    [button addSubview:rightImgView];
    
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (NSString *)getPersonNumberString:(NSInteger)number {
    NSString *personNumberStr = [NSString stringWithFormat:@"%li人", (long)number];
    
    return personNumberStr;
}

- (NSString *)getTimeString {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    return [dateFormatter stringFromDate:date];
}

- (NSString *)getTimeStringWithSelectDateStr:(NSString *)dateStr AndTimeStr:(NSString *)timeStr{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSString *monthStr = [dateFormatter stringFromDate:date];
    
    NSString *selectMonth = [dateStr componentsSeparatedByString:@"-"][0];
    [dateFormatter setDateFormat:@"YYYY"];
    NSString *yearStr;
    if (selectMonth.integerValue >= monthStr.integerValue) {
        yearStr = [dateFormatter stringFromDate:date];
    } else {
        yearStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * 30 * 12]];
    }
    
    return [NSString stringWithFormat:@"%@-%@ %@", yearStr, [dateStr componentsSeparatedByString:@" "][0], timeStr];
}

- (NSString *)getTimeString:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    components = [calendar components:unitFlags fromDate:date];
    NSInteger minute = [components minute];
    if (minute > 30) {
        date = [NSDate dateWithTimeInterval: 60 * (60 - minute) sinceDate:date];
    } else if (minute < 30) {
        date = [NSDate dateWithTimeInterval:(30 - minute) * 60 sinceDate:date];
    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    return [dateFormatter stringFromDate:date];

}

- (NSString *)getTimeAndWeek:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    components = [calendar components:unitFlags fromDate:date];
    NSInteger week = [components weekday];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    
    return [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:date], [self getWeekStr:week]];
    
    
}

- (void)showSelectTimePickerView {
    [UIView animateWithDuration:0.15 animations:^{
        timeSelectView.hidden = NO;
        timeSelectView.y = timeSelectView.y - 256 ;
    } completion:nil];
}

- (void)showSelectPersonNumberView {
    [UIView animateWithDuration:0.15 animations:^{
        personNumberSelectView.hidden = NO;
        personNumberSelectView.y = personNumberSelectView.y - 256;
    } completion:nil];
}

- (void)cancelShowSelectView {
    timeSelectView.hidden = YES;
    personNumberSelectView.hidden = YES;
    timeSelectView.y = 0;
    personNumberSelectView.y = 0;
    
}



#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([pickerView isEqual:timePickerView]) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:timePickerView]) {
        if (component == 0) {
            return 30;
        } else {
            return 48;
        }
    } else {
        return 99;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([pickerView isEqual:timePickerView]) {
        if (component == 0) {
            return [self getTimeAndWeek:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * row]];
        } else {
            return [self getTimeString:[NSDate dateWithTimeIntervalSinceNow:30 * 60 * row]];
        }
    } else {
        return [NSString stringWithFormat:@"%li", row + 1];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:personNumberPickerView]) {
        for (int i = 0; i < personNumberSelectView.subviews.count; i++) {
            if ([personNumberSelectView.subviews[i] isKindOfClass:[UIView class]]) {
                UIView *titleView = personNumberSelectView.subviews[i];
                for (int j = 0; j < titleView.subviews.count; j++) {
                    if ([titleView.subviews[j] isKindOfClass:[UILabel class]]) {
                        UILabel *titleLab = titleView.subviews[j];
                        titleLab.text = [NSString stringWithFormat:@"%li人", row + 1];
                    }
                }
            }
        }
    }
}

- (NSString *)getWeekStr:(NSInteger)week {
    switch (week) {
        case 1:
            return @"星期天";
        case 2:
            return @"星期一";
        case 3:
            return @"星期二";
        case 4:
            return @"星期三";
        case 5:
            return @"星期四";
        case 6:
            return @"星期五";
        case 7:
            return @"星期六";
        default:
            return @"";
    }
    
    
}

#pragma mark - Click

- (void)touchTimeBtn:(UIButton *)button {
    [self showSelectTimePickerView];
}

- (void)touchPersonNumberBtn:(UIButton *)button {
    [self showSelectPersonNumberView];
}

- (void)touchCancelSelectBtn:(id)sender {
    [self cancelShowSelectView];
}

- (void)touchTimeConfirmSelectBtn:(UIButton *)button {
    NSInteger dateRow = [timePickerView selectedRowInComponent:0];
    NSInteger timeRow = [timePickerView selectedRowInComponent:1];
    NSString *dateString = [self getTimeAndWeek:[NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60 * dateRow]];
    NSString *timeString = [self getTimeString:[NSDate dateWithTimeIntervalSinceNow:30 * 60 * timeRow]];
    timeLab.text = [self getTimeStringWithSelectDateStr:dateString AndTimeStr:timeString];
    [self cancelShowSelectView];
}

- (void)touchAmountConfirmSelectBtn:(UIButton *)button {
    NSInteger personNumberRow = [personNumberPickerView selectedRowInComponent:0];
    NSString *personNumberStr = [NSString stringWithFormat:@"%li", personNumberRow + 1];
    personNumberLab.text = [NSString stringWithFormat:@"%@人", personNumberStr];
    
    [self cancelShowSelectView];

}


- (void)touchReserveBtn:(UIButton *)btn {
    NSLog(@"点击预订按钮");
}

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