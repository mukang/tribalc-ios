//
//  TCMeetingRoomAddAttendeeViewController.m
//  individual
//
//  Created by 穆康 on 2017/11/29.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomAddAttendeeViewController.h"

#import "TCMeetingRoomAddAttendeeView.h"

#import <TCCommonLibs/TCCommonButton.h>

@interface TCMeetingRoomAddAttendeeViewController ()

@property (weak, nonatomic) TCMeetingRoomAddAttendeeView *attendeeView;

@end

@implementation TCMeetingRoomAddAttendeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"参会人";
    [self setupSubviews];
}

- (void)setupSubviews {
    TCMeetingRoomAddAttendeeView *attendeeView = [[TCMeetingRoomAddAttendeeView alloc] init];
    [self.view addSubview:attendeeView];
    self.attendeeView = attendeeView;
    
    TCCommonButton *addButton = [TCCommonButton buttonWithTitle:@"新  建" color:TCCommonButtonColorPurple target:self action:@selector(handleClickAddButton:)];
    [self.view addSubview:addButton];
    
    [attendeeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(7);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(90);
    }];
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(315), 40));
        make.top.equalTo(attendeeView.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - Actions

- (void)handleClickAddButton:(id)sender {
    if ([self.attendeeView.nameTextField isFirstResponder]) {
        [self.attendeeView.nameTextField resignFirstResponder];
    }
    if ([self.attendeeView.phoneTextField isFirstResponder]) {
        [self.attendeeView.phoneTextField resignFirstResponder];
    }
    
    NSString *name = self.attendeeView.nameTextField.text;
    NSString *phone = self.attendeeView.phoneTextField.text;
    
    if (!name.length) {
        [MBProgressHUD showHUDWithMessage:@"请您填写姓名"];
        return;
    }
    if (!phone.length) {
        [MBProgressHUD showHUDWithMessage:@"请您填写电话号码"];
        return;
    }
    if (![self deptNumInputShouldNumber:phone]) {
        [MBProgressHUD showHUDWithMessage:@"电话号码只能为数字"];
        return;
    }
    
    
}

- (BOOL)deptNumInputShouldNumber:(NSString *)str {
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
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
