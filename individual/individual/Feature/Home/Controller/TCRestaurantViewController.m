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
}

@end

@implementation TCRestaurantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialNavigationBar];
    
    [self initialData];
    
    [self initialTableView];
    
}

- (void)initialNavigationBar {

    UIButton *leftBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:@"back"];
    [leftBtn addTarget:self action:@selector(touchBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.titleView = [TCGetNavigationItem getTitleItemWithText:@"餐饮"];
    
    UIButton *rightBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 20, 17) AndImageName:@"location"];
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
    
    
    restaurantArray = @[ info1, info2, info3, info4, info5 ];
    
}



- (void)initialTableView {
    mResaurantTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.size.height) style:UITableViewStylePlain];
    mResaurantTableView.delegate = self;
    mResaurantTableView.dataSource = self;
    mResaurantTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:mResaurantTableView];
}

- (UITableViewCell *)getTopSelectViewWithTableView:(UITableView *)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIButton *sortBtn = [self getSelectButtonWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, 42) AndText:@"智能排序" AndImageName:@"select_down"];
    [cell.contentView addSubview:sortBtn];
    
    UIButton *filterBtn = [self getSelectButtonWithFrame:CGRectMake(self.view.width / 2, 0, self.view.width / 2, 42) AndText:@"筛选" AndImageName:@"select_down"];
    [cell.contentView addSubview:filterBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width / 2 - 0.5, 14, 1, 46 - 16 * 2)];
    lineView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [cell.contentView addSubview:lineView];
    
    return cell;
}

- (UIButton *)getSelectButtonWithFrame:(CGRect)frame AndText:(NSString *)text AndImageName:(NSString *)imgName {
    UIButton *view = [[UIButton alloc] initWithFrame:frame];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
    [button sizeToFit];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    [imgView sizeToFit];
    
    [button setOrigin:CGPointMake(frame.size.width / 2 - (button.width + imgView.width + 3) / 2, frame.size.height / 2 - button.height / 2)];
    [imgView setOrigin:CGPointMake(button.x + button.width + 3, frame.size.height / 2 - imgView.frame.size.height / 2)];
    
    [view addSubview:button];
    [view addSubview:imgView];
    
    return view;
}


- (TCRestaurantTableViewCell *)getTableViewCellInfoWithIndex:(NSIndexPath *)indexPath AndTableView:(UITableView *)tableView{
    TCRestaurantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[TCRestaurantTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *resInfo = restaurantArray[indexPath.row - 1];
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
    return restaurantArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        return [self getTopSelectViewWithTableView:tableView];
    }
    else {
        return [self getTableViewCellInfoWithIndex:indexPath AndTableView:tableView];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 42;
    }
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
