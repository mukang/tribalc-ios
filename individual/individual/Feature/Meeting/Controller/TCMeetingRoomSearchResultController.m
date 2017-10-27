//
//  TCMeetingRoomSearchResultController.m
//  individual
//
//  Created by 王帅锋 on 2017/10/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomSearchResultController.h"
#import "TCMeetingRoomSearchResultCell.h"

#import "TCMeetingRoomSearchResultCell.h"
#import "TCMeetingRoomSearchResultHeaderView.h"

#import "TCMeetingRoomConditions.h"

@interface TCMeetingRoomSearchResultController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *arr;

@end

@implementation TCMeetingRoomSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"会议室预定";
    [self setUpViews];
}

- (void)setUpViews {
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCMeetingRoomSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCMeetingRoomSearchResultCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark UITableViewDelegate

#pragma mark getter

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[TCMeetingRoomSearchResultCell class] forCellReuseIdentifier:@"TCMeetingRoomSearchResultCell"];
        NSMutableString *mutableStr = [[NSMutableString alloc] init];
        [self.conditions.selectedDevices enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSString *str = (NSString *)obj;
            [mutableStr appendString:str];
        }];
        NSString *str = @"会议室设备：";
        CGSize titleSize = [str boundingRectWithSize:CGSizeMake(9999.0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        CGFloat maxW = TCScreenWidth - 12 - 25 - titleSize.width - 15 - 15;
        
        CGSize size = [mutableStr boundingRectWithSize:CGSizeMake(maxW, 9999.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        TCMeetingRoomSearchResultHeaderView *headerView = [[TCMeetingRoomSearchResultHeaderView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, -titleSize.height + size.height)];
        headerView.currentConditions = self.conditions;
        _tableView.tableHeaderView = headerView;
    }
    return _tableView;
}

- (void)dealloc {
    NSLog(@"TCMeetingRoomSearchResultController -- dealloc");
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
