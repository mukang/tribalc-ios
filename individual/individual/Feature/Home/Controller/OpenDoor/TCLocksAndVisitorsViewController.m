//
//  TCLocksAndVisitorsViewController.m
//  individual
//
//  Created by 王帅锋 on 17/3/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLocksAndVisitorsViewController.h"
#import <Masonry.h>

@interface TCLocksAndVisitorsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) TCLocksOrVisitors locksOrVisitors;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UIButton *addBtn;

@end

@implementation TCLocksAndVisitorsViewController

- (instancetype)initWithType:(TCLocksOrVisitors)locksOrVisitors {
    if (self = [super init]) {
        _locksOrVisitors = locksOrVisitors;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideOriginalNavBar = YES;
}

- (void)setUpViews {
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.cornerRadius = 5.0;
        _tableView.layer.borderColor = TCRGBColor(186, 186, 186).CGColor;
        CGFloat scale = TCScreenWidth > 375.0 ? 3 : 2;
        _tableView.layer.borderWidth = 1 / scale;
        _tableView.clipsToBounds = YES;
    }
    return _tableView;
}

- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _addBtn;
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
