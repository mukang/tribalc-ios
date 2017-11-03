//
//  TCMeetingRoomContactsViewController.m
//  individual
//
//  Created by 穆康 on 2017/11/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomContactsViewController.h"

#import "TCMeetingRoomNoParticipantView.h"

@interface TCMeetingRoomContactsViewController ()

@end

@implementation TCMeetingRoomContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"参会人";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
    [self setupConstraints];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    TCMeetingRoomNoParticipantView *noParticipantView = [[TCMeetingRoomNoParticipantView alloc] init];
    [self.view addSubview:noParticipantView];
    
    
    
    
}

- (void)setupConstraints {
    
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
