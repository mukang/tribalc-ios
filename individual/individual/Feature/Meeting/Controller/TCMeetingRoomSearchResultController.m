//
//  TCMeetingRoomSearchResultController.m
//  individual
//
//  Created by 王帅锋 on 2017/10/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomSearchResultController.h"
#import "TCMeetingRoomBookingRecordController.h"
#import "TCMeetingRoomViewController.h"

#import "TCMeetingRoomSearchResultCell.h"
#import "TCMeetingRoomSearchResultCell.h"
#import "TCMeetingRoomSearchResultHeaderView.h"

#import "TCMeetingRoomConditions.h"
#import "TCBuluoApi.h"

@interface TCMeetingRoomSearchResultController ()<UITableViewDelegate,UITableViewDataSource,TCMeetingRoomSearchResultHeaderViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *arr;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TCMeetingRoomSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会议室预定";
    [self setUpViews];
    [self setUpNav];
    [self loadData];
}

- (void)loadData {
    NSMutableString *mutableStr = [[NSMutableString alloc] init];
    [self.conditions.selectedDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        TCMeetingRoomEquipment *equ = (TCMeetingRoomEquipment *)obj;
        [mutableStr appendString:equ.ID];
        [mutableStr appendString:@","];
    }];
    
    if (mutableStr.length > 0) {
        [mutableStr replaceCharactersInRange:NSMakeRange(mutableStr.length-1, 1) withString:@""];
    }
    
    [MBProgressHUD showHUD:YES];
    @WeakObj(self)
    [[TCBuluoApi api] fetchMeetingRoomWithBeginFloor:self.conditions.startFloor endFloor:self.conditions.endFloor attendance:self.conditions.number searchBeginDate:self.conditions.startDate searchEndDate:self.conditions.endDate equipments:[mutableStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] duration:self.conditions.hours result:^(NSArray *meetingRooms, NSError *error) {
        @StrongObj(self)
        if ([meetingRooms isKindOfClass:[NSArray class]]) {
            [MBProgressHUD hideHUD:YES];
            self.arr = meetingRooms;
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];
}

- (void)setUpNav {
    UIBarButtonItem *recordItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"meeting_room_record"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(handleClickRecordButton:)];
    self.navigationItem.rightBarButtonItem = recordItem;
}

- (void)handleClickRecordButton:(UIBarButtonItem *)barItem {
    TCMeetingRoomBookingRecordController *recordVC = [[TCMeetingRoomBookingRecordController alloc] initWithMeetingRoomBookingRecordType:TCMeetingRoomContactsViewControllerTypeIndividual companyId:nil];
    [self.navigationController pushViewController:recordVC animated:YES];
}

- (void)setUpViews {
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMeetingRoomSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomSearchResultCell" forIndexPath:indexPath];
    cell.meetingRoom = self.arr[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = TCRGBColor(243, 243, 243);
    return view;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMeetingRoom *meetingRoom = self.arr[indexPath.section];
    TCMeetingRoomViewController *vc = [[TCMeetingRoomViewController alloc] initWithControllerType:TCMeetingRoomViewControllerTypeBooking];
    vc.meetingRoom = meetingRoom;
    vc.startDate = [self.dateFormatter dateFromString:self.conditions.startDateStr];
    vc.endDate = [self.dateFormatter dateFromString:self.conditions.endDateStr];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark TCMeetingRoomSearchResultHeaderViewDelegate

- (void)headerViewDidClickModifyBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TCMeetingRoomSearchResultCell class] forCellReuseIdentifier:@"TCMeetingRoomSearchResultCell"];
        NSMutableString *mutableStr = [[NSMutableString alloc] init];
        [self.conditions.selectedDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            TCMeetingRoomEquipment *equ = (TCMeetingRoomEquipment *)obj;
            NSString *str = equ.name;
            [mutableStr appendString:str];
            [mutableStr appendString:@","];
        }];
        if (mutableStr.length > 0) {
            [mutableStr replaceCharactersInRange:NSMakeRange(mutableStr.length-1, 1) withString:@""];
        }
        NSString *str = @"会议室设备：";
        CGSize titleSize = [str boundingRectWithSize:CGSizeMake(9999.0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        CGFloat maxW = TCScreenWidth - 12 - 25 - titleSize.width - 15 - 15;
        
        CGSize size = [mutableStr boundingRectWithSize:CGSizeMake(maxW, 9999.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        TCMeetingRoomSearchResultHeaderView *headerView = [[TCMeetingRoomSearchResultHeaderView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 200-titleSize.height + size.height)];
        headerView.delegate = self;
        headerView.currentConditions = self.conditions;
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}

- (void)dealloc {
    NSLog(@"TCMeetingRoomSearchResultController -- dealloc");
}

#pragma mark - Override Methods

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
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
