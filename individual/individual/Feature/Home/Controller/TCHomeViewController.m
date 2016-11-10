//
//  TCHomeViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCHomeViewController.h"



@interface TCHomeViewController ()

@end

@implementation TCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *shoppingButton = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 100)/2.0, 200, 100, 40)];
    [shoppingButton setTitle:@"餐饮" forState:UIControlStateNormal];
    shoppingButton.backgroundColor = [UIColor greenColor];
    [shoppingButton addTarget:self action:@selector(goResaurantList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shoppingButton];
    
    
    UIButton *recommendBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 60)];
    [recommendBtn setTitle:@"精品推荐" forState:UIControlStateNormal];
    recommendBtn.backgroundColor = [UIColor redColor];
    [recommendBtn addTarget:self action:@selector(goRecommendShoppingList:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recommendBtn];
    
}


- (void)goRecommendShoppingList :(id)sender
{
    TCRecommendListViewController *recommend = [[TCRecommendListViewController alloc]init];
    recommend.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recommend animated:YES];
}
- (void)goResaurantList :(id)sender
{
    TCRestaurantViewController *resaurant = [[TCRestaurantViewController alloc]init];
    resaurant.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resaurant animated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
