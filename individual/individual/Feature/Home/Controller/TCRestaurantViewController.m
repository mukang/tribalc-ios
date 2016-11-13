//
//  TCRestaurantViewController.m
//  individual
//
//  Created by chen on 16/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantViewController.h"

@interface TCRestaurantViewController () {
    NSArray *restaurantArray;
    UIView *backView;
    TCRestaurantSortView *sortView;
    TCRestaurantFilterView *filterView;
    TCRestaurantSelectButton *sortButton;
    TCRestaurantSelectButton *filterButton;
    
}

@end

@implementation TCRestaurantViewController

- (void)viewWillAppear:(BOOL)animated {
    [self initialNavigationBar];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [self initialNavigationBar];
    
    [self initialData];
    
    [self initialTableView];
    
    
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, self.view.width, self.view.height - 42)];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:backView];
    backView.hidden = YES;
    
    
    sortView = [[TCRestaurantSortView alloc] initWithFrame:CGRectMake(0, 42, self.view.width, 169 + 10)];
    sortView.hidden = YES;
    [self.view addSubview:sortView];
    
    filterView = [[TCRestaurantFilterView alloc] initWithFrame:CGRectMake(0, 42, self.view.width, 105)];
    filterView.hidden = YES;
    [self.view addSubview:filterView];

    
}

- (void)initialNavigationBar {
    

    UIButton *leftBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:@"back"];
    [leftBtn addTarget:self action:@selector(touchBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.titleView = [TCGetNavigationItem getTitleItemWithText:@"餐饮"];
    
    UIButton *rightBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 20, 17) AndImageName:@"res_location"];
    [rightBtn addTarget:self action:@selector(touchLocationBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}



- (void)initialData {
    
    NSDictionary *info1 = @{ @"name": @"麦当劳", @"location":@"朝阳区", @"type":@"快餐",  @"price":@"56", @"range":@"872m", @"room":@true, @"reserve":@false };
    
    NSDictionary *info2 = @{ @"name": @"魏蜀吴老火锅", @"location":@"北苑家园", @"type":@"火锅",  @"price":@"100", @"range":@"1872m", @"room":@true, @"reserve":@true };
    
    NSDictionary *info3 = @{ @"name": @"小院时光", @"location":@"朝阳区", @"type":@"创意菜",  @"price":@"35", @"range":@"72km" , @"room":@false, @"reserve":@true };
    
    NSDictionary *info4 = @{ @"name": @"雕刻时光咖啡馆", @"location":@"北苑家园", @"type":@"雕刻时光", @"price":@"86", @"range":@"272m", @"room":@true, @"reserve":@false };
    
    NSDictionary *info5 = @{ @"name": @"三和屋(北苑店)", @"location":@"朝阳区", @"type":@"寿司", @"price":@"56", @"range":@"872m", @"room":@false, @"reserve":@false  };
    
    
    NSURL *url = [NSURL URLWithString:@""];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            ///////////
        }
    }];
    [dataTask resume];
    
    
    restaurantArray = @[ info1, info2, info3, info4, info5,info1, info2, info3, info4, info5,info1, info2, info3, info4, info5,info1, info2, info3, info4, info5 ];
    
}



- (void)initialTableView {
    mResaurantTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.size.height) style:UITableViewStyleGrouped];
    mResaurantTableView.delegate = self;
    mResaurantTableView.dataSource = self;
    mResaurantTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:mResaurantTableView];
}


- (UIView *)getTopViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    sortButton = [[TCRestaurantSelectButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width / 2, 42) AndText:@"智能排序" AndImgName:@"res_select_down"];
    [view addSubview:sortButton];
    [sortButton addTarget:self action:@selector(touchSortBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    filterButton = [[TCRestaurantSelectButton alloc] initWithFrame:CGRectMake(self.view.width / 2, 0, self.view.width / 2, 42) AndText:@"筛选" AndImgName:@"res_select_down"];
    [filterButton addTarget:self action:@selector(touchFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:filterButton];
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 0.5, 14, 1, 46 - 16 * 2)];
    lineView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [view addSubview:lineView];
    
    return view;
    
}



- (TCRestaurantTableViewCell *)getTableViewCellInfoWithIndex:(NSIndexPath *)indexPath AndTableView:(UITableView *)tableView AndCell:(TCRestaurantTableViewCell *)cell{

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *resInfo = restaurantArray[indexPath.row];
    cell.resImgView.image = [UIImage imageNamed:@"null_length"];
    cell.nameLab.text = resInfo[@"name"];
    [cell setLocation:resInfo[@"location"]];
    [cell setType:resInfo[@"type"]];
    [cell setPrice:resInfo[@"price"]];
    NSLog(@"%@, %@", resInfo[@"room"], resInfo[@"reserve"]);
    if ([resInfo[@"room"] isEqual:@YES]) {
        [cell isSupportRoom:YES];
    }
    if ([resInfo[@"reserve"] isEqual:@YES]) {
        [cell isSupportReserve:YES];
    }
    cell.rangeLab.text = resInfo[@"range"];
    

    
    return cell;
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return restaurantArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cell";
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
    return 160;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        TCRestaurantInfoViewController *restaurantInfo = [[TCRestaurantInfoViewController alloc]init];
        [self.navigationController pushViewController:restaurantInfo animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 42;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self getTopViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 42)];
    
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


# pragma makr - click
- (void)touchBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchLocationBtn:(id)sender {
    
}
- (void)touchCollectionBtn:(id)sender {
    
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


- (void)touchSortByAverageMin {
    [self removeOtherSelectBtnColor:sortView.averageMinBtn AndType:@"sort"];
    ///////////////
    
    [self hideViewWithButton:sortButton];
    
}
- (void)touchSortByAverageMax {
    [self removeOtherSelectBtnColor:sortView.averageMaxBtn AndType:@"sort"];
    
    
    [self hideViewWithButton:sortButton];
    
    
}
- (void)touchSortByDistance {
    [self removeOtherSelectBtnColor:sortView.distanceMinBtn AndType:@"sort"];
    
    [self hideViewWithButton:sortButton];
}
- (void)touchSortByEvaluate {
    [self removeOtherSelectBtnColor:sortView.evaluateMaxBtn AndType:@"sort"];
    
    
    [self hideViewWithButton:sortButton];
    
}
- (void)touchSortByPopularity {
    [self removeOtherSelectBtnColor:sortView.popularityMaxBtn AndType:@"sort"];
    
    
    [self hideViewWithButton:sortButton];
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
    ///////////////
    
    [self hideViewWithButton:filterButton];
}

- (void)touchReserveBtn {
    [self removeOtherSelectBtnColor:filterView.reserveBtn AndType:@"filter" ];
    ///////////////
    
    [self hideViewWithButton:filterButton];
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
    sortButton.imgeView.image = [UIImage imageNamed:@"res_select_up"];
    
    filterView.hidden = YES;
    filterButton.titleLab.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    filterButton.imgeView.image = [UIImage imageNamed:@"res_select_down"];
    
    backView.hidden = NO;
    
}

- (void)showFilterView {
    filterView.hidden = NO;
    filterButton.titleLab.textColor = [UIColor colorWithRed:80/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    filterButton.imgeView.image = [UIImage imageNamed:@"res_select_up"];
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
