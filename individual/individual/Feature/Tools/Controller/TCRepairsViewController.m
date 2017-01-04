//
//  TCRepairsViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRepairsViewController.h"
#import "TCRepairsDetailViewController.h"

#import "TCRepairsViewCell.h"
#import "TCPropertyManageListController.h"

#import "TCBuluoApi.h"

@interface TCRepairsViewController () <UITableViewDataSource, UITableViewDelegate, TCRepairsViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TCRepairsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

- (void)setupNavBar {
    self.navigationItem.title = @"物业报修";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"repairs_order_button"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickOrderButton:)];
}

- (void)setupSubviews {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"TCRepairsViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCRepairsViewCell"];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCRepairsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRepairsViewCell" forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableView.height;
}

#pragma mark - TCRepairsViewCellDelegate

- (void)repairsViewCell:(TCRepairsViewCell *)cell didClickRepairsButtonWithIndex:(NSInteger)index {
    TCUserSensitiveInfo *userSensitiveInfo = [TCBuluoApi api].currentUserSession.userSensitiveInfo;
    if (!userSensitiveInfo.companyID) {
        [MBProgressHUD showHUDWithMessage:@"绑定公司成功后才可申请物业报修"];
        return;
    }
    
    TCPropertyRepairsType repairsType = index;
    TCRepairsDetailViewController *vc = [[TCRepairsDetailViewController alloc] initWithPropertyRepairsType:repairsType];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleClickOrderButton:(UIBarButtonItem *)sender {
    TCPropertyManageListController *propertyList = [[TCPropertyManageListController alloc] init];
    propertyList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:propertyList animated:YES];
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
