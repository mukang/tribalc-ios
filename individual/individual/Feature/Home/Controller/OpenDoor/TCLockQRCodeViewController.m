//
//  TCLockQRCodeViewController.m
//  individual
//
//  Created by 穆康 on 2017/3/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLockQRCodeViewController.h"

@interface TCLockQRCodeViewController ()

@property (weak, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) UINavigationItem *navItem;

@end

@implementation TCLockQRCodeViewController {
    __weak TCLockQRCodeViewController *weakSelf;
}

- (instancetype)initWithLockQRCodeType:(TCLockQRCodeType)type {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        weakSelf = self;
        _type = type;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavBar];
    [self setupSubviews];
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64.0)];
    [navBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [navBar setBackgroundImage:[UIImage imageNamed:@"TransparentPixel"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:navBar];
    
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
    UIImage *backImage = [[UIImage imageNamed:@"nav_back_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickBackButton:)];
    [navBar setItems:@[navItem]];
    
    self.navBar = navBar;
    self.navItem = navItem;
}

- (void)setupSubviews {
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"lock_QR_code_bg"];
    [self.view insertSubview:bgImageView belowSubview:self.navBar];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(weakSelf.view);
    }];
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
