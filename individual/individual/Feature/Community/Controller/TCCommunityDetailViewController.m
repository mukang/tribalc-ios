//
//  TCCommunityDetailViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunityDetailViewController.h"
#import "TCCommunityVisitViewController.h"

#import "TCImagePlayerView.h"
#import "TCCommunityIntroViewCell.h"
#import "TCCommunityLocationViewCell.h"
#import "TCCommunitySurroundingViewCell.h"
#import "TCCommunitySurroundingTitleViewCell.h"
#import "TCCommunitySurroundingSubtitleViewCell.h"

#import "TCRefreshHeader.h"

#import "TCBuluoApi.h"

@interface TCCommunityDetailViewController () <UITableViewDataSource, UITableViewDelegate, TCCommunityIntroViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) TCImagePlayerView *tableHeaderView;
@property (strong, nonatomic) TCCommunityDetailInfo *communityDetailInfo;

@end

@implementation TCCommunityDetailViewController {
    __weak TCCommunityDetailViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
    [self loadNetData];
}

- (void)setupNavBar {
    self.navigationItem.title = @"社区详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    self.tableView.estimatedRowHeight = 220;
    
    CGRect frame = CGRectMake(0, 0, TCScreenWidth, TCRealValue(270));
    TCImagePlayerView *tableHeaderView = [[TCImagePlayerView alloc] initWithFrame:frame];
    self.tableView.tableHeaderView = tableHeaderView;
    self.tableHeaderView = tableHeaderView;
    
    self.tableView.mj_header = [TCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNetData)];
    
    UINib *nib = [UINib nibWithNibName:@"TCCommunityIntroViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCCommunityIntroViewCell"];
    nib = [UINib nibWithNibName:@"TCCommunityLocationViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCCommunityLocationViewCell"];
    nib = [UINib nibWithNibName:@"TCCommunitySurroundingViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCCommunitySurroundingViewCell"];
    nib = [UINib nibWithNibName:@"TCCommunitySurroundingTitleViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCCommunitySurroundingTitleViewCell"];
    nib = [UINib nibWithNibName:@"TCCommunitySurroundingSubtitleViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCCommunitySurroundingSubtitleViewCell"];
}

- (void)loadNetData {
    [[TCBuluoApi api] fetchCommunityDetailInfo:self.communityID result:^(TCCommunityDetailInfo *communityDetailInfo, NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (communityDetailInfo) {
            weakSelf.communityDetailInfo = communityDetailInfo;
            [weakSelf updateTableHeaderView];
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];
}

- (void)updateTableHeaderView {
    
    [self.tableHeaderView setPictures:self.communityDetailInfo.pictures isLocal:NO];
    [self.tableHeaderView startPlaying];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return (self.communityDetailInfo.repastList.count + self.communityDetailInfo.entertainmentList.count + 2);
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    if (indexPath.section == 0) {
        TCCommunityIntroViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommunityIntroViewCell" forIndexPath:indexPath];
        cell.communityDetailInfo = self.communityDetailInfo;
        cell.delegate = self;
        currentCell = cell;
    } else if (indexPath.section == 1) {
        TCCommunityLocationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommunityLocationViewCell" forIndexPath:indexPath];
        cell.communityDetailInfo = self.communityDetailInfo;
        currentCell = cell;
    } else {
        if (indexPath.row == 0) {
            TCCommunitySurroundingTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommunitySurroundingTitleViewCell" forIndexPath:indexPath];
            currentCell = cell;
        } else if (indexPath.row == self.communityDetailInfo.repastList.count + 1) {
            TCCommunitySurroundingSubtitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommunitySurroundingSubtitleViewCell" forIndexPath:indexPath];
            currentCell = cell;
        } else {
            TCCommunitySurroundingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommunitySurroundingViewCell" forIndexPath:indexPath];
            TCStoreInfo *storeInfo;
            if (indexPath.row <= self.communityDetailInfo.repastList.count) {
                storeInfo = self.communityDetailInfo.repastList[indexPath.row - 1];
            } else {
                storeInfo = self.communityDetailInfo.entertainmentList[indexPath.row - self.communityDetailInfo.repastList.count -2];
            }
            cell.storeInfo = storeInfo;
            currentCell = cell;
        }
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case 0:
        case 1:
            return 7.5;
            break;
        default:
            return 0.1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.row == 0 || indexPath.row == self.communityDetailInfo.repastList.count + 1) {
            return;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        /*
        TCStoreInfo *storeInfo;
        if (indexPath.row <= self.communityDetailInfo.repastList.count) {
            storeInfo = self.communityDetailInfo.repastList[indexPath.row - 1];
        } else {
            storeInfo = self.communityDetailInfo.entertainmentList[indexPath.row - self.communityDetailInfo.repastList.count -2];
        }
        TCRestaurantInfoViewController *vc = [[TCRestaurantInfoViewController alloc] initWithServiceId:storeInfo.ID];
        [self.navigationController pushViewController:vc animated:YES];
         */
    }
}

#pragma mark - TCCommunityIntroViewCellDelegate

- (void)communityIntroViewCell:(TCCommunityIntroViewCell *)cell didClickVisitButtonWithCommunityDetailInfo:(TCCommunityDetailInfo *)info {
    if (!self.communityDetailInfo) {
        return;
    }
    TCCommunityVisitViewController *vc = [[TCCommunityVisitViewController alloc] initWithNibName:@"TCCommunityVisitViewController" bundle:[NSBundle mainBundle]];
    vc.communityDetailInfo = self.communityDetailInfo;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
