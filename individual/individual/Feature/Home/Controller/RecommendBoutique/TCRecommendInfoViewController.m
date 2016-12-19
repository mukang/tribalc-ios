//
//  TCRecommendInfoViewController.m
//  individual
//
//  Created by WYH on 16/11/12.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRecommendInfoViewController.h"
#import "TCUserOrderDetailViewController.h"
#import "TCBuluoApi.h"
#import "TCClientRequestError.h"
#import "TCImgPageControl.h"
#import "TCShoppingCartViewController.h"
#import "TCGoodSelectView.h"

@interface TCRecommendInfoViewController () {
    
    TCGoodSelectView *goodSelectView;
    
    
    CGFloat titleViewHeight;
    
    TCGoodDetail *mGoodDetail;
    UIScrollView *mScrollView;
    TCImgPageControl *imgPageControl;
    TCGoodStandards *goodStandard;
    NSString *mGoodId;
    UICollectionView *imageCollectionView;
    
    TCGoodTitleView *goodTitleView;
    UIWebView *textAndImageView;
    
}

@end

@implementation TCRecommendInfoViewController

- (instancetype)initWithGoodId:(NSString *)goodID {
    self = [super init];
    if (self) {
        mGoodId = goodID;
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor whiteColor];
    if (mScrollView == nil) {
        [self initScrollView];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initGoodDetailInfoWithGoodId:mGoodId];
    
    
}

- (void)initGoodDetailInfoWithGoodId:(NSString *)goodId {
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchGoodDetail:goodId result:^(TCGoodDetail *goodDetail, NSError *error) {
        if (goodDetail) {
            [MBProgressHUD hideHUD:YES];
            mGoodDetail = goodDetail;
            [self performSelectorOnMainThread:@selector(initUI) withObject:nil waitUntilDone:NO];
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取商品信息失败"];
        }
    }];
}

- (void)initUI {

    UIView *titleImageView = [self createTitleImageViewWithFrame:CGRectMake(0, 0, self.view.width, TCRealValue(394))];
    [mScrollView addSubview:titleImageView];
    
    goodTitleView = [[TCGoodTitleView alloc] initWithFrame:CGRectMake(0, titleImageView.y + titleImageView.height, self.view.width, TCRealValue(87)) WithTitle:mGoodDetail.name AndPrice:mGoodDetail.salePrice AndOriginPrice:mGoodDetail.originPrice AndTags:mGoodDetail.tags];
    [mScrollView addSubview:goodTitleView];
    
    UIButton *standardSelectBtn = [self createStandardSelectButtonWithFrame:CGRectMake(0, goodTitleView.y + goodTitleView.height + TCRealValue(7.5), self.view.width, TCRealValue(38))];
    [mScrollView addSubview:standardSelectBtn];
    
    UIView *shopView = [self createShopInfoViewWithFrame:CGRectMake(0, standardSelectBtn.y + standardSelectBtn.height + TCRealValue(7.5), self.view.width, TCRealValue(64))];
    [mScrollView addSubview:shopView];
    
    UISegmentedControl *selectGoodInfoSegment = [self createSelectGoodGraphicAndParameterView:CGRectMake(0, shopView.y + shopView.height, self.view.width, TCRealValue(39))];
    [mScrollView addSubview:selectGoodInfoSegment];
    
    NSString *webUrlStr = [NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, mGoodDetail.detailURL];
    textAndImageView = [self createURLInfoViewWithOrigin:CGPointMake(0, selectGoodInfoSegment.y + selectGoodInfoSegment.height) AndURLStr:webUrlStr];
    UIScrollView *tempView = (UIScrollView *)[textAndImageView.subviews objectAtIndex:0];
    tempView.scrollEnabled = NO;
    [mScrollView addSubview:textAndImageView];

    UIView *bottomView = [self createBottomViewWithFrame:CGRectMake(0, self.view.height - TCRealValue(49), self.view.width, TCRealValue(49))];
    [self.view addSubview:bottomView];

    [self initSelectSizeView];
    
    [self initBackButton];

}




- (void)initSelectSizeView {
    goodSelectView = [[TCGoodSelectView alloc] initWithGoodDetail:mGoodDetail];
    goodSelectView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:goodSelectView];
    
//
//    standardView = [[TCStandardView alloc] initWithTarget:self AndNumberAddAction:@selector(touchBuyNumberAddBtn:) AndNumberSubAction:@selector(touchBuyNumberSubBtn:) AndAddShopCarAction:@selector(touchAddShopCartBtn:) AndBuyAction:@selector(touchBuyBtn:) AndCloseAction:@selector(touchCloseBtn)];
//    [standardView setSalePriceAndInventoryWithSalePrice:mGoodDetail.salePrice AndInventory:mGoodDetail.repertory AndImgUrlStr:mGoodDetail.thumbnail];
//    [self.view addSubview:standardView];
//    [[UIApplication sharedApplication].keyWindow addSubview:standardView];
}


- (void)initScrollView {
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, self.view.width, self.view.height + 20 - TCRealValue(49))];
    mScrollView.contentSize = CGSizeMake(self.view.width, TCRealValue(1500));
    mScrollView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.view addSubview:mScrollView];
}


- (void)initBackButton {
    UIButton *backBtn = [self getBackButton];
    [backBtn addTarget:self action:@selector(touchBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (UIButton *)getBackButton {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(TCRealValue(13), TCRealValue(30), TCRealValue(27.5), TCRealValue(27.5))];
    backBtn.layer.cornerRadius = TCRealValue(27.5 / 2);
    backBtn.backgroundColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    [imgView sizeToFit];
    [imgView setFrame:CGRectMake(backBtn.width / 2 - imgView.width * 1.1 / 2 - 1.4, backBtn.height / 2 - imgView.height * 1.1 / 2, imgView.width * 1.1, imgView.height * 1.1)];
    [backBtn addSubview:imgView];

    return backBtn;
}

#pragma mark - Main UI

- (UIView *)createTitleImageViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    imageCollectionView = [self getTitleImageViewWithFrame:frame];
    imageCollectionView.bounces = NO;
    [view addSubview:imageCollectionView];
    
    NSArray *imgArr = mGoodDetail.pictures;
    imgPageControl = [[TCImgPageControl alloc] initWithFrame:CGRectMake(0, view.height - TCRealValue(20), self.view.width, TCRealValue(20))];
    imgPageControl.numberOfPages = imgArr.count;
    imgPageControl.userInteractionEnabled = NO;
    imgPageControl.currentPage = 0;
    [view addSubview:imgPageControl];
    
    return view;
}

- (UIButton *)createStandardSelectButtonWithFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    UILabel *selectLab = [TCComponent createLabelWithFrame:CGRectMake(TCRealValue(20), 0, frame.size.width - TCRealValue(20), frame.size.height) AndFontSize:TCRealValue(15) AndTitle:@"请选择规格"];
    [button addSubview:selectLab];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_select_standard"]];
    [imgView sizeToFit];
    [imgView setOrigin:CGPointMake(frame.size.width - TCRealValue(20) - imgView.width, frame.size.height / 2 - imgView.height / 2)];
    [button addSubview:imgView];
    
    [button addTarget:self action:@selector(touchSelectStandardBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIView *)createShopInfoViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(TCRealValue(20), TCRealValue(8), TCRealValue(48), TCRealValue(48))];
    [logoImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, mGoodDetail.thumbnail]]];
    [view addSubview:logoImgView];
    
    NSString *brandStr = [NSString stringWithFormat:@"品牌 : %@", mGoodDetail.brand];
    UILabel *brandLab = [TCComponent createLabelWithFrame:CGRectMake(logoImgView.x + logoImgView.width + TCRealValue(12), TCRealValue(8), frame.size.width - logoImgView.x + logoImgView.width + TCRealValue(12), TCRealValue(14)) AndFontSize:TCRealValue(14) AndTitle:brandStr AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
    brandLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:TCRealValue(14)];
    [view addSubview:brandLab];
    
    UIView *evaluateView = [self getEvaluateViewWithFrame:CGRectMake(brandLab.x, brandLab.y + brandLab.height + TCRealValue(4), brandLab.width, TCRealValue(13))];
    [view addSubview:evaluateView];
    
    NSString *salesStr = [NSString stringWithFormat:@"总销量 : %li", (long)mGoodDetail.saleQuantity];
    UILabel *salesLab = [self getLabelWithText:salesStr AndOrigin:CGPointMake(brandLab.x, evaluateView.y + evaluateView.height + TCRealValue(5))];
    [view addSubview:salesLab];
    
    NSString *profitStr = [NSString stringWithFormat:@"电话 : %@",  @"65573"];
    UILabel *profitLab = [self getLabelWithText:profitStr AndOrigin:CGPointMake(salesLab.x + salesLab.width + TCRealValue(15), salesLab.y)];
    [view addSubview:profitLab];

    return view;
}

- (UIView *)createBottomViewWithFrame:(CGRect)frame {
    UIView *view=  [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, frame.size.width, TCRealValue(0.5))];
    [view addSubview:lineView];
    
    UIButton *collectionView = [self createCollectionAndShopViewWithFrame:CGRectMake(0, 0, frame.size.width / 4, frame.size.height) AndImageName:@"good_collection_gray" AndText:@"收藏" AndAction:@selector(touchCollectionBtn:)];
    [view addSubview:collectionView];
    
    UIButton *shopCarImgBtn = [self createCollectionAndShopViewWithFrame:CGRectMake(collectionView.width, 0, frame.size.width / 4, frame.size.height) AndImageName:@"good_shoppingcar_gray" AndText:@"购物车" AndAction:@selector(touchShopCarBtn:)];
    [view addSubview:shopCarImgBtn];
    
    
    UIButton *shopCarBtn = [TCComponent createButtonWithFrame:CGRectMake(shopCarImgBtn.x + shopCarImgBtn.width, 0, frame.size.width / 2, frame.size.height) AndTitle:@"加入购物车" AndFontSize:TCRealValue(18)];
    [shopCarBtn addTarget:self action:@selector(touchAddShopCartBtnInDetailView:) forControlEvents:UIControlEventTouchUpInside];
    shopCarBtn.backgroundColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    [shopCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:shopCarBtn];
    
    return view;
}

- (UIButton *)createCollectionAndShopViewWithFrame:(CGRect)frame AndImageName:(NSString *)imageName AndText:(NSString *)text AndAction:(SEL)action{
    UIButton *view = [[UIButton alloc] initWithFrame:frame];
    
    UIImage *img = [UIImage imageNamed:imageName];
    UIButton *button = [TCComponent createButtonWithFrame:CGRectMake((frame.size.width - img.size.width) / 2, TCRealValue(10), img.size.width, img.size.height) AndTitle:@"" AndFontSize:0];
    [button setImage:img forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    [view addSubview:button];
    
    UILabel *label = [TCComponent createLabelWithFrame:CGRectMake(0, button.y + button.height + TCRealValue(3), frame.size.width, TCRealValue(12)) AndFontSize:TCRealValue(12) AndTitle:text AndTextColor:[UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1]];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    [view addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

    return view;
}

- (UISegmentedControl *)createSelectGoodGraphicAndParameterView:(CGRect)frame {
    
    UISegmentedControl *selectSegment = [self getSegmentControlWithFrame:frame];
    
    UIView *topLine = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, frame.size.width, TCRealValue(1))];
    UIView *downLine = [TCComponent createGrayLineWithFrame:CGRectMake(0, frame.size.height - TCRealValue(1), frame.size.width, TCRealValue(1))];
    [selectSegment addSubview:topLine];
    [selectSegment addSubview:downLine];
    
    UIView *centerLine = [TCComponent createGrayLineWithFrame:CGRectMake(frame.size.width / 2 - TCRealValue(0.25), frame.size.height / 2 - TCRealValue(13), TCRealValue(0.5), TCRealValue(26))];
    [selectSegment addSubview:centerLine];
    
    
    return selectSegment;
}

- (UIWebView *)createURLInfoViewWithOrigin:(CGPoint)point AndURLStr:(NSString *)urlstr{
    
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setOrigin:point];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    webView.delegate = self;
    [webView loadRequest:request];
    [webView sizeToFit];

    return webView;
}



#pragma mark - Component UI

- (UICollectionView *)getTitleImageViewWithFrame:(CGRect)frame {
    NSArray *imageArr = mGoodDetail.pictures;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.width, frame.size.height);
    layout.minimumLineSpacing = 0.0f;
    
    UICollectionView *imgCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
    imgCollectionView.delegate = self;
    imgCollectionView.dataSource = self;
    imgCollectionView.pagingEnabled = YES;
    imgCollectionView.showsHorizontalScrollIndicator = NO;
    imgCollectionView.showsVerticalScrollIndicator = NO;
    [imgCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    imgCollectionView.contentSize = CGSizeMake(imageArr.count * frame.size.width, frame.size.height);
    imgCollectionView.contentOffset = CGPointMake(0, 0);
    
    imgCollectionView.backgroundColor = [UIColor whiteColor];

    return imgCollectionView;
}

- (UISegmentedControl *)getSegmentControlWithFrame:(CGRect)frame {
    NSArray *segmentArr = @[ @"图文详情", @"产品参数" ];
    UISegmentedControl *selectSegment = [[UISegmentedControl alloc] initWithItems:segmentArr];
    [selectSegment setFrame:frame];
    selectSegment.tintColor = [UIColor clearColor];
    NSDictionary *normal = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:TCRealValue(14)], NSFontAttributeName, nil];
    [selectSegment setTitleTextAttributes:normal forState:UIControlStateNormal];
    NSDictionary *select = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:TCRealValue(14)], NSFontAttributeName, nil];
    [selectSegment setTitleTextAttributes:normal forState:UIControlStateNormal];
    [selectSegment setTitleTextAttributes:select forState:UIControlStateSelected];
    selectSegment.selectedSegmentIndex = 0;
    [selectSegment addTarget:self action:@selector(touchSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    return selectSegment;
}

- (UILabel *)getLabelWithText:(NSString *)text AndOrigin:(CGPoint)point {
    UILabel *label = [TCComponent createLabelWithText:text AndFontSize:TCRealValue(11) AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    [label setOrigin:point];
    
    return label;
}

- (UIView *)getEvaluateViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    NSString *numberStr = @"3";
    int number = numberStr.intValue;
    for (int i = 0; i < number; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"good_collection_yes"]];
        [imgView setSize:CGSizeMake(TCRealValue(13), TCRealValue(13))];
        if (i == 0) {
            [imgView setOrigin:CGPointMake(0, 0)];
        } else {
            [imgView setOrigin:CGPointMake(i * TCRealValue(13) + i * TCRealValue(3), 0)];
        }
        [view addSubview:imgView];
    }
    return view;
}


- (UIButton *)createSelectImgButtonWithFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.layer.cornerRadius = frame.size.height / 2;
    button.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    return button;
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat height =  [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    [webView setSize:CGSizeMake(self.view.frame.size.width, height)];
    mScrollView.contentSize = CGSizeMake(self.view.width, webView.y + webView.height);
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *imageArr = mGoodDetail.pictures;
    return imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, mGoodDetail.pictures[indexPath.row]]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, collectionView.width, collectionView.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"home_image_place"]];
    imageView.backgroundColor = [UIColor whiteColor];
    
    [cell.contentView addSubview:imageView];
    return cell;
}

#pragma mark - TCGoodSelectViewDelegate
- (void)selectView:(TCGoodSelectView *)goodSelectView didAddShoppingCartWithGoodDetail:(TCGoodDetail *)goodDetail Amount:(NSInteger)amount {
    
        [[TCBuluoApi api] createShoppingCartWithAmount:amount goodsId:goodDetail.ID result:^(BOOL result, NSError *error) {
            if (result) {
                [MBProgressHUD showHUDWithMessage:@"加入购物车成功"];
            } else {
                TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
                if ([error isEqual:sessionError]) {
                    [MBProgressHUD showHUDWithMessage:@"请登录"];
                }
                [MBProgressHUD showHUDWithMessage:@"加入购物车失败"];
            }
        }];
    
}

- (void)selectView:(TCGoodSelectView *)goodSelectView didChangeStandardButtonWithGoodDetail:(TCGoodDetail *)goodDetail {
    [self reloadDetailViewWithTouchGoodDetail:goodDetail];
}


#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    int index = scrollView.contentOffset.x / self.view.width;
    imgPageControl.currentPage = index;
    
}

#pragma mark - click
- (void)touchBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)reloadDetailViewWithTouchGoodDetail:(TCGoodDetail *)goodDetail {
   
    mGoodDetail = goodDetail;
    [imageCollectionView reloadData];

//    [goodTitleView setupTitleWithText:goodDetail.title];
    titleViewHeight = goodTitleView.height;
    [goodTitleView setupTitleWithText:goodDetail.title];
    [goodTitleView setSalePriceWithPrice:goodDetail.salePrice];
    [goodTitleView setOriginPriceLabWithOriginPrice:goodDetail.originPrice];
    [goodTitleView setTagLabWithTagArr:goodDetail.tags];
    [self changeViewCoordinates];
    imgPageControl.numberOfPages = goodDetail.pictures.count;
    [self reloadWebViewWithUrlStr:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, goodDetail.detailURL]];
    
}

- (void)reloadWebViewWithUrlStr:(NSString *)urlStr {
    for (int i = 0; i < mScrollView.subviews.count; i++) {
        if ([mScrollView.subviews[i] isKindOfClass:[UISegmentedControl class]]) {
            UISegmentedControl *seg = mScrollView.subviews[i];
            textAndImageView = [self createURLInfoViewWithOrigin:CGPointMake(seg.x, seg.y + seg.height) AndURLStr:urlStr];
        }
    }
}


- (void)touchSegmentedControlAction: (UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    UIWebView *webView;
    if (index == 0) {
        webView = NULL;
        webView = [self createURLInfoViewWithOrigin:CGPointMake(0, seg.y + seg.height) AndURLStr:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, mGoodDetail.detailURL]];
    } else {
        webView = NULL;
        webView = [self createURLInfoViewWithOrigin:CGPointMake(0, seg.y + seg.height) AndURLStr:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, mGoodDetail.detailURL]];
    }
    UIScrollView *tempView = (UIScrollView *)[webView.subviews objectAtIndex:0];
    tempView.scrollEnabled = NO;
    [mScrollView addSubview:webView];


}


- (void)touchAddShopCartBtnInDetailView:(UIButton *) btn {
    TCBuluoApi *api = [TCBuluoApi api];
    [api fetchGoodStandards:mGoodDetail.standardId result:^(TCGoodStandards *result, NSError *error) {
        
        [self performSelectorOnMainThread:@selector(showStandardView:) withObject:result waitUntilDone:NO];
    }];
}


- (void)touchShopCarBtn:(id)sender {
    TCShoppingCartViewController *shoppingCartViewController = [[TCShoppingCartViewController alloc] init];
    [self.navigationController pushViewController:shoppingCartViewController animated:YES];
}

- (void)touchSelectStandardBtn:(UIButton *)btn {

    TCBuluoApi *api = [TCBuluoApi api];
    [api fetchGoodStandards:mGoodDetail.standardId result:^(TCGoodStandards *result, NSError *error) {
        
        [self performSelectorOnMainThread:@selector(showStandardView:) withObject:result waitUntilDone:NO];
    }];
    
}

- (void)showStandardView:(TCGoodStandards *)result {
    goodStandard = result;
    
    if (!goodSelectView.goodStandard) {
        [goodSelectView setupGoodStandard:goodStandard];
        
    }
    [goodSelectView show];
}


//- (void)touchAddShopCartBtn:(UIButton *)btn {
//    
//    [[TCBuluoApi api] createShoppingCartWithAmount:[standardView.numberLab.text  integerValue] goodsId:mGoodDetail.ID result:^(BOOL result, NSError *error) {
//        if (result) {
//            [MBProgressHUD showHUDWithMessage:@"加入购物车成功"];
//        } else {
//            TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
//            if ([error isEqual:sessionError]) {
//                [MBProgressHUD showHUDWithMessage:@"请登录"];
//            }
//            [MBProgressHUD showHUDWithMessage:@"加入购物车失败"];
//        }
//        [standardView endSelectStandard];
//    }];
//
//}
//


- (void)touchCollectionBtn:(id)sender {
    //    goodInfoDic
    
    
}

#pragma mark - other

- (void)changeViewCoordinates {
    NSArray *views = mScrollView.subviews;
    CGFloat changeHeight = 0;
    for (int i = 0; i < views.count; i++) {
        UIView *view = views[i];
        if (changeHeight != 0) {
            view.y += changeHeight;
        }
        if ([views[i] isEqual:goodTitleView]) {
            changeHeight = goodTitleView.height - titleViewHeight;
        }

    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

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
