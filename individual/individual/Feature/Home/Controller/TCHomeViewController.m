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
    
    self.view.frame = [UIScreen mainScreen].bounds;
    
    UIButton *shopButton = [self createButtonWithFrame:CGRectMake(0, 100, self.view.width, 100) AndText:@"餐厅" AndAction:@selector(goResaurantList:)];
    [self.view addSubview:shopButton];
    
    UIButton *recommendBtn = [self createButtonWithFrame:CGRectMake(0, 0, self.view.width, 100) AndText:@"精品推荐" AndAction:@selector(goRecommendShoppingList:)];
    [self.view addSubview:recommendBtn];
    
    UIButton *entertainmentBtn = [self createButtonWithFrame:CGRectMake(0, 200, self.view.width, 100) AndText:@"娱乐" AndAction:@selector(goentertainmentList:)];
    [self.view addSubview:entertainmentBtn];
    
}

- (UIButton *)createButtonWithFrame:(CGRect)frame AndText:(NSString *)text AndAction:(SEL)action{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:text forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    return button;
}

- (void)goentertainmentList:(id)sender {
    TCRestaurantViewController *resaurant = [[TCRestaurantViewController alloc]init];
    resaurant.title = @"娱乐";
    resaurant.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:resaurant animated:YES];
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
    resaurant.title = @"餐饮";
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
