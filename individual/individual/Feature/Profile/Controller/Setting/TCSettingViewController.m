//
//  TCSettingViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSettingViewController.h"
#import "TCSuggestionViewController.h"
#import "TCMessageManagementViewController.h"

#import <TCCommonLibs/TCCommonIndicatorViewCell.h>
#import "TCSettingNotificationViewCell.h"
#import "TCSettingCacheViewCell.h"
#import <TCCommonLibs/TCCommonButton.h>

#import "TCBuluoApi.h"
#import "TCAboutUSViewController.h"
#import <SDImageCache.h>

@interface TCSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TCSettingViewController {
    __weak TCSettingViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)setupNavBar {
    self.navigationItem.title = @"设置";
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.rowHeight = 54;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCSettingNotificationViewCell class] forCellReuseIdentifier:@"TCSettingNotificationViewCell"];
    [tableView registerClass:[TCSettingCacheViewCell class] forCellReuseIdentifier:@"TCSettingCacheViewCell"];
    [tableView registerClass:[TCCommonIndicatorViewCell class] forCellReuseIdentifier:@"TCCommonIndicatorViewCell"];
    [self.view addSubview:tableView];
    
    TCCommonButton *logouButton = [TCCommonButton buttonWithTitle:@"退出" color:TCCommonButtonColorPurple target:self action:@selector(handleClickLogoutButton:)];
    [self.view addSubview:logouButton];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.view);
    }];
    
    [logouButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(30);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-30);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(TCRealValue(-71));
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - Status Bar



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TCSettingNotificationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCSettingNotificationViewCell" forIndexPath:indexPath];
            return cell;
        } else {
            TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
            cell.titleLabel.text = @"消息管理";
            return cell;
        }
    } else {
        if (indexPath.row == 0) {
            TCSettingCacheViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCSettingCacheViewCell" forIndexPath:indexPath];
            return cell;
        } else {
            TCCommonIndicatorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonIndicatorViewCell" forIndexPath:indexPath];
            if (indexPath.row == 1) {
                cell.titleLabel.text = @"关于我们";
            } else {
                cell.titleLabel.text = @"意见反馈";
            }
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            TCMessageManagementViewController *vc = [[TCMessageManagementViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        switch (indexPath.row) {
            case 0:
                break;
            case 1:
            {
                TCAboutUSViewController *aboutUs = [[TCAboutUSViewController alloc] init];
                [self.navigationController pushViewController:aboutUs animated:YES];
            }
                break;
            case 2:
            {
                TCSuggestionViewController *vc = [[TCSuggestionViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}


#pragma mark - Actions

- (void)handleClickLogoutButton:(UIButton *)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确定退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf handleUserLogout];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)handleUserLogout {
    [[TCBuluoApi api] logout:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
