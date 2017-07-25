//
//  TCCreditBillViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreditBillViewController.h"
#import "TCCreditBillViewCell.h"

@interface TCCreditBillViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TCCreditBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史账单";
    // Do any additional setup after loading the view.
    [self setUpViews];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"2017年";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 23;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCCreditBillViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCreditBillViewCell" forIndexPath:indexPath];
    return cell;
}

- (void)setUpViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 70;
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, CGFLOAT_MIN)];
        _tableView.tableHeaderView = headerView;
        [_tableView registerClass:[TCCreditBillViewCell class] forCellReuseIdentifier:@"TCCreditBillViewCell"];
    }
    return _tableView;
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
