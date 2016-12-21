//
//  TCCommunitiesViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunitiesViewController.h"
#import "TCCommunityDetailViewController.h"

#import "TCCommunityViewCell.h"
#import "TCRefreshHeader.h"

#import "TCBuluoApi.h"

#import "UIImage+Category.h"

@interface TCCommunitiesViewController () <UICollectionViewDataSource, UICollectionViewDelegate, TCCommunityViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (strong, nonatomic) UIWebView *webView;

@property (strong, nonatomic) NSMutableArray *dataList;

@end

@implementation TCCommunitiesViewController {
    __weak TCCommunitiesViewController *weakSelf;
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
    self.navigationItem.title = @"社区列表";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName : [UIFont systemFontOfSize:16],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                    };
    UIImage *bgImage = [UIImage imageWithColor:TCRGBColor(42, 42, 42)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}

- (void)setupSubviews {
    self.collectionView.backgroundColor = TCRGBColor(242, 242, 242);
    self.flowLayout.minimumLineSpacing = 9;
    self.flowLayout.itemSize = CGSizeMake(TCScreenWidth - 23, 293);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(9, 11.5, 0, 11.5);
    
    [self.collectionView registerClass:[TCCommunityViewCell class] forCellWithReuseIdentifier:@"TCCommunityViewCell"];
    
    self.collectionView.mj_header = [TCRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNetData)];
}

- (void)loadNetData {
    [[TCBuluoApi api] fetchCommunityList:^(NSArray *communityList, NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
        if (communityList) {
            [weakSelf.dataList removeAllObjects];
            [weakSelf.dataList addObjectsFromArray:communityList];
            [weakSelf.collectionView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"加载失败，%@", reason]];
        }
    }];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return weakSelf.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCCommunityViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCCommunityViewCell" forIndexPath:indexPath];
    cell.community = self.dataList[indexPath.item];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TCCommunityDetailViewController *vc = [[TCCommunityDetailViewController alloc] initWithNibName:@"TCCommunityDetailViewController" bundle:[NSBundle mainBundle]];
    TCCommunity *community = self.dataList[indexPath.item];
    vc.communityID = community.ID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TCCommunityViewCellDelegate

- (void)communityViewCell:(TCCommunityViewCell *)cell didClickPhoneButtonWithCommunity:(TCCommunity *)community {
    if (!community.phone) {
        return;
    }
    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    NSString *URLString = [NSString stringWithFormat:@"tel://%@", community.phone];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
}

#pragma mark - Override Methods

- (NSMutableArray *)dataList {
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
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
