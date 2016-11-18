//
//  TCRecommendListViewController.m
//  individual
//
//  Created by WYH on 16/11/4.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRecommendListViewController.h"

@interface TCRecommendListViewController () {
    TCGoodsWrapper *goodsInfoWrapper;
    UICollectionView *recommendCollectionView;
    UIImageView *collectionImageView;
    NSMutableArray *collectionImgArr;
}

@end

@implementation TCRecommendListViewController

- (void)viewDidAppear:(BOOL)animated {
    [self initialNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialNavigationBar];

    collectionImgArr = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self initialCollectionView];
    

    [self initialGoodsData];

}

# pragma mark - 初始化数据
- (void)initialGoodsData {
    TCBuluoApi *api = [TCBuluoApi api];
    [api fetchGoodsWrapper:50 sortSkip:nil result:^(TCGoodsWrapper *goodsWrapper, NSError *error) {
        
        goodsInfoWrapper = goodsWrapper;
        [recommendCollectionView reloadData];
        [recommendCollectionView.mj_header endRefreshing];

    }];

}

- (void)initialGoodsDataWithSortSkip:(NSString *)sortSkip {
    TCBuluoApi *api = [TCBuluoApi api];
    [api fetchGoodsWrapper:50 sortSkip:sortSkip result:^(TCGoodsWrapper *goodsWrapper, NSError *error) {
        
        NSArray *infoArr = goodsInfoWrapper.content;
        goodsInfoWrapper = goodsWrapper;
        goodsInfoWrapper.content = [infoArr arrayByAddingObjectsFromArray:goodsWrapper.content];
        [recommendCollectionView reloadData];
        [recommendCollectionView.mj_footer endRefreshing];
        
    }];
    
}

- (void)initialNavigationBar {

    
    UIButton *leftBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:@"back"];
    [leftBtn addTarget:self action:@selector(touchBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.titleView = [TCGetNavigationItem getTitleItemWithText:@"精品推荐"];
    
    UIButton *rightBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 25, 26) AndImageName:@"goods_shoppingcar"];
    [rightBtn addTarget:self action:@selector(touchShopCar:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

    
    

}


- (void)initialCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    recommendCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    recommendCollectionView.delegate = self;
    recommendCollectionView.dataSource = self;
    recommendCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);

    recommendCollectionView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    [self.view addSubview:recommendCollectionView];
    
    [recommendCollectionView registerClass:[TCRecommendGoodCell class] forCellWithReuseIdentifier:@"cellId"];
    [recommendCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    [self setCollectionPullToRefresh];
}

- (void)setCollectionPullToRefresh {
    
    TCRecommendHeader *refreshHeader = [TCRecommendHeader headerWithRefreshingBlock:^{
        [self initialGoodsData];
    }];
    recommendCollectionView.mj_header = refreshHeader;
    
    TCRecommendFooter *refreshFooter = [TCRecommendFooter footerWithRefreshingBlock:^{
        [self initialGoodsDataWithSortSkip:goodsInfoWrapper.nextSkip];
    }];
    recommendCollectionView.mj_footer = refreshFooter;
}


# pragma mark - collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return goodsInfoWrapper.content.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCGoods *info = goodsInfoWrapper.content[indexPath.row];
    TCRecommendGoodCell *cell = (TCRecommendGoodCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    NSString *imgUrlStr = [NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, info.mainPicture];
    NSURL *imgURL = [NSURL URLWithString:imgUrlStr];
    [cell.goodImageView sd_setImageWithURL:imgURL];
    
    cell.shopNameLab.text = info.brand;
    cell.typeAndNameLab.text = [NSString stringWithFormat:@"%@ %@", info.category, info.name];
    cell.priceLab.text = [NSString stringWithFormat:@"￥%@", [self changeFloat:info.salePrice]];
    
    collectionImgArr[indexPath.row] = cell.collectionImgView;
    
    [cell.collectionBtn addTarget:self action:@selector(touchCollectionButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.collectionBtn.tag = indexPath.row;
    
    return cell;
}



- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSDictionary *info = goodsInfoArray[indexPath.row];    data
    
    TCRecommendInfoViewController *recommendInfoViewController = [[TCRecommendInfoViewController alloc] initWithGoodInfo:goodsInfoWrapper.content[indexPath.row]];
    [self.navigationController pushViewController:recommendInfoViewController animated:YES];
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width - 37) / 2, (self.view.frame.size.width - 37) / 2 * 1.73);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(7, 12.5, 7, 12);

}


# pragma mark - touch 
- (void)touchCollectionButton:(UIButton *)button {
    NSInteger index = button.tag;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@""]];
    request.HTTPMethod = @"post";
    NSDictionary *body = @{};
    NSData *data = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    request.HTTPBody = data;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
        }
    }];
    [dataTask resume];
    
    
    UIImageView *imgView = collectionImgArr[index];
    UIImage *image = [UIImage imageNamed:@"good_collection_no"];
    UIImage *selectImg = [UIImage imageNamed:@"good_collection_yes"];
    if ([imgView.image isEqual:image]) {
        imgView.image = selectImg;
    } else {
        imgView.image = image;
    }

}


- (void)touchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchShopCar:(id)sender {
    TCShoppingCartViewController *shoppingCartViewController = [[TCShoppingCartViewController alloc] init];
    shoppingCartViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:shoppingCartViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(NSString *)changeFloat:(float)flo
{
    NSString *stringFloat = [NSString stringWithFormat:@"%f", flo];
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    int zeroLength = 0;
    NSUInteger i = length-1;
    for(; (int)i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
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
