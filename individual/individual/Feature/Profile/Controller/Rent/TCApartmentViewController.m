//
//  TCApartmentViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/6/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCApartmentViewController.h"
#import "TCBuluoApi.h"
#import <TCCommonLibs/TCImageURLSynthesizer.h>
#import <UIImageView+WebCache.h>
#import "TCApartmentCell.h"

@interface TCApartmentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) UINavigationBar *navBar;

@property (weak, nonatomic) UINavigationItem *navItem;

@property (copy, nonatomic) NSArray *rentProtocolArr;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation TCApartmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    
    [self loadData];
}

#pragma mark UITableViewDelegate

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rentProtocolArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCApartmentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCApartmentCell" forIndexPath:indexPath];
    cell.rentProtocol = self.rentProtocolArr[indexPath.row];
    return cell;
}

- (void)loadData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchRentProtocolList:^(NSArray *rentProtocolList, NSError *error) {
        if ([rentProtocolList isKindOfClass:[NSArray class]]) {
            [MBProgressHUD hideHUD:YES];
            self.rentProtocolArr = rentProtocolList;
            [self.tableView reloadData];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取公寓列表失败，%@", reason]];
        }
    }];
}

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [navBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [navBar setBackgroundImage:[UIImage imageNamed:@"TransparentPixel"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] initWithTitle:@"我的公寓"];
    navBar.titleTextAttributes = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:16],
                                   NSForegroundColorAttributeName : [UIColor whiteColor]
                                   };
    UIImage *backImage = [[UIImage imageNamed:@"nav_back_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickBackButton:)];
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[TCApartmentCell class] forCellReuseIdentifier:@"TCApartmentCell"];
        
        UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, TCRealValue(280))];
        headerView.image = [UIImage imageNamed:@"apartmenHeaderImage"];
        _tableView.tableHeaderView = headerView;
        
        UIImageView *iconImageView = [[UIImageView alloc] init];
        iconImageView.layer.cornerRadius = TCRealValue(64)/2;
        iconImageView.clipsToBounds = YES;
        [headerView addSubview:iconImageView];
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:[TCBuluoApi api].currentUserSession.userInfo.picture];
        [iconImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headerView);
            make.centerY.equalTo(headerView).offset(-(TCRealValue(11)));
            make.width.height.equalTo(@(TCRealValue(64)));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"欢迎来到我的公寓！";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(headerView);
            make.top.equalTo(iconImageView.mas_bottom).offset(TCRealValue(20));
        }];
        
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
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
