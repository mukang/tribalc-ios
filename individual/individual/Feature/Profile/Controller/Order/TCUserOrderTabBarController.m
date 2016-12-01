//
//  TCOrderMainViewController.m
//  individual
//
//  Created by WYH on 16/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUserOrderTabBarController.h"

@interface TCUserOrderTabBarController () {
    UIView *selectUnderlineView;
}

@end

@implementation TCUserOrderTabBarController

- (void)viewDidAppear:(BOOL)animated {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIView *selectTabBarView = [self getSelectTabBarViewWithFrame:CGRectMake(0, 0, self.view.width, 40.5)];
    [self.view addSubview:selectTabBarView];
    
    [self addChildController:[[TCUserOrderViewController alloc] initWithMyOrderInfo:[self forgeData]] AndTitle:@"全部"];
    [self addChildController:[self getControllerWithStatus:@"等待付款"] AndTitle:@"等代付款"];
    [self addChildController:[self getControllerWithStatus:@"等待收货"] AndTitle:@"等待收货"];
    [self addChildController:[self getControllerWithStatus:@"已完成"] AndTitle:@"已完成"];
    
    self.selectedIndex = 0;
    
    
}



- (void)addChildController:(UIViewController *)childController AndTitle:(NSString *)title {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:childController];
    [navigationController.navigationBar setHidden:YES];
    childController.title = title;
    [self addChildViewController:childController];
}

- (TCUserOrderViewController *)getControllerWithStatus:(NSString *)stautsStr {
    NSArray *arr = [self forgeData];
    NSMutableArray *dataArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i++) {
        if ([arr[i][@"status"] isEqualToString:stautsStr]) {
            [dataArr addObject:arr[i]];
        }
    }
    
    TCUserOrderViewController *userOrderController = [[TCUserOrderViewController alloc] initWithMyOrderInfo:dataArr];
    return userOrderController;
}


- (UIView *)getSelectTabBarViewWithFrame:(CGRect)frame {
    UIView *selectView = [[UIView alloc] initWithFrame:frame];
    selectView.backgroundColor = [UIColor whiteColor];
    
    UIButton *allOrderBtn = [self getSelectButtonWithFrame:CGRectMake(20, 0, 0, frame.size.height) AndText:@"全部"];
    allOrderBtn.tag = 0;
    [selectView addSubview:allOrderBtn];
    selectUnderlineView = [TCComponent createGrayLineWithFrame:CGRectMake(allOrderBtn.x - 5, allOrderBtn.y + allOrderBtn.height - 1, allOrderBtn.width + 10.5, 1)];
    selectUnderlineView.backgroundColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    
    UIButton *waitPayBtn = [self getSelectButtonWithFrame:CGRectMake(allOrderBtn.origin.x + allOrderBtn.width + 76, 0, 0, frame.size.height) AndText:@"待付款"];
    waitPayBtn.tag = 1;
    [selectView addSubview:waitPayBtn];
    UIButton *waitTakeBtn = [self getSelectButtonWithFrame:CGRectMake(waitPayBtn.origin.x + waitPayBtn.width + 65, 0, 0, allOrderBtn.height) AndText:@"待收货"];
    waitTakeBtn.tag = 2;
    [selectView addSubview:waitTakeBtn];
    UIButton *completeBtn = [self getSelectButtonWithFrame:CGRectMake(waitTakeBtn.x + waitTakeBtn.width + 61, 0, 0, allOrderBtn.height) AndText:@"已完成"];
    completeBtn.tag = 3;
    [selectView addSubview:completeBtn];
    
    [selectView addSubview:selectUnderlineView];
    
    return selectView;
}

- (UIButton *)getSelectButtonWithFrame:(CGRect)frame AndText:(NSString *)text{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:BOLD_FONT size:14];
    if ([text isEqualToString:@"全部"]) {
        [button setTitleColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1] forState:UIControlStateNormal];
    } else {
        [button setTitleColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1] forState:UIControlStateNormal];
    }
    [button addTarget:self action:@selector(touchOrderSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    [button setHeight:frame.size.height];
    return button;
}

- (void)touchOrderSelectBtn:(UIButton *)button {
    
    UIView *superView = button.superview;
    for (int i = 0; i < superView.subviews.count; i++) {
        if ([superView.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *selectBtn = superView.subviews[i];
            [selectBtn setTitleColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
    
    [button setTitleColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1] forState:UIControlStateNormal];
    [selectUnderlineView setFrame:CGRectMake(button.x - 5, button.y + button.height - 1, button.width + 10.5, 1)];
    self.selectedIndex = button.tag;
    
}

- (void)initNavigationBar {
    UILabel *titleLab = [TCGetNavigationItem getTitleItemWithText:@"我的订单"];
    self.navigationItem.titleView = titleLab;
    
    UIButton *backBtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:@"back"];
    [backBtn addTarget:self action:@selector(touchBackButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)touchBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}






- (NSArray *)forgeData {
    NSDictionary *dic1 = @{
                           @"orderId":@"1350948", @"type":@"wait", @"price":@499.05, @"status":@"已完成",
                           @"content":@[
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套", @"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"},
                                             @"secondary":@{@"label":@"颜色分类", @"types":@"巧克力"}
                                             }                                     },
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套", @"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"},
                                             @"secondary":@{@"label":@"颜色分类", @"types":@"巧克力"}
                                             }
                                     }
                                   ]
                           };
    NSDictionary *dic2 = @{
                           @"orderId":@"1350948", @"type":@"wait", @"price":@499.05,@"status":@"等待付款",
                           @"content":@[
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套", @"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"},
                                             @"secondary":@{@"label":@"颜色分类", @"types":@"巧克力"}
                                             }
                                     },
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套", @"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"},
                                             @"secondary":@{@"label":@"颜色分类", @"types":@"巧克力"}
                                             }
                                     }
                                   ]
                           };
    NSDictionary *dic3 = @{
                           @"orderId":@"1350948", @"type":@"wait", @"price":@499.05,@"status":@"等待收货",
                           @"content":@[
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套",@"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"},
                                             @"secondary":@{@"label":@"颜色分类", @"types":@"巧克力"}
                                             }
                                     },
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套", @"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"}
                                             }
                                     }
                                   ]
                           };
    
    NSDictionary *dic4 = @{
                           @"orderId":@"1350948", @"type":@"wait", @"price":@499.05,@"status":@"等待收货",
                           @"content":@[
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套",@"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"},
                                             @"secondary":@{@"label":@"颜色分类", @"types":@"巧克力"}
                                             }
                                     }
                                   ]
                           };
    
    NSDictionary *dic5 = @{
                           @"orderId":@"1350948", @"type":@"wait", @"price":@499.05,@"status":@"等待收货",
                           @"content":@[
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套",@"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"},
                                             @"secondary":@{@"label":@"颜色分类", @"types":@"巧克力"}
                                             }
                                     },
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套",@"price":@488, @"count":@3,
                                     @"type":@{
                                             
                                             }
                                     },
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套",@"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"}
                                             }
                                     },
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔等我打我回到家哇靠恢复外套",@"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"},
                                             @"secondary":@{@"label":@"颜色分类", @"types":@"巧克力"}
                                             }
                                     },
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套",@"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"},
                                             @"secondary":@{@"label":@"颜色分类", @"types":@"巧克力"}
                                             }
                                     },
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套",@"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"},
                                             @"secondary":@{@"label":@"颜色分类", @"types":@"巧克力"}
                                             }
                                     }
                                   ]
                           };
    
    NSDictionary *dic6 = @{
                           @"orderId":@"1350948", @"type":@"wait", @"price":@499.05,@"status":@"等待收货",
                           @"content":@[
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套",@"price":@488, @"count":@3,
                                     @"type":@{
                                             @"primary":@{@"label":@"口味", @"types":@"蓝色"},
                                             @"secondary":@{@"label":@"颜色分类", @"types":@"巧克力"}
                                             }
                                     }
                                   ]
                           };
    
    
    NSArray *arr = [NSArray arrayWithObjects:dic1, dic2, dic3, dic4, dic5, dic6, dic3, dic4, dic5, dic6, dic1, dic4, dic5, dic6, dic3, dic4, dic1, dic6, dic1, dic4, dic5, dic1, nil];
    return arr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
