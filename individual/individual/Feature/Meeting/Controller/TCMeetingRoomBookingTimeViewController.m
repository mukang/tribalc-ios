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

#import <TCCommonLibs/TCCommonButton.h>

@interface TCMeetingRoomBookingTimeViewController ()

@property (weak, nonatomic) TCBookingDateView *dateView;
@property (weak, nonatomic) TCBookingTimeView *timeView;
@property (weak, nonatomic) TCBookingTimeNoteView *noteView;
@property (weak, nonatomic) TCCommonButton *confirmButton;

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
    TCBookingDateView *dateView = [[TCBookingDateView alloc] init];
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

- (void)handleClickConfirmButton {
    
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
