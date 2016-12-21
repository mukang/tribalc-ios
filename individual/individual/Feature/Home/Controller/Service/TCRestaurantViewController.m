//
//  TCRestaurantViewController.m
//  individual
//
//  Created by chen on 16/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantViewController.h"

@interface TCRestaurantViewController () {
    TCServiceWrapper *mServiceWrapper;
    UIView *backView;
    TCRestaurantSortView *sortView;
    TCRestaurantFilterView *filterView;
    TCRestaurantSelectButton *sortButton;
    TCRestaurantSelectButton *filterButton;
    
}

@end

@implementation TCRestaurantViewController

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self loadRestaurantDataWithSortType:nil];
    
    [self initialTableView];
    
    [self initUI];
    
    
}

#pragma mark - Navigation Bar
- (void)setupNavigationBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(touchBackBtn:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"res_location"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(touchLocationBtn:)];
}


#pragma mark - Get Data
- (void)loadRestaurantDataWithSortType:(NSString *)sortType {
    TCBuluoApi *api = [TCBuluoApi api];
    NSString *categoryStr = [self.title isEqualToString:@"餐饮"] ? @"REPAST" : @"ENTERTAINMENT";
    [api fetchServiceWrapper:categoryStr limiSize:20 sortSkip:nil sort:sortType result:^(TCServiceWrapper *serviceWrapper, NSError *error) {
        mServiceWrapper = serviceWrapper;
        [mResaurantTableView reloadData];
        [mResaurantTableView.mj_header endRefreshing];
    }];
    
}

- (void)loadResturantDataWithSortSkip:(NSString *)nextSkip AndSort:(NSString *)sortType {
    if (mServiceWrapper.hasMore == YES) {
        TCBuluoApi *api = [TCBuluoApi api];
        NSString *categoryStr = [self.title isEqualToString:@"餐饮"] ? @"REPAST" : @"ENTERTAINMENT";
        [api fetchServiceWrapper:categoryStr limiSize:20 sortSkip:nextSkip sort:sortType result:^(TCServiceWrapper *serviceWrapper, NSError *error) {
            NSArray *contentArr = mServiceWrapper.content;
            mServiceWrapper = serviceWrapper;
            mServiceWrapper.content = [contentArr arrayByAddingObjectsFromArray:serviceWrapper.content];
            [mResaurantTableView reloadData];
            [mResaurantTableView.mj_footer endRefreshing];
        }];
    } else {
        TCRecommendFooter *footer = (TCRecommendFooter *)mResaurantTableView.mj_footer;
        [footer setTitle:@"已加载全部" forState:MJRefreshStateRefreshing];
        [mResaurantTableView.mj_footer endRefreshing];
    }
}

- (void)initUI {
    [self initHiddenBackView];
    
    sortView = [[TCRestaurantSortView alloc] initWithFrame:CGRectMake(0, TCRealValue(42), self.view.width, TCRealValue(169 + 10))];
    sortView.hidden = YES;
    [self.view addSubview:sortView];
    
    filterView = [[TCRestaurantFilterView alloc] initWithFrame:CGRectMake(0, TCRealValue(42), self.view.width, TCRealValue(105))];
    filterView.hidden = YES;
    [self.view addSubview:filterView];
}

- (void)initHiddenBackView {
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, TCRealValue(42), self.view.width, self.view.height - TCRealValue(42))];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchHiddenSelectView)];
    [backView addGestureRecognizer:recognizer];
    [self.view addSubview:backView];
    backView.hidden = YES;

}




- (void)initialTableView {
    mResaurantTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.size.height) style:UITableViewStyleGrouped];
    mResaurantTableView.delegate = self;
    mResaurantTableView.dataSource = self;
    mResaurantTableView.contentInset = UIEdgeInsetsMake(0, 0, TCRealValue(22), 0);
    [self.view addSubview:mResaurantTableView];
    
    TCRecommendHeader *refreshHeader = [TCRecommendHeader headerWithRefreshingBlock:^{
        [self loadRestaurantDataWithSortType:mServiceWrapper.sort];
    }];
    mResaurantTableView.mj_header = refreshHeader;
    
    TCRecommendFooter *refreshFooter = [TCRecommendFooter footerWithRefreshingBlock:^{
        [self loadResturantDataWithSortSkip:mServiceWrapper.nextSkip AndSort:mServiceWrapper.sort];
    }];
    mResaurantTableView.mj_footer = refreshFooter;
    
}

- (NSString *)getDistanceWithLocation:(NSArray *)locationArr {
    NSString *distance;
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
    }
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        locationManager.delegate=self;
        //设置定位精度
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;
        locationManager.distanceFilter=distance;
        //启动跟踪定位
        [locationManager startUpdatingLocation];
    }
    
    
    
    return distance;
}



- (UIView *)getTopViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    sortButton = [[TCRestaurantSelectButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width / 2, TCRealValue(42)) AndText:@"智能排序" AndImgName:@"res_select_down"];
    [view addSubview:sortButton];
    [sortButton addTarget:self action:@selector(touchSortBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    filterButton = [[TCRestaurantSelectButton alloc] initWithFrame:CGRectMake(self.view.width / 2, 0, self.view.width / 2, TCRealValue(42)) AndText:@"筛选" AndImgName:@"res_select_down"];
    [filterButton addTarget:self action:@selector(touchFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:filterButton];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 2 - TCRealValue(0.5), TCRealValue(14), TCRealValue(1), TCRealValue(46 - 16 * 2))];
    lineView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [view addSubview:lineView];
    
    return view;
    
}



- (TCRestaurantTableViewCell *)getTableViewCellInfoWithIndex:(NSIndexPath *)indexPath AndTableView:(UITableView *)tableView AndCell:(TCRestaurantTableViewCell *)cell{

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TCServices *resInfo = mServiceWrapper.content[indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, resInfo.mainPicture]];
    [cell.resImgView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"home_image_place"]];
    cell.nameLab.text = resInfo.name;
    TCListStore *storeInfo = resInfo.store;
    [cell setLocation:storeInfo.markPlace];
    [cell setType:storeInfo.brand];
    [cell setPrice:resInfo.personExpense];
//    if ([resInfo[@"room"] isEqual:@YES]) {
        [cell isSupportRoom:YES];
//    }
    if (resInfo.reservable == TRUE) {
        [cell isSupportReserve:YES];
    }
    cell.rangeLab.text = @"233m";
    

    
    return cell;
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mServiceWrapper.content.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = [NSString stringWithFormat:@"cell%ld%ld", (long)indexPath.section, (long)indexPath.row];
    TCRestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TCRestaurantTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    return [self getTableViewCellInfoWithIndex:indexPath AndTableView:tableView AndCell:cell];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TCRealValue(160);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    TCServices *service = mServiceWrapper.content[indexPath.row];
    TCRestaurantInfoViewController *restaurantInfo = [[TCRestaurantInfoViewController alloc]initWithServiceId:service.ID];
    [self.navigationController pushViewController:restaurantInfo animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TCRealValue(42);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self getTopViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, TCRealValue(42))];
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}


# pragma mark - click
- (void)touchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchLocationBtn:(id)sender {
    TCLocationViewController *locationViewController = [[TCLocationViewController alloc] init];
    [self.navigationController pushViewController:locationViewController animated:YES];
}

- (void)touchSortBtn:(id)sender {
    
    if (sortView.hidden == YES) {
        
        [self showSortView];
        
        
        [sortView.averageMinBtn addTarget:self action:@selector(touchSortByAverageMin) forControlEvents:UIControlEventTouchUpInside];
        [sortView.averageMaxBtn addTarget:self action:@selector(touchSortByAverageMax) forControlEvents:UIControlEventTouchUpInside];
        [sortView.distanceMinBtn addTarget:self action:@selector(touchSortByDistance) forControlEvents:UIControlEventTouchUpInside];
        [sortView.evaluateMaxBtn addTarget:self action:@selector(touchSortByEvaluate) forControlEvents:UIControlEventTouchUpInside];
        [sortView.popularityMaxBtn addTarget:self action:@selector(touchSortByPopularity) forControlEvents:UIControlEventTouchUpInside];

    } else {
        [self hideViewWithButton:sortButton];
    }
    
    
    
}

- (void)touchHiddenSelectView {
    filterView.hidden = YES;
    filterButton.titleLab.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    filterButton.imgeView.image = [UIImage imageNamed:@"res_select_down"];
    [filterButton.imgeView setSize:CGSizeMake(TCRealValue(13), TCRealValue(6))];
    
    
    sortView.hidden = YES;
    sortButton.titleLab.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    sortButton.imgeView.image = [UIImage imageNamed:@"res_select_down"];
    
    backView.hidden = YES;
}


- (void)touchSortByAverageMin {
    [self removeOtherSelectBtnColor:sortView.averageMinBtn AndType:@"sort"];
    [self hideViewWithButton:sortButton];
    
    [self sortByInfo:@"人均最低"];
    
}
- (void)touchSortByAverageMax {
    [self removeOtherSelectBtnColor:sortView.averageMaxBtn AndType:@"sort"];
    [self hideViewWithButton:sortButton];
    
    [self sortByInfo:@"人均最高"];
    
}
- (void)touchSortByDistance {
    [self removeOtherSelectBtnColor:sortView.distanceMinBtn AndType:@"sort"];
    [self hideViewWithButton:sortButton];
    
    [self sortByInfo:@"距离最近"];
    
}
- (void)touchSortByEvaluate {
    [self removeOtherSelectBtnColor:sortView.evaluateMaxBtn AndType:@"sort"];
    [self hideViewWithButton:sortButton];
    
    [self sortByInfo:@"评价最高"];
    
}
- (void)touchSortByPopularity {
    [self removeOtherSelectBtnColor:sortView.popularityMaxBtn AndType:@"sort"];
    [self hideViewWithButton:sortButton];
    [self sortByInfo:@"人气最高"];
}




- (void)touchFilterBtn:(id)sender {
    if (filterView.hidden == YES) {
        [self showFilterView];
        [filterView.deliverBtn addTarget:self action:@selector(touchDeliverBtn) forControlEvents:UIControlEventTouchUpInside];
        [filterView.reserveBtn addTarget:self action:@selector(touchReserveBtn) forControlEvents:UIControlEventTouchUpInside ];
        
    } else {
        [self hideViewWithButton:filterButton];
    }
    
}

- (void)touchDeliverBtn {
    [self removeOtherSelectBtnColor:filterView.deliverBtn AndType:@"filter"];
    [self hideViewWithButton:filterButton];
    
    [self sortByInfo:@"有包间"];
}

- (void)touchReserveBtn {
    [self removeOtherSelectBtnColor:filterView.reserveBtn AndType:@"filter" ];
    [self hideViewWithButton:filterButton];
    
    [self sortByInfo:@"可预订"];
}




# pragma mark other
- (void)getNewDataWithUrl:(NSURL *)url AndMessage:(NSString *)message {
//    NSURL *url = [NSURL URLWithString:@""];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
//            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            ///////////
        }
    }];
    [dataTask resume];

}

- (void)sortByInfo:(NSString *)info {
    NSString *type;
    if ([info isEqualToString:@"人均最低"]) {
        type = @"personExpense,asc";

    } else if ([info isEqualToString:@"人均最高"]) {
        type = @"personExpense,desc";

    } else if ([info isEqualToString:@"人气最高"]) {
        type = @"popularValue,desc";
    }
    [self loadRestaurantDataWithSortType:type];

}


- (void)removeOtherSelectBtnColor:(TCSelectSortButton *)button AndType:(NSString *)type{
    
    NSArray *btnArr;
    if ([type isEqualToString:@"sort"]) {
        btnArr =  @[sortView.averageMinBtn, sortView.averageMaxBtn, sortView.distanceMinBtn, sortView.evaluateMaxBtn, sortView.popularityMaxBtn];
    } else {
        btnArr = @[filterView.reserveBtn, filterView.deliverBtn];
    }
    
    
    for (int i = 0; i < btnArr.count; i++) {
        TCSelectSortButton *sortBtn = btnArr[i];
        if ([sortBtn.textLab.textColor isEqual:[UIColor colorWithRed:80/255.0 green:199/255.0 blue:209/255.0 alpha:1]] && ![sortBtn isEqual:button] ) {
            sortBtn.textLab.textColor = [UIColor blackColor];
            [sortBtn.imgBtn setImage:[UIImage imageNamed:[self getBtnImageNameWithInstance:sortBtn]] forState:UIControlStateNormal];
        }
    }
}





- (NSString *)getBtnImageNameWithInstance:(TCSelectSortButton *)button {
    if ([button isEqual:sortView.averageMinBtn]) {
        return @"res_average_min";
    } else if([button isEqual:sortView.averageMaxBtn]) {
        return @"res_average_max";
    } else if([button isEqual:sortView.distanceMinBtn]) {
        return @"res_near";
    } else if([button isEqual:sortView.evaluateMaxBtn]) {
        return @"res_evaluate";
    } else if([button isEqual:sortView.popularityMaxBtn]) {
        return @"res_popularity_max";
    } else if([button isEqual:filterView.deliverBtn]) {
        return @"res_deliver";
    } else if ([button isEqual:filterView.reserveBtn]) {
        return @"res_reserve2";
    }
    else {
        return NULL;
    }
}

- (void)showSortView {
    sortView.hidden = NO;
    sortButton.titleLab.textColor = [UIColor colorWithRed:80/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    sortButton.imgeView.image = [UIImage imageNamed:@"res_select_blue"];
    [sortButton.imgeView setSize:CGSizeMake(13, 6)];
    
    filterView.hidden = YES;
    filterButton.titleLab.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    filterButton.imgeView.image = [UIImage imageNamed:@"res_select_down"];
    
    backView.hidden = NO;
    
}

- (void)showFilterView {
    filterView.hidden = NO;
    filterButton.titleLab.textColor = [UIColor colorWithRed:80/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    filterButton.imgeView.image = [UIImage imageNamed:@"res_select_blue"];
    [filterButton.imgeView setSize:CGSizeMake(13, 6)];

    
    sortView.hidden = YES;
    sortButton.titleLab.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    sortButton.imgeView.image = [UIImage imageNamed:@"res_select_down"];
    
    backView.hidden = NO;
}

- (void)hideViewWithButton:(TCRestaurantSelectButton *)button {
    if ([button isEqual:sortButton]) {
        sortView.hidden = YES;
    } else {
        filterView.hidden = YES;
    }
    button.titleLab.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    button.imgeView.image = [UIImage imageNamed:@"res_select_down"];
    backView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
