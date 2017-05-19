//
//  TCSignInHistoryViewController.m
//  individual
//
//  Created by 王帅锋 on 17/5/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSignInHistoryViewController.h"
#import <FSCalendar/FSCalendar.h>

@interface TCSignInHistoryViewController ()

@property (strong, nonatomic) UIImageView *bgImageView;

@property (strong, nonatomic) UIImageView *topBgImageView;

@property (strong, nonatomic) FSCalendar *calendar;

@end

@implementation TCSignInHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSubviews];
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
        make.top.equalTo(self.view).offset(200);
    }];
    
}

- (FSCalendar *)calendar {
    if (_calendar == nil) {
        _calendar = [[FSCalendar alloc] init];
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
