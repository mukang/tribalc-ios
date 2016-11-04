//
//  TCRecommendListViewController.m
//  individual
//
//  Created by WYH on 16/11/4.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRecommendListViewController.h"

@interface TCRecommendListViewController () {
    NSArray *goodsInfoArray;
    UICollectionView *recommendCollectionView;
    UIImageView *collectionImageView;
}

@end

@implementation TCRecommendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // Do any additional setup after loading the view.
    
    [self initialNavigationBar];
    [self initialGoodsData];
    [self initialCollectionView];
}

# pragma mark - 初始化数据
- (void)initialGoodsData {
    NSDictionary *info1 = @{ @"name": @"飞行员夹克", @"type": @"女装", @"price": @"399", @"image":@"", @"shop":@"Zara" };
    NSDictionary *info2 = @{ @"name": @"印花围巾", @"type": @"男装", @"price": @"1000", @"image":@"", @"shop":@"Nike" };
    NSDictionary *info3 = @{ @"name": @"印花连衣裙", @"type": @"女装", @"price": @"399", @"image":@"", @"shop":@"美特斯邦威" };
    NSDictionary *info4 = @{ @"name": @"Jacket", @"type": @"Ladies", @"price": @"399", @"image":@"" , @"shop":@"Zara"};
    NSDictionary *info5 = @{ @"name": @"印花连衣裙", @"type": @"女装", @"price": @"399", @"image":@"", @"shop":@"美特斯邦威" };
    NSDictionary *info6 = @{ @"name": @"印花连衣裙", @"type": @"女装", @"price": @"399", @"image":@"", @"shop":@"美特斯邦威" };
    
    goodsInfoArray = @[ info1, info2, info3, info4, info5, info6 ];
}

- (void)initialNavigationBar {
    UIBarButtonItem *leftItem = [self getButtomItemWithFrame:CGRectMake(0, 10, 11, 18) AndImageName:@"back_black" AndAction:@selector(touchBackBtn:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [self getButtomItemWithFrame:CGRectMake(self.view.frame.size.width - 80, 7, 26, 26) AndImageName:@"shopCar" AndAction:@selector(touchShopCar:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UILabel *centerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, 0, 30)];
    centerLab.font = [UIFont fontWithName:@"GillSans-SemiBold" size:19];
//    centerLab.font = [UIFont systemFontOfSize:19];
    centerLab.text = @"精品推荐";
    self.navigationItem.titleView = centerLab;

}

- (UIBarButtonItem *)getButtomItemWithFrame:(CGRect)frame AndImageName:(NSString *)imageName AndAction:(SEL)action {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:frame];
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, backBtn.frame.size.width, backBtn.frame.size.height)];
    backImgView.image = [UIImage imageNamed:imageName];
    [backBtn addSubview:backImgView];
    [backBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return item;
}

- (void)initialCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    recommendCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    recommendCollectionView.delegate = self;
    recommendCollectionView.dataSource = self;
    recommendCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:recommendCollectionView];
    
    [recommendCollectionView registerClass:[TCRecommendGoodCell class] forCellWithReuseIdentifier:@"cellId"];
    [recommendCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
}


# pragma mark - collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return goodsInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = goodsInfoArray[indexPath.row];
    TCRecommendGoodCell *cell = (TCRecommendGoodCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.shopNameLab.text = info[@"shop"];
    cell.typeAndNameLab.text = [NSString stringWithFormat:@"%@ %@", info[@"type"], info[@"name"]];
    cell.priceLab.text = [NSString stringWithFormat:@"￥%@", info[@"price"]];
    
    [cell.collectionBtn addTarget:self action:@selector(touchCollectionButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 30;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = goodsInfoArray[indexPath.row];
    NSLog(@"click%@", info);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.view.frame.size.width - 45) / 2, 330);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(15, 15, 15, 15);

}

# pragma mark - touch 
- (void)touchCollectionButton:(id)sender {
    
}

- (void)touchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchShopCar:(id)sender {
    
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
