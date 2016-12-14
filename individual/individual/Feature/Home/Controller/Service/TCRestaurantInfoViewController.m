//
//  TCResaurantInfoViewController.m
//  individual
//
//  Created by chen on 16/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantInfoViewController.h"

@interface TCRestaurantInfoViewController () {
    UIImageView *restaurantInfoLogoImageView;
    TCRestaurantLogoView *logoView;
    UIImageView *barImageView;

    UIView *baseInfoView;
    
    TCServiceDetail *serviceDetail;
    NSString *statusColorStr;
    
    NSString *mServiceId;
    
    BOOL isCollection;
}

@end

@implementation TCRestaurantInfoViewController


- (instancetype)initWithServiceId:(NSString *)serviceId {
    self = [super init];
    if (self) {
        mServiceId = serviceId;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    statusColorStr = @"white";
    mScrollView.delegate = self;
    
    [self initNavigationBar];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self initNavigationBar];
    
    [self initServiceDetail];
    
    isCollection = NO;
    
}

- (void)initServiceDetail {
    TCBuluoApi *api = [TCBuluoApi api];
    [api fetchServiceDetail:mServiceId result:^(TCServiceDetail *service, NSError *error) {
        serviceDetail = service;
        [self initUI];
    }];
}


- (void)initUI {
    
    [self initBaseData];
    
    [self createBottomButton];
    
    
    baseInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, restaurantInfoLogoImageView.y + restaurantInfoLogoImageView.height + 35, TCScreenWidth, 0)];
    baseInfoView.backgroundColor =  [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    UIView *resBaseInfoView = [self createResBaseInfoViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 125)];
    resBaseInfoView.backgroundColor = [UIColor whiteColor];
    [baseInfoView addSubview:resBaseInfoView];
    
    UIView *addressAndPhoneView = [self createAddressAndPhoneViewWithFrame:CGRectMake(0, resBaseInfoView.y + resBaseInfoView.height, self.view.width, 82)];
    [baseInfoView addSubview:addressAndPhoneView];
    
    UIView *recommendedReasonView = [self createTextViewWithFrame:CGRectMake(0, addressAndPhoneView.y + addressAndPhoneView.height, self.view.width, 175) AndTitle:@"推荐理由" AndText:serviceDetail.recommendedReason AndimgName:@"res_recommend"];
    [baseInfoView addSubview:recommendedReasonView];
    
    UIView *restTopicView = [self createTextViewWithFrame:CGRectMake(0, recommendedReasonView.y + recommendedReasonView.height, self.view.width, 175) AndTitle:@"餐厅话题" AndText:serviceDetail.topics AndimgName:@"res_topic"];
    [baseInfoView addSubview:restTopicView];
    
    
    UIView *promptView = [self createPromptViewWithFrame:CGRectMake(0, restTopicView.y + restTopicView.height, self.view.frame.size.width, 145)];
    [baseInfoView addSubview:promptView];
    
    UIButton *phoneBtn = [self createPhoneCustomViewWithFrame:CGRectMake(0, promptView.y + promptView.height + 7, self.view.frame.size.width, 45)];
    [phoneBtn addTarget:self action:@selector(touchCallCustomerService) forControlEvents:UIControlEventTouchUpInside];
    [baseInfoView addSubview:phoneBtn];
    baseInfoView.height = phoneBtn.y + phoneBtn.height + 8;
    [mScrollView addSubview:baseInfoView];
    
    mScrollView.contentSize = CGSizeMake(self.view.width, baseInfoView.y + baseInfoView.height);
    

}

- (void)initialNavLeftBarWithImgName:(NSString *)leftName AndRightBarImgName:(NSString *)rightName {
    UIButton *leftBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:leftName];
    [leftBtn addTarget:self action:@selector(touchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIButton *rightBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 20, 17) AndImageName:rightName];
    [rightBtn addTarget:self action:@selector(touchCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

}

- (void)initNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    barImageView = self.navigationController.navigationBar.subviews.firstObject;
    barImageView.backgroundColor = [UIColor whiteColor];
    barImageView.alpha = 0;

    [self initialNavLeftBarWithImgName:@"back" AndRightBarImgName:[self getCollectionImageName]];
    
}



- (void)initBaseData {
    
    mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 45)];
    
    [self.view addSubview:mScrollView];
    
    NSURL *logoImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, serviceDetail.mainPicture]];
    
    restaurantInfoLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 270)];
    [restaurantInfoLogoImageView sd_setImageWithURL:logoImageUrl placeholderImage:[UIImage imageNamed:@"home_image_place"]];
    restaurantInfoLogoImageView.clipsToBounds = NO;
    
    float logoViewRadius = restaurantInfoLogoImageView.frame.size.height * 0.12;
    logoView = [[TCRestaurantLogoView alloc] initWithFrame:CGRectMake(restaurantInfoLogoImageView.width / 2 - logoViewRadius, restaurantInfoLogoImageView.height - logoViewRadius, logoViewRadius * 2, logoViewRadius * 2) AndUrlStr:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, serviceDetail.detailStore.logo]];
    [restaurantInfoLogoImageView addSubview:logoView];
    [restaurantInfoLogoImageView bringSubviewToFront:mScrollView];
    
    mScrollView.backgroundColor = [UIColor whiteColor];
    mScrollView.delegate = self;
    
    [mScrollView addSubview:restaurantInfoLogoImageView];
    
}


- (UIView *)createResBaseInfoViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *titleLab = [TCComponent createCenterLabWithFrame:CGRectMake(0, 22.5, frame.size.width, 22.5) AndFontSize:22.5 AndTitle:serviceDetail.name];
    [view addSubview:titleLab];
    
    UIView *typeAndAdressView = [self getRestTypeAndAddressInfoWithFrame:CGRectMake(0, titleLab.y + titleLab.height + 16, frame.size.width, 14)];
    [view addSubview:typeAndAdressView];

    UIView *priceView = [self createPriceViewWithFrame:CGRectMake(0, typeAndAdressView.y + typeAndAdressView.height + 14, frame.size.width / 2 - 20, 15)];
    [view addSubview:priceView];
    
    UIView *collectionView = [self getCollectionViewWithFrame:CGRectMake(frame.size.width / 2, priceView.y + 4, frame.size.width / 2, 11) AndNumber:serviceDetail.collectionNum];
    [view addSubview:collectionView];
    
    return view;
}

- (UIView *)createPriceViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UILabel *unitLabel = [TCComponent createLabelWithFrame:CGRectMake(frame.size.width - 28, frame.size.height - 11, 28, 12) AndFontSize:11 AndTitle:@"元/人" AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    [view addSubview:unitLabel];

    NSString *priceStr = [NSString stringWithFormat:@"%f", serviceDetail.personExpense];
    priceStr = [NSString stringWithFormat:@"%@", @(priceStr.floatValue)];
    UILabel *priceLabel = [TCComponent createLabelWithFrame:CGRectMake(0, 0, view.width - 28, frame.size.height) AndFontSize:frame.size.height AndTitle:priceStr AndTextColor:[UIColor blackColor]];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:priceLabel];
    
    return view;
}

- (UIView *)createAddressAndPhoneViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UIView *topLine = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, frame.size.width - 40, 0.5)];
    UIView *downLine = [TCComponent createGrayLineWithFrame:CGRectMake(20, frame.size.height - 0.5, topLine.width, 0.5)];
    [view addSubview:topLine];
    [view addSubview:downLine];
    
    TCDetailStore *storeDetail = serviceDetail.detailStore;
    UILabel *addressLab = [TCComponent createLabelWithFrame:CGRectMake(20, 19, view.width - 20 - 16, 15) AndFontSize:15 AndTitle: storeDetail.address];
    [view addSubview:addressLab];
    
    UILabel *phoneLab = [TCComponent createLabelWithFrame:CGRectMake(20, view.height - 19 - 14, addressLab.width, addressLab.height) AndFontSize:15 AndTitle:storeDetail.phone];
    [view addSubview:phoneLab];
    
    UIButton *phoneBtn = [TCComponent createImageBtnWithFrame:CGRectMake(view.width - 20 - 15, addressLab.y, 15, 15) AndImageName:@"res_phone"];
    [phoneBtn addTarget:self action:@selector(touchPhoneBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:phoneBtn];
    UIButton *addressBtn = [TCComponent createImageBtnWithFrame:CGRectMake(phoneBtn.x, phoneLab.y, phoneBtn.width, phoneBtn.height) AndImageName:@"res_location2"];
    [addressBtn addTarget:self action:@selector(touchLocationBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addressBtn];
    
    return view;
}

- (UIView *)createTextViewWithFrame:(CGRect)frame AndTitle:(NSString *)title AndText:(NSString *)text AndimgName:(NSString *)imgName{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];

    
    UIView *titleView = [self getImageTitleViewWithFrame:CGRectMake(0, 22.5, frame.size.width, 23) AndImgName:imgName AndTitle:title];
    
    UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(62, titleView.y + titleView.height + 8, view.width - 62 * 2, view.height - 96 + 15)];
    textLab.numberOfLines = 4;
    textLab.font = [UIFont systemFontOfSize:15];
    textLab.attributedText = [self getAttributedStringWithText:text];
   
    UIView *line = [TCComponent createGrayLineWithFrame:CGRectMake(20, view.size.height - 0.5, view.width - 40, 0.5)];

    if (text.length > 80) {
        UIButton *moreInfoBtn = [self getMoreInfoButtonWithFrame:CGRectMake(0, frame.size.height - 10 - 12, frame.size.width, 12)];
        [view addSubview:moreInfoBtn];
        if ([title isEqualToString:@"推荐理由"]) {
            [moreInfoBtn addTarget:self action:@selector(touchMoreRecommendInfo) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [moreInfoBtn addTarget:self action:@selector(touchMoreTopicInfo) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    [view addSubview:titleView];
    [view addSubview:textLab];
    [view addSubview:line];
    
    return view;
}

- (UIView *)createPromptViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = [self getImageTitleViewWithFrame:CGRectMake(0, 21, self.view.frame.size.width, 23) AndImgName:@"res_prompt" AndTitle:@"温馨提示"];
    [view addSubview:titleView];
    
    
    UIView *allImgView = [self getPromptImageView];
    [allImgView setOrigin:CGPointMake(self.view.frame.size.width / 2 - allImgView.width / 2, titleView.y + titleView.height + 13)];
    [view addSubview:allImgView];
    
    TCDetailStore *storeDetail = serviceDetail.detailStore;
    NSString *time = [NSString stringWithFormat:@"每天 %@",storeDetail.businessHours];
    UILabel *timeLab = [TCComponent createLabelWithFrame:CGRectMake(0, allImgView.y + allImgView.height + 12, self.view.frame.size.width, 13) AndFontSize:13 AndTitle:time AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    timeLab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:timeLab];
    
    return view;
}

- (UIButton *)createPhoneCustomViewWithFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    
    UIImageView *phoneImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"res_phone-1"]];
    [phoneImgView setFrame:CGRectMake(0, (frame.size.height - 18) / 2 + 1 , 18, 18)];
    
    UILabel *phoneLab = [TCComponent createLabelWithText:@"电话客服" AndFontSize:14];
    phoneLab.textColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"res_phone_mark"]];
    [arrowImgView setFrame:CGRectMake(0, frame.size.height / 2 - 7 + 1.7, 10, 14)];
    
    [phoneImgView setX:frame.size.width / 2 - (phoneImgView.width + phoneLab.width + arrowImgView.width + 3 + 3) / 2];
    [phoneLab setOrigin:CGPointMake(phoneImgView.x + phoneImgView.width + 3, frame.size.height / 2 - 7)];
    [arrowImgView setX:phoneLab.x + phoneLab.width + 3];
    
    [button addSubview:phoneImgView];
    [button addSubview:phoneLab];
    [button addSubview:arrowImgView];
    
    
    return button;
}



- (void)createBottomButton {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 45, self.view.frame.size.width, 45)];
    UIColor *backColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    UIButton *orderBtn = [self createBottomBtnWithFrame:CGRectMake(0, 0, bottomView.width / 2, bottomView.height) AndText:@"优惠买单" AndImgName:@"res_discount" AndBackColor: [UIColor colorWithRed:112/255.0 green:206/255.0 blue:213/255.0 alpha:1]];
    [orderBtn addTarget:self action:@selector(touchOrderRest) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *reserveBtn = [self createBottomBtnWithFrame:CGRectMake(bottomView.width / 2, 0, bottomView.width / 2, bottomView.height) AndText:@"预订餐位" AndImgName:@"res_ordering" AndBackColor:backColor];
    [reserveBtn addTarget:self action:@selector(touchReserveRest) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:reserveBtn];
    [bottomView addSubview:orderBtn];
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.5)];
    [bottomView addSubview:lineView];
    
    [self.view addSubview:bottomView];
    
}

- (UIButton *)createBottomBtnWithFrame:(CGRect)frame AndText:(NSString *)text AndImgName:(NSString *)imgName AndBackColor:(UIColor *)backColor{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    [imgView sizeToFit];
    [imgView setOrigin:CGPointMake(53, frame.size.height / 2 - imgView.height / 2 + 1)];
    [button addSubview:imgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imgView.x + imgView.width + 2, 0, 100, frame.size.height)];
    label.text = text;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:17];
    [button addSubview:label];
    
    button.backgroundColor = backColor;
    
    return button;
}

- (UIView *)getPromptImageView {
    UIView *view = [[UIView alloc] init];
    NSArray *promptArr = serviceDetail.detailStore.tags;
//    NSArray *promptImageArr = serviceDetail.pictures;
    for (int i = 0; i < promptArr.count; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 27 + 35, 0, 27, 27)];
        if (i == 0) {
            [imgView setX:0];
        }
//        NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL,promptImageArr[i]]];
//        [imgView sd_setImageWithURL:imageURL];
        imgView.image = [UIImage imageNamed:@"res_phone"];
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = promptArr[i];
        titleLab.font = [UIFont systemFontOfSize:13];
        titleLab.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
        [titleLab sizeToFit];
        [titleLab setOrigin:CGPointMake(imgView.x + imgView.width / 2 - titleLab.width / 2, imgView.y + imgView.height + 5)];
        
        [view addSubview:imgView];
        [view addSubview:titleLab];
    }
    [view setSize:CGSizeMake(27 * promptArr.count + (promptArr.count - 1) * 35, 27 + 5 + 13)];
    
    return view;
}


- (UIView *)getImageTitleViewWithFrame:(CGRect)frame AndImgName:(NSString *)imgName AndTitle:(NSString *)title {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:imgName];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    UILabel *titleLab = [TCComponent createLabelWithText:title AndFontSize:22];
    [imgView setOrigin:CGPointMake(view.width / 2 - (titleLab.width + image.size.width) / 2, 4)];
    [titleLab setOrigin:CGPointMake(imgView.x + imgView.width + 2, 0)];
    
    [view addSubview:imgView];
    [view addSubview:titleLab];

    return view;
}

- (NSMutableAttributedString *)getAttributedStringWithText:(NSString *)text {
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentJustified;
//    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [attrText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];

    return attrText;
}


- (UIView *)getRestTypeAndAddressInfoWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    TCDetailStore *detailStore = serviceDetail.detailStore;
    UILabel *locationLab = [TCComponent createLabelWithText:detailStore.address AndFontSize:14];
    [locationLab setOrigin:CGPointMake(frame.size.width / 2 - locationLab.width / 2, 0)];
    [view addSubview:locationLab];
    
    UIView *leftLine = [TCComponent createGrayLineWithFrame:CGRectMake(locationLab.x - 8 - 0.25, locationLab.y, 0.5, locationLab.height)];
    [view addSubview:leftLine];
    
    UIView *rightLine = [TCComponent createGrayLineWithFrame:CGRectMake(locationLab.x + locationLab.width + 8, locationLab.y, 0.5, locationLab.height)];
    [view addSubview:rightLine];
    
    UILabel *typeLab = [TCComponent createLabelWithFrame:CGRectMake(0, locationLab.y, leftLine.x - 8, locationLab.height) AndFontSize:14 AndTitle:detailStore.brand];
    typeLab.textAlignment = NSTextAlignmentRight;
    [view addSubview:typeLab];
    
    UILabel *rangeLab = [TCComponent createLabelWithFrame:CGRectMake(rightLine.x + 0.5 + 8, locationLab.y, frame.size.width - rightLine.x + 0.5 + 8, locationLab.height) AndFontSize:14 AndTitle:@"2222m"];
    rangeLab.textAlignment = NSTextAlignmentLeft;
    [view addSubview:rangeLab];

    return view;
}

- (UIView *)getCollectionViewWithFrame:(CGRect)frame AndNumber:(NSInteger)number{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIImage *collectionImg = [UIImage imageNamed:@"res_collection_gray"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, 11, 9)];
    imgView.image = collectionImg;
    [view addSubview:imgView];
    
    NSString *numberStr = [NSString stringWithFormat:@"%li", (long)number];
    UILabel *label = [TCComponent createLabelWithFrame:CGRectMake(imgView.x + imgView.width + 1, 0, frame.size.width - imgView.x - imgView.width, frame.size.height) AndFontSize:frame.size.height AndTitle:[NSString stringWithFormat:@"%@已收藏", numberStr] AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    [view addSubview:label];
    
    
    return view;
}


- (UIButton *)getMoreInfoButtonWithFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:@"更多详情>" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    return button;
}


#pragma mark - click
- (void)touchBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchCollectionBtn:(UIButton *)button {
    if (mScrollView.contentOffset.y < 70) {
        isCollection = !isCollection;
        UIButton *rightBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 20, 17) AndImageName:[self getCollectionImageName]];
        [rightBtn addTarget:self action:@selector(touchCollectionBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    }
}

- (void)touchReserveRest {
    NSString *storeSetMealId = serviceDetail.ID;
    TCReserveOnlineViewController *reserveOnlineViewController = [[TCReserveOnlineViewController alloc] initWithStoreSetMealId:storeSetMealId];
    [self.navigationController pushViewController:reserveOnlineViewController animated:YES];
}

- (void)touchOrderRest {
//    restaurantInfoDic[@""]    data
//    
//    UIViewController *viewController = [[UIViewController alloc] init];
//    viewController.title = @"外卖订餐";
//    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)touchPhoneBtn {
    TCDetailStore *detailStore = serviceDetail.detailStore;
    UIWebView *callView = [TCComponent callWithPhone:detailStore.phone];
    [self.view addSubview:callView];
}

- (void)touchCallCustomerService {
        UIWebView *callView = [TCComponent callWithPhone:@"15733108692"];
        [self.view addSubview:callView];
    
}

- (void)touchLocationBtn {
    //    restaurantInfoDic[@"position"]
    
    TCLocationViewController *locationViewController = [[TCLocationViewController alloc] init];
    [self.navigationController pushViewController:locationViewController animated:YES];
}

- (void)touchMoreRecommendInfo {
    
}

- (void)touchMoreTopicInfo {
    
}

- (NSString *)getCollectionImageName {
    if (isCollection == YES) {
        return @"res_collection";
    } else {
        return @"res_collection_not";
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat minAlphaOffset = 0;
    CGFloat maxAlphaOffset = 270;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    barImageView.alpha = alpha;
    

    CGPoint point = scrollView.contentOffset;
    
    if (point.y > 70) {
        [self initialNavLeftBarWithImgName:@"back_black" AndRightBarImgName:@"res_collection_black"];
        statusColorStr = @"black";
        [self setNeedsStatusBarAppearanceUpdate];
    } else {
        [self initialNavLeftBarWithImgName:@"back" AndRightBarImgName:[self getCollectionImageName]];
        statusColorStr = @"white";
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if (point.y < 0) {
        double height = -point.y + 270;
        double number = height / 270;
        double width = self.view.frame.size.width * number;
        double logoRadius = height * 0.12;
        double addHeight = logoRadius * 2 - logoView.height;
    
        [restaurantInfoLogoImageView setFrame:CGRectMake(self.view.frame.size.width / 2 - width / 2, point.y, width, height)];
        [logoView setNewFrame:CGRectMake(restaurantInfoLogoImageView.frame.size.width / 2 - logoRadius, restaurantInfoLogoImageView.frame.size.height - logoRadius, logoRadius * 2, logoRadius * 2)];
        baseInfoView.y = baseInfoView.y + addHeight;
        
    }
}




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    mScrollView.delegate = nil;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    barImageView.alpha = 1.0;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([statusColorStr isEqualToString:@"black"]) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
