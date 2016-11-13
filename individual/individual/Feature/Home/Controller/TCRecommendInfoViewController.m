//
//  TCRecommendInfoViewController.m
//  individual
//
//  Created by WYH on 16/11/12.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRecommendInfoViewController.h"

@interface TCRecommendInfoViewController () {
    NSDictionary *goodInfoDic;
    UIScrollView *mScrollView;
}

@end

@implementation TCRecommendInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [self initNavigationBar];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initGoodInfoData];
//    [self initNavigationBar];
    
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
    
    
}

- (void)initGoodInfoData {
    goodInfoDic = @{ @"title": @"Nike耐克2016新款多划算的还是动画设2计", @"price":@"465",
                     @"size":@[@"2"], @"logoImg":@"", @"brand":@"品牌", @"evaluate":@"3",
                     @"sales":@"18.6万", @"profit":@"65573", @"phone":@"732173", @"image_text":@"https://www.baidu.com/"
                     ,@"parameters":@"https://ssl.zc.qq.com/chs/", @"image":@[@"good_image", @"good_image", @"good_image", @"good_image"]
                     };
    
}

- (void)initScrollView {
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
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

//    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 23, 23)];
//    backBtn.layer.cornerRadius = 11.5;
//    backBtn.backgroundColor = [UIColor blackColor];
//    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
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
    
    NSArray *imageArr = goodInfoDic[@"image"];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.view.width, view.frame.size.height);
    layout.minimumLineSpacing = 0.0f;
    
    UICollectionView *imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, view.width, view.height) collectionViewLayout:layout];
    imageCollectionView.delegate = self;
    imageCollectionView.dataSource = self;
    imageCollectionView.pagingEnabled = YES;
    imageCollectionView.showsHorizontalScrollIndicator = NO;
    imageCollectionView.showsVerticalScrollIndicator = NO;
    [imageCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    imageCollectionView.contentSize = CGSizeMake(imageArr.count * view.width, view.height);
    imageCollectionView.contentOffset = CGPointMake(0, 0);
    [view addSubview:imageCollectionView];
    
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"good_image"]];
//    [view addSubview:imgView];
    
    
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
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"res_select_down"]];
    [imgView sizeToFit];
    [imgView setOrigin:CGPointMake(frame.size.width - 20 - imgView.width, frame.size.height / 2 - imgView.height / 2)];
    [button addSubview:imgView];
    
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
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageArr[indexPath.row]]];
    imageView.frame = CGRectMake(0, 0, collectionView.width, collectionView.height);
    [cell.contentView addSubview:imageView];
    return cell;
}

#pragma mark - click
- (void)touchBackButton {
    [self.navigationController popViewControllerAnimated:YES];
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
