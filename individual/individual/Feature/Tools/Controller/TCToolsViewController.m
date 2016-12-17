//
//  TCToolsViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCToolsViewController.h"
#import "TCRepairsViewController.h"

#import "UIImage+Category.h"
#import "TCBuluoApi.h"
#import "TCPropertyManageListController.h"
#import "TCLoginViewController.h"

@interface TCToolsViewController ()

@end

@implementation TCToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavBar];
    [self setUpViews];
}

- (void)setupNavBar {
    self.navigationItem.title = @"常用";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName : [UIFont systemFontOfSize:16],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor]
                                                                    };
    UIImage *bgImage = [UIImage imageWithColor:TCRGBColor(42, 42, 42)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile_nav_QRcode_item"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickQRCodeButton:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)handleClickQRCodeButton:(UIBarButtonItem *)sender {
    TCLog(@"点击了扫码按钮");
}

- (void)setUpViews {
    CGFloat screenW =[UIScreen mainScreen].bounds.size.width;
    CGFloat scale = screenW/375.0;
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenW, scale*251.5)];
    [self.view addSubview:topImageView];
    topImageView.image = [UIImage imageNamed:@"downImage.jpg"];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake((screenW-220.0)/2, CGRectGetMaxY(topImageView.frame), 220, scale*45)];
    [self.view addSubview:v];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, v.frame.size.height/2, 65, 0.5)];
    leftLine.backgroundColor = [UIColor blackColor];
    [v addSubview:leftLine];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 80, v.frame.size.height)];
    label.text = @"办公地带";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor blackColor];
    [v addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(151, leftLine.frame.origin.y, 65, 0.5)];
    rightLine.backgroundColor = [UIColor blackColor];
    [v addSubview:rightLine];
    
    UIImageView *downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(v.frame), screenW, 256*scale)];
    [self.view addSubview:downImageView];
    downImageView.userInteractionEnabled = YES;
    downImageView.image = [UIImage imageNamed:@"downImage.jpg"];
    
    UIImage *openImage = [UIImage imageNamed:@"openDoor"];
    UIImage *propertyImage = [UIImage imageNamed:@"property"];
    UIImageView *openDoor = [[UIImageView alloc] initWithFrame:CGRectMake(45*scale, 45*scale, openImage.size.width, openImage.size.height)];
    openDoor.image = openImage;
    [downImageView addSubview:openDoor];
    
    UILabel *openLabel = [[UILabel alloc] initWithFrame:CGRectMake(openDoor.frame.origin.x, CGRectGetMaxY(openDoor.frame), openDoor.frame.size.width, 30)];
    openLabel.text = @"手机开门";
    openLabel.textColor = [UIColor whiteColor];
    [downImageView addSubview:openLabel];
    
    UIView *middleView = [[UIView alloc] initWithFrame:CGRectMake(screenW/2, 20, 0.5, 185.0*scale)];
    middleView.backgroundColor = [UIColor whiteColor];
    [downImageView addSubview:middleView];
    
    UIImageView *property = [[UIImageView alloc] initWithFrame:CGRectMake(screenW-45*scale-propertyImage.size.width, 45*scale, propertyImage.size.width, propertyImage.size.height)];
    property.userInteractionEnabled = YES;
    property.image = propertyImage;
    [downImageView addSubview:property];
    
    UILabel *propertyLabel = [[UILabel alloc] initWithFrame:CGRectMake(property.frame.origin.x, CGRectGetMaxY(property.frame), property.frame.size.width, 30)];
    propertyLabel.text = @"物业报修";
    propertyLabel.textColor = [UIColor whiteColor];
    [downImageView addSubview:propertyLabel];
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(propertyTap)];
    [property addGestureRecognizer:tapG];
}

- (void)propertyTap {
    if ([self checkUserNeedLogin]) return;
    TCPropertyManageListController *propertyList = [[TCPropertyManageListController alloc] init];
    propertyList.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:propertyList animated:YES];
}

- (BOOL)checkUserNeedLogin {
    if ([[TCBuluoApi api] needLogin]) {
        [self showLoginViewController];
    }
    return [[TCBuluoApi api] needLogin];
}

- (void)showLoginViewController {
    TCLoginViewController *vc = [[TCLoginViewController alloc] initWithNibName:@"TCLoginViewController" bundle:[NSBundle mainBundle]];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (IBAction)handleClickRepairsButton:(id)sender {
    TCRepairsViewController *vc = [[TCRepairsViewController alloc] initWithNibName:@"TCRepairsViewController" bundle:[NSBundle mainBundle]];
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
