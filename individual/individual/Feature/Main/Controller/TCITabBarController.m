//
//  TCITabBarController.m
//  individual
//
//  Created by 穆康 on 2016/10/25.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCITabBarController.h"
#import "TCINavigationController.h"

@interface TCITabBarController ()

@end

@implementation TCITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildController:[[UIViewController alloc] init] title:@"首页" image:nil selectedImage:nil];
    [self addChildController:[[UIViewController alloc] init] title:@"发现" image:nil selectedImage:nil];
    [self addChildController:[[UIViewController alloc] init] title:@"附近" image:nil selectedImage:nil];
    [self addChildController:[[UIViewController alloc] init] title:@"常用" image:nil selectedImage:nil];
    [self addChildController:[[UIViewController alloc] init] title:@"我的" image:nil selectedImage:nil];
}

- (void)addChildController:(UIViewController *)childController title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selecteImage {
    
    childController.navigationItem.title = title;
    TCINavigationController *nav = [[TCINavigationController alloc] initWithRootViewController:childController];
    
    [nav.tabBarItem setTitleTextAttributes:@{
                                             NSForegroundColorAttributeName : [UIColor redColor]
                                             }
                                  forState:UIControlStateSelected];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:image];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selecteImage];
    [self addChildViewController:nav];
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
