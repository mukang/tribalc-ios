//
//  TCShoppingCartViewController.m
//  individual
//
//  Created by WYH on 16/11/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCShoppingCartViewController.h"

@interface TCShoppingCartViewController () {
    NSMutableArray *cartInfoArray;
    UITableView *cartTableView;
    UIButton *navRightBtn;
    float cellHeight;
    
}

@end

@implementation TCShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"购物车";
    // Do any additional setup after loading the view.
    cellHeight = 150.0;
    
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    topLine.backgroundColor = [UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1];
    [self.view addSubview:topLine];
    
    [self initialNavigationBar];
    [self initialShoppingCartInfoData];
    [self initialTableView];
    
    
    
    
}

- (void)initialNavigationBar {
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [self initialRightBarButton];
    
}

- (void)initialRightBarButton {
    navRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100, 7, 80, 26)];
    [navRightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    navRightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [navRightBtn setTitleColor:[UIColor colorWithRed:168/255.0 green:168/255.0 blue:168/255.0 alpha:1] forState:UIControlStateNormal];
    [navRightBtn addTarget:self action:@selector(touchRightBar:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;

}

- (void)initialTableView {
    cartTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 1, self.view.frame.size.width, self.view.frame.size.height - 2) style:UITableViewStylePlain];
    
    cartTableView.delegate = self;
    cartTableView.dataSource = self;
    cartTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:cartTableView];
}

-(void)initialShoppingCartInfoData {
    NSDictionary *info1 = @{ @"name": @"飞行员夹克", @"type": @"女装", @"price": @"399", @"image":@"", @"shop":@"Zara", @"count": @"3", @"allSize":@[ @"S", @"M", @"L" ], @"size": @"M" };
    
    NSDictionary *info2 = @{ @"name": @"印花围巾", @"type": @"男装", @"price": @"1000", @"image":@"", @"shop":@"Nike", @"count": @"5", @"allSize":@[ @"S", @"M",@"XL", @"L" ], @"size": @"XL" };
    NSDictionary *info3 = @{ @"name": @"印花连衣裙", @"type": @"女装", @"price": @"399", @"image":@"", @"shop":@"美特斯邦威", @"count": @"3", @"allSize":@[ @"S", @"M", @"L" ], @"size": @"M" };
    NSDictionary *info4 = @{ @"name": @"Jacket", @"type": @"Ladies", @"price": @"399", @"image":@"" , @"shop":@"Zara", @"count": @"3", @"allSize":@[ @"S", @"M", @"L" ], @"size": @"M"};
    NSDictionary *info5 = @{ @"name": @"印花连衣裙", @"type": @"女装", @"price": @"399", @"image":@"", @"shop":@"美特斯邦威", @"count": @"3", @"allSize":@[ @"S", @"M", @"L" ], @"size": @"M" };
    NSDictionary *info6 = @{ @"name": @"印花连衣裙", @"type": @"女装", @"price": @"399", @"image":@"", @"shop":@"美特斯邦威", @"count": @"3", @"allSize":@[ @"S", @"M", @"L" ], @"size": @"M" };
    cartInfoArray = [[NSMutableArray alloc] initWithObjects:info1, info2, info3, info4, info5, info6, nil];
    
}

# pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cartInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[TCShoppingCartTableViewCell alloc] initWithCellHeight:cellHeight];
    }

    NSDictionary *info = cartInfoArray[indexPath.row];
    cell.imgView.backgroundColor = [UIColor grayColor];
    cell.typeAndName.text = [NSString stringWithFormat:@"%@ %@", info[@"type"], info[@"name"]];
    cell.shopName.text = info[@"shop"];
    cell.size.text = info[@"size"];
    cell.count.text = info[@"count"];
    cell.price.text = [NSString stringWithFormat:@"￥%@", info[@"price"]];
    cell.allSize = info[@"allSize"];
    
    
    cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return cell;
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


# pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"打印");
}

# pragma mark - click
- (void)touchRightBar:(id)sender {
    NSString *text = navRightBtn.titleLabel.text;
    if ([text isEqualToString:@"编辑"]) {
        [navRightBtn setTitle:@"完成" forState:UIControlStateNormal];
        cellHeight = 210;
        [cartTableView reloadData];

    } else {
        [navRightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        cellHeight = 150;
        [cartTableView reloadData];
    }
    
    
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
