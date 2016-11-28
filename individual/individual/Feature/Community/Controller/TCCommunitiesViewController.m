//
//  TCCommunitiesViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunitiesViewController.h"

#import "TCCommunityViewCell.h"

#import "UIImage+Category.h"

@interface TCCommunitiesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation TCCommunitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavBar];
    [self setupSubviews];
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
    self.flowLayout.minimumLineSpacing = 5;
    self.flowLayout.itemSize = CGSizeMake(TCScreenWidth, 272);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    UINib *nib = [UINib nibWithNibName:@"TCCommunityViewCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"TCCommunityViewCell"];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCCommunityViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TCCommunityViewCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
