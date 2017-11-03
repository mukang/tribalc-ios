//
//  TCMeetingRoomRemindViewController.m
//  individual
//
//  Created by 穆康 on 2017/11/2.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomRemindViewController.h"

#import "TCMeetingRoomRemindViewCell.h"


#import <TCCommonLibs/TCCommonButton.h>

@interface TCMeetingRoomRemindViewController () <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSArray *remindArray;

@end

@implementation TCMeetingRoomRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"提醒";
    
    [self setupSubviews];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.estimatedRowHeight = 45;
    tableView.estimatedSectionHeaderHeight = 7;
    tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
    tableView.rowHeight = 45;
    tableView.sectionHeaderHeight = 7;
    tableView.sectionFooterHeight = CGFLOAT_MIN;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCMeetingRoomRemindViewCell class] forCellReuseIdentifier:@"TCMeetingRoomRemindViewCell"];
    [self.view addSubview:tableView];
    
    TCCommonButton *nextButton = [TCCommonButton buttonWithTitle:@"确  定"
                                                           color:TCCommonButtonColorPurple
                                                          target:self
                                                          action:@selector(handleClickConfirmButton)];
    [self.view addSubview:nextButton];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(nextButton.mas_top);
    }];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49);
        make.bottom.left.right.equalTo(self.view);
    }];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    for (int i=0; i<self.remindArray.count; i++) {
        TCMeetingRoomRemind *remind = self.remindArray[i];
        if (remind.remindTime == self.currentRemind.remindTime) {
            indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.remindArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMeetingRoomRemindViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomRemindViewCell" forIndexPath:indexPath];
    TCMeetingRoomRemind *remind = self.remindArray[indexPath.row];
    cell.textLabel.text = remind.remindStr;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentRemind = self.remindArray[indexPath.row];
}

#pragma mark - Actions

- (void)handleClickConfirmButton {
    if ([self.delegate respondsToSelector:@selector(didClickConfirmButtonInMeetingRoomRemindViewController:)]) {
        [self.delegate didClickConfirmButtonInMeetingRoomRemindViewController:self];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Override Methods

- (NSArray *)remindArray {
    if (_remindArray == nil) {
        TCMeetingRoomRemind *remind01 = [TCMeetingRoomRemind remindWithRemindTime:0 remindStr:@"无需提醒"];
        TCMeetingRoomRemind *remind02 = [TCMeetingRoomRemind remindWithRemindTime:300 remindStr:@"提前5分钟"];
        TCMeetingRoomRemind *remind03 = [TCMeetingRoomRemind remindWithRemindTime:900 remindStr:@"提前15分钟"];
        TCMeetingRoomRemind *remind04 = [TCMeetingRoomRemind remindWithRemindTime:1800 remindStr:@"提前30分钟"];
        TCMeetingRoomRemind *remind05 = [TCMeetingRoomRemind remindWithRemindTime:3600 remindStr:@"提前1小时"];
        _remindArray = @[remind01, remind02, remind03, remind04, remind05];
    }
    return _remindArray;
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
