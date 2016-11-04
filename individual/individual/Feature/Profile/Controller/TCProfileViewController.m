//
//  TCProfileViewController.m
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCProfileViewController.h"
#import "TCLoginViewController.h"
#import "TCBiographyViewController.h"

#import "UIImage+Category.h"

@interface TCProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

- (void)setupNavBar {
    
    UIImage *bgImage = [UIImage imageWithColor:TCRGBColor(42, 42, 42)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName : [UIFont systemFontOfSize:16],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                    };
}

- (void)setupSubviews {
//    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    [self.view addSubview:tableView];
//    self.tableView = tableView;
}

- (IBAction)handleTapLoginButton:(UIButton *)sender {
    
    TCLoginViewController *loginVC = [[TCLoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (IBAction)handleTaoBiographyButton:(UIButton *)sender {
    TCBiographyViewController *vc = [[TCBiographyViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
