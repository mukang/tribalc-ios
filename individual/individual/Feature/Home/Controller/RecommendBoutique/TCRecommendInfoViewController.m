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
    TCGoodDetail *mGoodDetail;
    UIScrollView *mScrollView;
    TCImgPageControl *imgPageControl;
    TCGoodStandards *goodStandard;
    TCStandardView *standardView;
    NSString *mGoodId;
    UICollectionView *imageCollectionView;
    
    TCGoodTitleView *goodTitleView;
    
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
    
    [self initNavigationBar];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self initGoodDetailInfoWithGoodId:mGoodId];
    
    
}

- (void)initGoodDetailInfoWithGoodId:(NSString *)goodId {
    TCBuluoApi *buluoApi = [TCBuluoApi api];
    [buluoApi fetchGoodDetail:goodId result:^(TCGoodDetail *goodDetail, NSError *error) {
        mGoodDetail = goodDetail;
        
        [self initScrollView];
        [self initUI];
        [self initSelectSizeView];
    }];
}

- (void)initUI {
    UIView *titleImageView = [self createTitleImageViewWithFrame:CGRectMake(0, 0, self.view.width, 394)];
    [mScrollView addSubview:titleImageView];
    
    goodTitleView = [[TCGoodTitleView alloc] initWithFrame:CGRectMake(0, titleImageView.y + titleImageView.height, self.view.width, 87) WithTitle:mGoodDetail.title AndPrice:mGoodDetail.salePrice AndOriginPrice:mGoodDetail.originPrice AndTags:mGoodDetail.tags];
    [mScrollView addSubview:goodTitleView];
    
    UIButton *sizeSelectBtn = [self createSizeSelectButtonWithFrame:CGRectMake(0, goodTitleView.y + goodTitleView.height + 7.5, self.view.width, 38)];
    [mScrollView addSubview:sizeSelectBtn];
    
    UIView *shopView = [self createShopInfoViewWithFrame:CGRectMake(0, sizeSelectBtn.y + sizeSelectBtn.height + 7.5, self.view.width, 64)];
    [mScrollView addSubview:shopView];
    
    UISegmentedControl *selectGoodInfoSegment = [self createSelectGoodInfoView:CGRectMake(0, shopView.y + shopView.height, self.view.width, 39)];
    [mScrollView addSubview:selectGoodInfoSegment];
    
    NSString *webUrlStr = [NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, mGoodDetail.detailURL];
    UIWebView *textAndImageView = [self createURLInfoViewWithOrigin:CGPointMake(0, selectGoodInfoSegment.y + selectGoodInfoSegment.height) AndURLStr:webUrlStr];
    UIScrollView *tempView = (UIScrollView *)[textAndImageView.subviews objectAtIndex:0];
    tempView.scrollEnabled = NO;
    [mScrollView addSubview:textAndImageView];
    
    UIView *bottomView = [self createBottomViewWithFrame:CGRectMake(0, self.view.height - 49, self.view.width, 49)];
    [self.view addSubview:bottomView];

}




- (void)initSelectSizeView {

    standardView = [[TCStandardView alloc] initWithTarget:self AndNumberAddAction:@selector(touchBuyNumberAddBtn:) AndNumberSubAction:@selector(touchBuyNumberSubBtn:) AndAddShopCarAction:@selector(touchAddShopCartBtn:) AndGoCartAction:@selector(touchBuyBtn:) AndBuyAction:@selector(touchBuyBtn:) AndCloseAction:@selector(touchCloseBtn)];
    [standardView setSalePriceAndInventoryWithSalePrice:mGoodDetail.salePrice AndInventory:mGoodDetail.repertory AndImgUrlStr:mGoodDetail.thumbnail];
    [self.view addSubview:standardView];
    [[UIApplication sharedApplication].keyWindow addSubview:standardView];
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
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
    backBtn.layer.cornerRadius = 15;
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

    UILabel *titleLab = [self createTitleLabelWithText:mGoodDetail.title WithFrame:CGRectMake(20, 15, frame.size.width - 40, 16)];
    [view addSubview:titleLab];
    
    UIView *priceView = [self createPriceLabelWithOrigin:CGPointMake(20, titleLab.y + titleLab.height + 20)];
    [view addSubview:priceView];
    
    UILabel *originPriceLab = [self createOriginPriceLabelWithFrame:CGRectMake(priceView.x + priceView.width + 18, priceView.y + 5, 0, 17 - 5)];
    [view addSubview:originPriceLab];

    [view setHeight:(priceView.y + priceView.height + 20)];
    
    UILabel *tagLab = [self createTagLabel];
    [tagLab setOrigin:CGPointMake(self.view.width - 20 - tagLab.width, priceView.y)];
    [view addSubview:tagLab];

    
    return view;
}


- (UIView *)createPriceLabelWithOrigin:(CGPoint)point {
    
    UIView *view = [[UIView alloc] init];
    [view setOrigin:point];
    
    NSString *priceIntegerStr = [NSString stringWithFormat:@"￥%i", (int)mGoodDetail.salePrice];
    UILabel *priceIntegerLabel = [self createPriceLabelWithOrigin:CGPointMake(0, 0) AndFontSize:17 AndText:priceIntegerStr];
    [view addSubview:priceIntegerLabel];
    
    UILabel *priceDecimalLabel;
    if ([[self changeFloat:mGoodDetail.salePrice] rangeOfString:@"."].location != NSNotFound) {
        NSString *priceDecimalStr = [[self changeFloat:mGoodDetail.salePrice] componentsSeparatedByString:@"."][1];
        priceDecimalStr = [NSString stringWithFormat:@".%@", priceDecimalStr];
        priceDecimalLabel = [self createPriceLabelWithOrigin:CGPointMake(priceIntegerLabel.x + priceIntegerLabel.width, priceIntegerLabel.y + 17 - 12) AndFontSize:12 AndText:priceDecimalStr];
        [view addSubview:priceDecimalLabel];
    }
    
    [view setSize:CGSizeMake(priceIntegerLabel.width + priceDecimalLabel.width , 17)];
    
    return view;
}

- (UILabel *)createPriceLabelWithOrigin:(CGPoint)point AndFontSize:(float)fontSize AndText:(NSString *)text {
    UILabel *label = [TCComponent createLabelWithText:text AndFontSize:fontSize];
    label.origin = point;
    label.font = [UIFont fontWithName:BOLD_FONT size:fontSize];
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}

- (UILabel *)createOriginPriceLabelWithFrame:(CGRect)frame {
    NSString *originalPriceStr = [NSString stringWithFormat:@"￥%@", [self changeFloat:mGoodDetail.originPrice]];
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:originalPriceStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:frame.size.height], NSForegroundColorAttributeName:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1], NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle|NSUnderlinePatternSolid), NSStrikethroughColorAttributeName:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1]}];
    ;
    label.attributedText = attrStr;
    [label sizeToFit];
    
    return label;
}


- (UILabel *)createTagLabel {
    NSArray *tagArr = mGoodDetail.tags;
    NSString *tagStr = tagArr[0];
    for (int i = 1; i < tagArr.count; i++) {
        tagStr = [NSString stringWithFormat:@"%@/%@", tagStr, tagArr[i]];
    }
    UILabel *label = [TCComponent createLabelWithText:tagStr AndFontSize:11];
    label.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    [label setHeight:17];
    return label;
}

- (UILabel *)createTitleLabelWithText:(NSString *)text WithFrame:(CGRect)frame{
    CGSize labelSize = {0, 0};
    labelSize = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    UILabel *label =  [TCComponent createLabelWithFrame:frame AndFontSize:16 AndTitle:mGoodDetail.title AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
    label.text = text;
    label.numberOfLines = 2;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 7.0f;
    NSRange range = NSMakeRange(0, text.length);
    
    NSLog(@"%@", text);
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text];
    [textAttr addAttribute:NSParagraphStyleAttributeName value:style range:range];
    label.attributedText = textAttr;
    
    if (labelSize.width > label.width) {
        [label setHeight:2 * label.height + 17];
    }
    [label sizeToFit];

    label.lineBreakMode = NSLineBreakByCharWrapping;
    
    return label;
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
    
    [button addTarget:self action:@selector(touchSelectStandardBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIView *)createShopInfoViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 8, 48, 48)];
    [logoImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, mGoodDetail.thumbnail]]];
    [view addSubview:logoImgView];
    
    NSString *brandStr = [NSString stringWithFormat:@"品牌 : %@", mGoodDetail.brand];
    UILabel *brandLab = [TCComponent createLabelWithFrame:CGRectMake(logoImgView.x + logoImgView.width + 12, 8, frame.size.width - logoImgView.x + logoImgView.width + 12, 14) AndFontSize:14 AndTitle:brandStr AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
    brandLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [view addSubview:brandLab];
    
    UIView *evaluateView = [self getEvaluateViewWithFrame:CGRectMake(brandLab.x, brandLab.y + brandLab.height + 4, brandLab.width, 13)];
    [view addSubview:evaluateView];
    
    NSString *salesStr = [NSString stringWithFormat:@"总销量 : %li", (long)mGoodDetail.saleQuantity];
    UILabel *salesLab = [self getLabelWithText:salesStr AndOrigin:CGPointMake(brandLab.x, evaluateView.y + evaluateView.height + 5)];
    [view addSubview:salesLab];
    
    NSString *profitStr = [NSString stringWithFormat:@"电话 : %@",  @"65573"];
    UILabel *profitLab = [self getLabelWithText:profitStr AndOrigin:CGPointMake(salesLab.x + salesLab.width + 15, salesLab.y)];
    [view addSubview:profitLab];

    return view;
}

- (UIView *)createBottomViewWithFrame:(CGRect)frame {
    UIView *view=  [[UIView alloc] initWithFrame:frame];
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
    [view addSubview:lineView];
    
    UIButton *collectionView = [self createCollectionAndShopViewWithFrame:CGRectMake(0, 0, frame.size.width / 4, frame.size.height) AndImageName:@"good_collection_gray" AndText:@"收藏" AndAction:@selector(touchCollectionBtn:)];
    [view addSubview:collectionView];
    
    UIButton *shopCarImgBtn = [self createCollectionAndShopViewWithFrame:CGRectMake(collectionView.width, 0, frame.size.width / 4, frame.size.height) AndImageName:@"good_shoppingcar_gray" AndText:@"购物车" AndAction:@selector(touchShopCarBtn:)];
    [view addSubview:shopCarImgBtn];
    
    
    UIButton *shopCarBtn = [TCComponent createButtonWithFrame:CGRectMake(shopCarImgBtn.x + shopCarImgBtn.width, 0, frame.size.width / 2, frame.size.height) AndTitle:@"加入购物车" AndFontSize:18];
    shopCarBtn.backgroundColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    [shopCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:shopCarBtn];
    
    return view;
}

- (UIButton *)createCollectionAndShopViewWithFrame:(CGRect)frame AndImageName:(NSString *)imageName AndText:(NSString *)text AndAction:(SEL)action{
    UIButton *view = [[UIButton alloc] initWithFrame:frame];
    
    UIImage *img = [UIImage imageNamed:imageName];
    UIButton *button = [TCComponent createButtonWithFrame:CGRectMake((frame.size.width - img.size.width) / 2, 10, img.size.width, img.size.height) AndTitle:@"" AndFontSize:0];
    [button setImage:img forState:UIControlStateNormal];
    [view addSubview:button];
    
    UILabel *label = [TCComponent createLabelWithFrame:CGRectMake(0, button.y + button.height + 3, frame.size.width, 12) AndFontSize:12 AndTitle:text AndTextColor:[UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1]];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    [view addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

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
    NSString *numberStr = @"3";
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
    [imageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"home_image_place"]];
    imageView.backgroundColor = [UIColor whiteColor];
    
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

- (void)touchCloseBtn {
    [standardView endSelectStandard];
}

//- (void)touchColseSelectSize:(UIButton *)btn {
//    [sizeView endSelectStandard];
//}
//
- (void)touchBuyNumberAddBtn:(UIButton *)btn {
    int number = standardView.numberLab.text.intValue;
    NSString *inventorStr = [[standardView.inventoryLab.text componentsSeparatedByString:@":"][1] componentsSeparatedByString:@"件"][0];
    
    int inventorNumber = inventorStr.intValue;
    if (number >= inventorNumber) {
        
    } else if (number == 9999) {
        
    }
    else {
        standardView.numberLab.text = [NSString stringWithFormat:@"%i", number+1];
    }

    
}
//
- (void)touchBuyNumberSubBtn:(UIButton *)btn {
    int number = standardView.numberLab.text.intValue;
    if (number <= 1) {
        
    } else {
        standardView.numberLab.text = [NSString stringWithFormat:@"%i", number-1];
    }
    
}


- (void)touchStyleSelectBtn:(UIButton *)btn {
    
    if ([standardView.selectedGoodStyleLab.text isEqualToString:@""]) {
        [self changeStyleButtonWithBtn:btn];
        standardView.selectedGoodStyleLab.text = goodStandard.descriptions[@"primary"][@"types"][btn.tag];
    } else {
        NSString *styleInfo = goodStandard.descriptions[@"primary"][@"types"][btn.tag];
        NSString *standardKey = [NSString stringWithFormat:@"%@^%@", styleInfo, standardView.selectedGoodSizeLab.text];
        TCGoodDetail *selectStandardGoodDetail = [[TCGoodDetail alloc] initWithObjectDictionary:goodStandard.goodsIndexes[standardKey]];
        if (selectStandardGoodDetail == NULL) {
            
        } else {
            [self changeStyleButtonWithBtn:btn];
            [self reloadDetailViewWithTouchGoodDetail:selectStandardGoodDetail];
            [standardView setGoodStyle:styleInfo];
        }
        
    }

}

- (void)reloadDetailViewWithTouchGoodDetail:(TCGoodDetail *)goodDetail {
   
    mGoodDetail = goodDetail;
    [imageCollectionView reloadData];

    [standardView setSalePriceAndInventoryWithSalePrice:goodDetail.salePrice AndInventory:goodDetail.repertory AndImgUrlStr:goodDetail.thumbnail];
    goodTitleView.titleLab.text = goodDetail.title;
    [goodTitleView setSalePriceWithPrice:goodDetail.salePrice];
    [goodTitleView setOriginPriceLabWithOriginPrice:goodDetail.originPrice];
    [goodTitleView setTagLabWithTagArr:goodDetail.tags];
    imgPageControl.numberOfPages = goodDetail.pictures.count;
}

- (void)touchSizeSelectBtn:(UIButton *)btn {
    
    if ([standardView.selectedGoodSizeLab.text isEqualToString:@""]) {
        [self changeSizeButtonWithBtn:btn];
        standardView.selectedGoodSizeLab.text = goodStandard.descriptions[@"secondary"][@"types"][btn.tag];
    } else {
        NSString *sizeInfo = goodStandard.descriptions[@"secondary"][@"types"][btn.tag];
        NSString *standardKey = [NSString stringWithFormat:@"%@^%@", standardView.selectedGoodStyleLab.text, sizeInfo];
        TCGoodDetail *selectStandardGoodDetail = [[TCGoodDetail alloc] initWithObjectDictionary:goodStandard.goodsIndexes[standardKey]];
        if (selectStandardGoodDetail == NULL) {
            
        } else {
            [self changeSizeButtonWithBtn:btn];
            [standardView setGoodSize:sizeInfo];
            [self reloadDetailViewWithTouchGoodDetail:selectStandardGoodDetail];
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


- (void)touchShopCarBtn:(id)sender {
    
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

- (void)touchSelectStandardBtn:(UIButton *)btn {
//    [sizeView startSelectStandard];
    TCBuluoApi *api = [TCBuluoApi api];
    [api fetchGoodStandards:mGoodDetail.standardId result:^(TCGoodStandards *result, NSError *error) {
        goodStandard = result;
        NSLog(@"%@", goodStandard.goodsIndexes);
        [standardView setStandardSelectViewWithStandard:goodStandard AndPrimaryAction:@selector(touchStyleSelectBtn:) AndSeconedAction:@selector(touchSizeSelectBtn:) AndTarget:self];
        [standardView startSelectStandard];
    }];
    
}

- (void)initSizeViewSelectedBtnWithStandard:(TCGoodStandards *)standard {
    if (mGoodDetail.snapshot == false) {
//        if ()
        
    }
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
- (void)changeStyleButtonWithBtn:(UIButton *)btn {
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

- (void)changeSizeButtonWithBtn:(UIButton *)btn {

    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:82/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    
    NSInteger tag = btn.tag;
    NSArray *subviews = btn.superview.subviews;
    for (int i = 0; i < subviews.count; i++) {
        if (i != tag && [subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *btn = subviews[i];
            [btn setTitleColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1] forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
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

-(NSString *)changeFloat:(double)flo
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
