//
//  TCLocksAndVisitorsViewController.m
//  individual
//
//  Created by 王帅锋 on 17/3/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLocksAndVisitorsViewController.h"

@interface TCLocksAndVisitorsViewController ()

@property (assign, nonatomic) TCLocksOrVisitors locksOrVisitors;

@end

@implementation TCLocksAndVisitorsViewController

- (instancetype)initWithType:(TCLocksOrVisitors)locksOrVisitors {
    if (self = [super init]) {
        _locksOrVisitors = locksOrVisitors;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hideOriginalNavBar = YES;
}

- (void)setUpViews {
    
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
