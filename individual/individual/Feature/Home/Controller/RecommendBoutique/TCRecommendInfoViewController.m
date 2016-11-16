//
//  TCRecommendInfoViewController.m
//  individual
//
//  Created by WYH on 16/11/12.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRecommendInfoViewController.h"
#import "TCImgPageControl.h"

@interface TCRecommendInfoViewController () {
    NSDictionary *goodInfoDic;
    UIScrollView *mScrollView;
    TCImgPageControl *imgPageControl;
    TCStandardView *sizeView;
}

@end

@implementation TCRecommendInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [self initNavigationBar];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    [self initSelectSizeView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initGoodInfoData];
    
    [self initScrollView];
    
    UIView *titleImageView = [self createTitleImageViewWithFrame:CGRectMake(0, -64, self.view.width, 411)];
    [mScrollView addSubview:titleImageView];
    
    UIView *titleView = [self createTitleViewWithFrame:CGRectMake(0, titleImageView.y + titleImageView.height, self.view.width, 87)];
    [mScrollView addSubview:titleView];
    
    UIButton *sizeSelectBtn = [self createSizeSelectButtonWithFrame:CGRectMake(0, titleView.y + titleView.height + 7.5, self.view.width, 38)];
    [mScrollView addSubview:sizeSelectBtn];
    
    UIView *shopView = [self createShopInfoViewWithFrame:CGRectMake(0, sizeSelectBtn.y + sizeSelectBtn.height + 7.5, self.view.width, 64)];
    [mScrollView addSubview:shopView];
    
    UISegmentedControl *selectGoodInfoSegment = [self createSelectGoodInfoView:CGRectMake(0, shopView.y + shopView.height, self.view.width, 39)];
    [mScrollView addSubview:selectGoodInfoSegment];
    
    UIWebView *textAndImageView = [self createURLInfoViewWithOrigin:CGPointMake(0, selectGoodInfoSegment.y + selectGoodInfoSegment.height) AndURLStr:goodInfoDic[@"image_text"]];
    [mScrollView addSubview:textAndImageView];
    
    UIView *bottomView = [self createBottomViewWithFrame:CGRectMake(0, self.view.height - 49, self.view.width, 49)];
    [self.view addSubview:bottomView];

    
}

- (void)initSelectSizeView {
    sizeView = [[TCStandardView alloc] initWithData:goodInfoDic AndTarget:self AndStyleAction:@selector(touchStyleSelectBtn:) AndSizeAction:@selector(touchSizeSelectBtn:) AndCloseAction:@selector(touchColseSelectSize:) AndNumberAddAction:@selector(touchBuyNumberAddBtn:) AndNumberSubAction:@selector(touchBuyNumberSubBtn:) AndAddShoppingCartAction:@selector(touchAddShopCartBtn:) AndBuyAction:@selector(touchBuyBtn:)];
//    [self.view addSubview:sizeView];
    [[UIApplication sharedApplication].keyWindow addSubview:sizeView];
    
}


- (void)initGoodInfoData {
    NSURL *url = [NSURL URLWithString:@""];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            goodInfoDic = result[@""];
        }
    }];
    [dataTask resume];
    
    goodInfoDic = @{ @"title": @"Nike耐克2016新款多划算的还是动画设2计", @"price":@"465",
                     @"size":@[@"S", @"M", @"L", @"XL", @"XL", @"XL", @"XL", @"XL", @"XL", @"XL", @"XL", @"XL"], @"logoImg":@"", @"brand":@"品牌", @"evaluate":@"3",
                     @"sales":@"18.6万", @"profit":@"65573", @"phone":@"732173", @"image_text":@"https://www.baidu.com/"
                     ,@"parameters":@"https://ssl.zc.qq.com/chs/", @"image":@[@"good_image", @"good_image", @"good_image", @"good_image", @"null", @"null", @"null", @"null"],
                     @"style":@[ @{ @"title": @"套装", @"price": @"300", @"img":@"good_image" }
                             ,@{ @"title": @"鞋", @"price": @"50", @"img":@"null"}
                             ,@{ @"title": @"连衣裙", @"price": @"3100", @"img":@"restaurantInfoLogo"},
                                 @{ @"title": @"套装", @"price": @"300", @"img":@"good_image" },
                                 @{ @"title": @"套装", @"price": @"300", @"img":@"good_image" },
                                 @{ @"title": @"套装", @"price": @"300", @"img":@"good_image" },
                                 @{ @"title": @"套装", @"price": @"300", @"img":@"good_image" },
                                 @{ @"title": @"套装", @"price": @"300", @"img":@"good_image" }]
                     };
    
}

- (void)initScrollView {
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 49)];
    mScrollView.contentSize = CGSizeMake(self.view.width, 1500);
    mScrollView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.view addSubview:mScrollView];
}

- (void)initNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIImageView *barImageView = self.navigationController.navigationBar.subviews.firstObject;
    barImageView.backgroundColor = [UIColor whiteColor];
    barImageView.alpha = 0;

    UIButton *backBtn = [self getBackButton];
    [backBtn addTarget:self action:@selector(touchBackButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
}

- (UIButton *)getBackButton {
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 23, 23)];
    backBtn.layer.cornerRadius = 11.5;
    backBtn.backgroundColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    [imgView sizeToFit];
    [imgView setFrame:CGRectMake(backBtn.width / 2 - imgView.width * 0.8 / 2 - 1, backBtn.height / 2 - imgView.height * 0.8 / 2, imgView.width * 0.8, imgView.height * 0.8)];
//    [imgView setOrigin:CGPointMake(backBtn.width / 2 - imgView.width / 2 - 3, backBtn.height / 2 - imgView.height / 2)];
    [backBtn addSubview:imgView];

    return backBtn;
}

#pragma mark - Main UI

- (UIView *)createTitleImageViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UICollectionView *imageCollectionView = [self getTitleImageViewWithFrame:frame];
    
    [view addSubview:imageCollectionView];
    
    NSArray *imgArr = goodInfoDic[@"image"];
    imgPageControl = [[TCImgPageControl alloc] initWithFrame:CGRectMake(0, view.height - 20, self.view.width, 20)];
    imgPageControl.numberOfPages = imgArr.count;
    imgPageControl.userInteractionEnabled = NO;
    imgPageControl.currentPage = 0;
    [view addSubview:imgPageControl];
    
    return view;
}

- (UIView *)createTitleViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];

    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(20, 15, frame.size.width - 40, 16) AndFontSize:16 AndTitle:goodInfoDic[@"title"] AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
    [view addSubview:titleLab];
    
    NSString *priceStr = [NSString stringWithFormat:@"￥%@", goodInfoDic[@"price"]];
    UILabel *priceLab = [TCComponent createLabelWithFrame:CGRectMake(20, titleLab.y + titleLab.height + 18, titleLab.width, 17) AndFontSize:17 AndTitle:priceStr AndTextColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1]];
    [view addSubview:priceLab];
    
    return view;
}

- (UIButton *)createSizeSelectButtonWithFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    UILabel *selectLab = [TCComponent createLabelWithFrame:CGRectMake(20, 0, frame.size.width - 20, frame.size.height) AndFontSize:15 AndTitle:@"请选择规格"];
    [button addSubview:selectLab];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_select_standard"]];
    [imgView sizeToFit];
    [imgView setOrigin:CGPointMake(frame.size.width - 20 - imgView.width, frame.size.height / 2 - imgView.height / 2)];
    [button addSubview:imgView];
    
    [button addTarget:self action:@selector(touchSelectSizeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIView *)createShopInfoViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 48, 48)];
//    goodInfoDic[@"logoImg"]
    logoImgView.image = [UIImage imageNamed:@"good_logo"];
    [view addSubview:logoImgView];
    
    NSString *brandStr = [NSString stringWithFormat:@"品牌 : %@", goodInfoDic[@"brand"]];
    UILabel *brandLab = [TCComponent createLabelWithFrame:CGRectMake(logoImgView.x + logoImgView.width + 12, 8, frame.size.width - logoImgView.x + logoImgView.width + 12, 14) AndFontSize:14 AndTitle:brandStr AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
    brandLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [view addSubview:brandLab];
    
    UIView *evaluateView = [self getEvaluateViewWithFrame:CGRectMake(brandLab.x, brandLab.y + brandLab.height + 4, brandLab.width, 13)];
    [view addSubview:evaluateView];
    
    NSString *salesStr = [NSString stringWithFormat:@"总销量 : %@", goodInfoDic[@"sales"]];
    UILabel *salesLab = [self getLabelWithText:salesStr AndOrigin:CGPointMake(brandLab.x, evaluateView.y + evaluateView.height + 5)];
    [view addSubview:salesLab];
    
    NSString *profitStr = [NSString stringWithFormat:@"收益数 : %@", goodInfoDic[@"profit"]];
    UILabel *profitLab = [self getLabelWithText:profitStr AndOrigin:CGPointMake(salesLab.x + salesLab.width + 15, salesLab.y)];
    [view addSubview:profitLab];

    return view;
}

- (UIView *)createBottomViewWithFrame:(CGRect)frame {
    UIView *view=  [[UIView alloc] initWithFrame:frame];
    
    UIButton *collectionBtn = [TCComponent createImageBtnWithFrame:CGRectMake(0, 0, frame.size.width / 4, frame.size.height) AndImageName:@"good_collection_blue"];
    [collectionBtn addTarget:self action:@selector(touchCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:collectionBtn];
    
    UIButton *shopCarImgBtn = [TCComponent createImageBtnWithFrame:CGRectMake(collectionBtn.x + collectionBtn.width, 0, collectionBtn.width, collectionBtn.height) AndImageName:@"good_shoppingcar_blue"];
    [shopCarImgBtn addTarget:self action:@selector(touchShopCarBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shopCarImgBtn];
    
    UIButton *shopCarBtn = [TCComponent createButtonWithFrame:CGRectMake(shopCarImgBtn.x + shopCarImgBtn.width, 0, frame.size.width / 2, frame.size.height) AndTitle:@"加入购物车" AndFontSize:18];
    shopCarBtn.backgroundColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    [shopCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:shopCarBtn];
    
    return view;
}

- (UISegmentedControl *)createSelectGoodInfoView:(CGRect)frame {
    
    UISegmentedControl *selectSegment = [self getSegmentControlWithFrame:frame];
    
    UIView *topLine = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, frame.size.width, 1)];
    UIView *downLine = [TCComponent createGrayLineWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
    [selectSegment addSubview:topLine];
    [selectSegment addSubview:downLine];
    
    UIView *centerLine = [TCComponent createGrayLineWithFrame:CGRectMake(frame.size.width / 2 - 0.25, frame.size.height / 2 - 13, 0.5, 26)];
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

    return webView;
}



#pragma mark - Component UI

- (UICollectionView *)getTitleImageViewWithFrame:(CGRect)frame {
    NSArray *imageArr = goodInfoDic[@"image"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.width, frame.size.height);
    layout.minimumLineSpacing = 0.0f;
    
    UICollectionView *imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
    imageCollectionView.delegate = self;
    imageCollectionView.dataSource = self;
    imageCollectionView.pagingEnabled = YES;
    imageCollectionView.showsHorizontalScrollIndicator = NO;
    imageCollectionView.showsVerticalScrollIndicator = NO;
    [imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    imageCollectionView.contentSize = CGSizeMake(imageArr.count * frame.size.width, frame.size.height);
    imageCollectionView.contentOffset = CGPointMake(0, 0);

    return imageCollectionView;
}

- (UISegmentedControl *)getSegmentControlWithFrame:(CGRect)frame {
    NSArray *segmentArr = @[ @"图文详情", @"产品参数" ];
    UISegmentedControl *selectSegment = [[UISegmentedControl alloc] initWithItems:segmentArr];
    [selectSegment setFrame:frame];
    selectSegment.tintColor = [UIColor clearColor];
    NSDictionary *normal = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:14], NSFontAttributeName, nil];
    [selectSegment setTitleTextAttributes:normal forState:UIControlStateNormal];
    NSDictionary *select = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:14], NSFontAttributeName, nil];
    [selectSegment setTitleTextAttributes:normal forState:UIControlStateNormal];
    [selectSegment setTitleTextAttributes:select forState:UIControlStateSelected];
    selectSegment.selectedSegmentIndex = 0;
    [selectSegment addTarget:self action:@selector(touchSegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    return selectSegment;
}

- (UILabel *)getLabelWithText:(NSString *)text AndOrigin:(CGPoint)point {
    UILabel *label = [TCComponent createLabelWithText:text AndFontSize:11 AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    [label setOrigin:point];
    
    return label;
}

- (UIView *)getEvaluateViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    NSString *numberStr = goodInfoDic[@"evaluate"];
    int number = numberStr.intValue;
    for (int i = 0; i < number; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"good_collection_yes"]];
        [imgView setSize:CGSizeMake(13, 13)];
        if (i == 0) {
            [imgView setOrigin:CGPointMake(0, 0)];
        } else {
            [imgView setOrigin:CGPointMake(i * 13 + i * 3, 0)];
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
    NSInteger height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] intValue];
    [webView setSize:CGSizeMake(self.view.frame.size.width, height)];
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *imageArr = goodInfoDic[@"image"];
    return imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    NSArray *imageArr = goodInfoDic[@"image"];
//    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageArr[indexPath.row]]];
//    UIImageView *imageView = [[UIImageView alloc]initWithImage:img];

    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageArr[indexPath.row]]];
    imageView.frame = CGRectMake(0, 0, collectionView.width, collectionView.height);
    [cell.contentView addSubview:imageView];
    return cell;
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

- (void)touchColseSelectSize:(UIButton *)btn {
    [sizeView endSelectStandard];
}

- (void)touchBuyNumberAddBtn:(UIButton *)btn {
    int number = sizeView.numberLab.text.intValue;
    NSString *inventorStr = [[sizeView.inventoryLab.text componentsSeparatedByString:@":"][1] componentsSeparatedByString:@"件"][0];
    
    int inventorNumber = inventorStr.intValue;
    if (number >= inventorNumber) {
        
    } else if (number == 9999) {
        
    }
    else {
        sizeView.numberLab.text = [NSString stringWithFormat:@"%i", number+1];
    }

    
}

- (void)touchBuyNumberSubBtn:(UIButton *)btn {
    int number = sizeView.numberLab.text.intValue;
    if (number <= 1) {
        
    } else {
        sizeView.numberLab.text = [NSString stringWithFormat:@"%i", number-1];
    }
    
}


- (void)touchStyleSelectBtn:(UIButton *)btn {
    [self changeSizeButtonWithBtn:btn];
    NSDictionary *styleInfo = goodInfoDic[@"style"][btn.tag];
    UIImage *selectImg = [UIImage imageNamed:styleInfo[@"img"]];
    sizeView.selectedImgView.image = selectImg;
    sizeView.priceLab.text = styleInfo[@"price"];
    [sizeView setGoodStyle:styleInfo[@"title"]];
    [sizeView modifyInventoryLabel];
    sizeView.numberLab.text = @"1";
}

- (void)touchSizeSelectBtn:(UIButton *)btn {
    [self changeSizeButtonWithBtn:btn];
    [sizeView setGoodSize:goodInfoDic[@"size"][btn.tag]];
    [sizeView modifyInventoryLabel];
}

- (void)touchSegmentedControlAction: (UISegmentedControl *)seg {
    NSInteger index = seg.selectedSegmentIndex;
    UIWebView *webView;
    if (index == 0) {
        webView = NULL;
        webView = [self createURLInfoViewWithOrigin:CGPointMake(0, seg.y + seg.height) AndURLStr:goodInfoDic[@"image_text"]];
    } else {
        webView = NULL;
        webView = [self createURLInfoViewWithOrigin:CGPointMake(0, seg.y + seg.height) AndURLStr:goodInfoDic[@"parameters"]];
    }
    [mScrollView addSubview:webView];


}


- (void)touchShopCarBtn:(id)sender {
//    goodInfoDic    
    
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

}

- (void)touchSelectSizeBtn:(UIButton *)btn {
    [sizeView startSelectStandard];
}

- (void)touchAddShopCartBtn:(UIButton *)btn {
    //    NSString *selectStyle = sizeView.selectedGoodSizeLab.text;
    //    NSString *selectSize = sizeView.selectedGoodSizeLab.text;
    //    NSString *number = sizeView.numberLab.text;
    //    NSString *price = sizeView.priceLab.text;
}

- (void)touchBuyBtn:(UIButton *)btn {
    //    NSString *selectStyle = sizeView.selectedGoodSizeLab.text;
    //    NSString *selectSize = sizeView.selectedGoodSizeLab.text;
    //    NSString *number = sizeView.numberLab.text;
    //    NSString *price = sizeView.priceLab.text;
    
}



- (void)touchCollectionBtn:(id)sender {
    //    goodInfoDic
    
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

}

#pragma mark - other
- (void)changeSizeButtonWithBtn:(UIButton *)btn {
    btn.layer.borderColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1].CGColor;
    [btn setTitleColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] forState:UIControlStateNormal];
    
    NSInteger tag = btn.tag;
    NSArray *subviews = btn.superview.subviews;
    for (int i = 0; i < subviews.count; i++) {
        if (i != tag && [subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *btn = subviews[i];
            btn.layer.borderColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1].CGColor;
            [btn setTitleColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }

}


- (void)viewWillDisappear:(BOOL)animated {

    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    UIImageView *barImageView = self.navigationController.navigationBar.subviews.firstObject;
    barImageView.backgroundColor =[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    barImageView.alpha = 1;
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
