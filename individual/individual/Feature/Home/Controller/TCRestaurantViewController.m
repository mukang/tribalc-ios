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
    self.title = @"餐饮";
    
    [self initialData];
    
    [self initialTableView];
    
}

- (void)initialData {
    
    NSDictionary *info1 = @{ @"name": @"麦当劳", @"location":@"朝阳区", @"type":@"快餐",  @"price":@"56", @"range":@"872m", @"room":@"1", @"reserve":@"0" };
    
    NSDictionary *info2 = @{ @"name": @"魏蜀吴老火锅", @"location":@"北苑家园", @"type":@"火锅",  @"price":@"100", @"range":@"1872m", @"room":@"1", @"reserve":@"1" };
    
    NSDictionary *info3 = @{ @"name": @"小院时光", @"location":@"朝阳区", @"type":@"创意菜",  @"price":@"35", @"range":@"72km" , @"room":@"0", @"reserve":@"1" };
    
    NSDictionary *info4 = @{ @"name": @"雕刻时光咖啡馆", @"location":@"北苑家园", @"type":@"雕刻时光", @"price":@"86", @"range":@"272m", @"room":@"1", @"reserve":@"0" };
    
    NSDictionary *info5 = @{ @"name": @"三和屋(北苑店)", @"location":@"朝阳区", @"type":@"寿司", @"price":@"56", @"range":@"872m", @"room":@"0", @"reserve":@"0"  };
    restaurantArray = @[ info1, info2, info3, info4, info5 ];
    
}



- (void)initialTableView {
    mResaurantTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.size.height) style:UITableViewStylePlain];
    mResaurantTableView.delegate = self;
    mResaurantTableView.dataSource = self;
    [self.view addSubview:mResaurantTableView];
}

- (UITableViewCell *)getTopSelectViewWithTableView:(UITableView *)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    return cell;
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
    cell.locationAndTypeLab.text = [NSString stringWithFormat:@"%@ %@", resInfo[@"location"], resInfo[@"type"]];
    cell.priceLab.text =  [NSString stringWithFormat:@"￥%@/人", resInfo[@"price"]];
    [cell.priceLab sizeToFit];
    cell.rangeLab.text = resInfo[@"range"];
    
    if ([resInfo[@"room"] isEqualToString:@"1"]) {
        cell.privateRoomBtn.hidden = NO;
    }
    if ([resInfo[@"reserve"] isEqualToString:@"1"]) {
        cell.reserveBtn.hidden = NO;
    }
    [cell showRestaurantButton];
    
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
        return 84;
    }
    return 165;
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
