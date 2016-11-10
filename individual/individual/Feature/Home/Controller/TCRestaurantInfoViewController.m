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
    UIImageView *barImageView;
    NSDictionary *restaurantInfoDic;
}

@end

@implementation TCRestaurantInfoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    mScrollView.delegate = self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    [self initNavigationBar];

    [self initRestaurantInfo];
    
    [self initBaseData];
    
    
}

- (UIView *)createRoundWithFrame:(CGRect)frame AndTitle:(NSString *)text {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    
    return view;
}

- (void)initNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    barImageView = self.navigationController.navigationBar.subviews.firstObject;
    barImageView.backgroundColor = [UIColor whiteColor];
    barImageView.alpha = 0;
    
}

- (void)initRestaurantInfo {
    restaurantInfoDic = @{
                          @"img":@"", @"name":@"FNRON", @"type":@"披萨", @"location":@"北苑", @"range":@"6.5km",
                          @"price":@"169", @"collection":@"166653", @"address":@"北京市朝阳区北苑大姐大小区", @"phone":@"1800000000", @"recommend":@"等我打我对哇大无缝五福娃福娃福娃福娃福娃服务费瓦发五福娃福娃福娃福娃发我发完福娃福娃福娃发五福娃", @"topic":@"对哇嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒点点滴滴嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒嘀嗒多大的对的", @"wifi":@true, @"time":@"11:00-23:00", @"reserve":@true, @"room":@true
                          };
    
}


- (void)initBaseData {
    
    mScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mScrollView.contentSize = CGSizeMake(mScrollView.frame.size.width, mScrollView.size.height + 200);
    [self.view addSubview:mScrollView];
    
    
    UIImage *restaurantInfoLogoImage = [UIImage imageNamed:@"restaurantInfoLogo"];
    restaurantInfoLogoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 270)];
    restaurantInfoLogoImageView.image = restaurantInfoLogoImage;
    restaurantInfoLogoImageView.backgroundColor = [UIColor lightGrayColor];
    [mScrollView addSubview:restaurantInfoLogoImageView];
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    mScrollView.delegate = nil;
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    barImageView.alpha = 1.0;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat minAlphaOffset = - 64;
    CGFloat maxAlphaOffset = 270;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    barImageView.alpha = alpha;
    
    
    CGPoint point = scrollView.contentOffset;
    if (point.y < -64) {
        double number = 1 + (-64 - point.y) / 220;
        double width = self.view.frame.size.width * number;
        double height = 270 * number;
        [restaurantInfoLogoImageView setFrame:CGRectMake(self.view.frame.size.width / 2 - width / 2, point.y, width, height)];
    }
}

@end
