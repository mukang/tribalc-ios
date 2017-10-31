//
//  TCMeetingRoomConditionsViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomConditionsViewController.h"
#import "TCMeetingRoomSearchResultController.h"

#import "TCMeetingRoomConditionsTimeCell.h"
#import "TCMeetingRoomConditionsFloorCell.h"
#import "TCMeetingRoomConditionsDevicesCell.h"
#import "TCMeetingRoomConditionsDurationCell.h"
#import "TCMeetingRoomConditionsNumberCell.h"
#import <TCCommonLibs/TCDatePickerView.h>

#import <TCCommonLibs/TCCommonButton.h>
#import <UITableView+FDTemplateLayoutCell.h>

#import "TCMeetingRoomConditions.h"
#import "TCBuluoApi.h"

@interface TCMeetingRoomConditionsViewController ()
<UITableViewDelegate,UITableViewDataSource,
TCMeetingRoomConditionsNumberCellDelegate,
TCMeetingRoomConditionsTimeCellDelegate,
TCMeetingRoomConditionsDurationCellDelegate,
TCDatePickerViewDelegate,
TCMeetingRoomConditionsDevicesCellDelegate,
TCMeetingRoomConditionsFloorCellDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) TCCommonButton *nextBtn;

@property (copy, nonatomic) NSArray *devices;

@property (strong, nonatomic) TCMeetingRoomConditions *conditions;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (strong, nonatomic) TCDatePickerView *datePickerView;

@property (assign, nonatomic) BOOL isFirstDate;

@property (weak, nonatomic) UITextField *startTextField;

@property (weak, nonatomic) UITextField *endTextField;

@end

@implementation TCMeetingRoomConditionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"筛选条件";
    [self setUpViews];

    [self loadData];
}

- (void)loadData {
    @WeakObj(self)
    [[TCBuluoApi api] fetchMeetingRoomEquipmetsWithResult:^(NSArray *meetingRoomsEquipments, NSError *error) {
        @StrongObj(self)
        if ([meetingRoomsEquipments isKindOfClass:[NSArray class]]) {
            self.devices = meetingRoomsEquipments;
            [self.tableView reloadData];
        }
    }];
}

- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.nextBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.nextBtn);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.equalTo(@47);
    }];
}

- (void)next {
    TCMeetingRoomSearchResultController *resultVC = [[TCMeetingRoomSearchResultController alloc] init];
    resultVC.conditions = self.conditions;
    [self.navigationController pushViewController:resultVC animated:YES];
}

#pragma mark UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 45;
    }else if (indexPath.section == 1) {
        return 114;
    }else {
        return [tableView fd_heightForCellWithIdentifier:@"TCMeetingRoomConditionsDevicesCell" configuration:^(TCMeetingRoomConditionsDevicesCell *cell) {
            cell.devices = self.devices;
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        return 1;
    }else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TCMeetingRoomConditionsFloorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomConditionsFloorCell" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }else if (indexPath.row == 1) {
            TCMeetingRoomConditionsNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomConditionsNumberCell" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }else {
            TCMeetingRoomConditionsTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomConditionsTimeCell" forIndexPath:indexPath];
            cell.delegate = self;
            return cell;
        }
    }else if (indexPath.section == 1) {
        TCMeetingRoomConditionsDurationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomConditionsDurationCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    }else {
        TCMeetingRoomConditionsDevicesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomConditionsDevicesCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.devices = self.devices;
        return cell;
    }
}

#pragma mark UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark TCDatePickerViewDelegate

- (void)didClickConfirmButtonInDatePickerView:(TCDatePickerView *)view {
    NSTimeInterval timestamp = [view.datePicker.date timeIntervalSince1970];
    NSString *str = [self.dateFormatter stringFromDate:view.datePicker.date];
    if (self.isFirstDate) {
        self.conditions.startDate = [NSString stringWithFormat:@"%.0f",timestamp*1000];
        self.conditions.startDateStr = str;
        self.startTextField.text = str;
    }else {
        self.conditions.endDate = [NSString stringWithFormat:@"%.0f",timestamp*1000];
        self.conditions.endDateStr = str;
        self.endTextField.text = str;
    }
}

#pragma mark TCMeetingRoomConditionsFloorCellDelegate

- (void)floorCellDidEndEditingWithTextField:(UITextField *)textField {
    if (textField.tag == 11111) {
        self.conditions.startFloor = textField.text;
    }else {
        self.conditions.endFloor = textField.text;
    }
}

#pragma mark TCMeetingRoomConditionsDevicesCellDelegate

- (void)devicesCellDidClickDeviceBtn:(TCMeetingRoomEquipment *)equ isDelete:(BOOL)isDelete {
    if (isDelete) {
        [self.conditions.selectedDevices removeObject:equ];
    }else {
        if (![self.conditions.selectedDevices containsObject:equ]) {
            [self.conditions.selectedDevices addObject:equ];
        }
    }
}

#pragma mark TCMeetingRoomConditionsDurationCellDelegate

- (void)durationCellshouldBeginEditingWithTextField:(UITextField *)textfield {
    if (textfield.tag == 10001) {
        self.startTextField = textfield;
        self.isFirstDate = YES;
    }else {
        self.endTextField = textfield;
        self.isFirstDate = NO;
    }
    //弹出滚轮
    [self.view endEditing:YES];
    [self.datePickerView show];
}

#pragma mark TCMeetingRoomConditionsTimeCellDelegate

- (void)timeCellDidEndEditingWithTextField:(UITextField *)textfield {
    self.conditions.hours = textfield.text;
}

#pragma mark TCMeetingRoomConditionsNumberCellDelegate

- (void)numberCelldidEndEditingWithTextField:(UITextField *)textfield {
    self.conditions.number = textfield.text;
}

#pragma mark getter

- (TCMeetingRoomConditions *)conditions {
    if (_conditions == nil) {
        _conditions = [[TCMeetingRoomConditions alloc] init];
        _conditions.selectedDevices = [[NSMutableSet alloc] initWithCapacity:0];
    }
    return _conditions;
}

- (TCCommonButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [TCCommonButton buttonWithTitle:@"下一步" color:TCCommonButtonColorPurple target:self action:@selector(next)];
    }
    return _nextBtn;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TCMeetingRoomConditionsNumberCell class] forCellReuseIdentifier:@"TCMeetingRoomConditionsNumberCell"];
        [_tableView registerClass:[TCMeetingRoomConditionsTimeCell class] forCellReuseIdentifier:@"TCMeetingRoomConditionsTimeCell"];
        [_tableView registerClass:[TCMeetingRoomConditionsFloorCell class] forCellReuseIdentifier:@"TCMeetingRoomConditionsFloorCell"];
        [_tableView registerClass:[TCMeetingRoomConditionsDevicesCell class] forCellReuseIdentifier:@"TCMeetingRoomConditionsDevicesCell"];
        [_tableView registerClass:[TCMeetingRoomConditionsDurationCell class] forCellReuseIdentifier:@"TCMeetingRoomConditionsDurationCell"];
    }
    return _tableView;
}

- (TCDatePickerView *)datePickerView {
    if (_datePickerView == nil) {
        _datePickerView = [[TCDatePickerView alloc] initWithController:self];
        _datePickerView.datePicker.date = [NSDate date];
        
        _datePickerView.datePicker.datePickerMode = UIDatePickerModeDate;
        _datePickerView.datePicker.minimumDate = [NSDate date];
        _datePickerView.delegate = self;
    }
    return _datePickerView;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

- (void)dealloc {
    NSLog(@"TCMeetingRoomConditionsViewController -- dealloc");
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
