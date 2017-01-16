//
//  TCToolsViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCToolsViewController.h"
#import "TCRepairsViewController.h"
#import "TCNavigationController.h"

#import "UIImage+Category.h"
#import "TCBuluoApi.h"
#import "TCPropertyManageListController.h"
#import "TCLoginViewController.h"
#import "TCQRCodeViewController.h"
#import "TCOpenDoorController.h"
#import "masonry.h"

#import "TCBlurImageView.h"

@interface TCToolsViewController ()
@property (nonatomic, strong) UIImageView *imageV;

@property (nonatomic, strong) TCBlurImageView *blurImageView;

@end

@implementation TCToolsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavBar];
    [self setUpViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setupNavBar {
    self.navigationItem.title = @"常用";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"profile_nav_QRcode_item"]
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(handleClickQRCodeButton:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)handleClickQRCodeButton:(UIBarButtonItem *)sender {
    TCLog(@"点击了扫码按钮");
    TCQRCodeViewController *qrVc = [[TCQRCodeViewController  alloc] init];
    qrVc.hidesBottomBarWhenPushed = YES;
    qrVc.completion = ^{
        [MBProgressHUD showHUDWithMessage:@"此功能暂未开放，敬请期待！"];
        [self.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:qrVc animated:YES];
}

- (void)setUpViews {
    CGFloat screenW =[UIScreen mainScreen].bounds.size.width;
    CGFloat scale = screenW/375.0;
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenW, scale*253)];
    [self.view addSubview:topImageView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"downImage01" ofType:@"jpg"];
    topImageView.image = [UIImage imageWithContentsOfFile:path];
    
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
    openDoor.userInteractionEnabled = YES;
    [downImageView addSubview:openDoor];
    
    UITapGestureRecognizer *openDoorG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openDoor)];
    [openDoor addGestureRecognizer:openDoorG];
    
    UILabel *openLabel = [[UILabel alloc] initWithFrame:CGRectMake(openDoor.frame.origin.x, CGRectGetMaxY(openDoor.frame), openDoor.frame.size.width, 30)];
    openLabel.text = @"手机开门";
    openLabel.textColor = [UIColor whiteColor];
    openLabel.textAlignment = NSTextAlignmentCenter;
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
    propertyLabel.textAlignment = NSTextAlignmentCenter;
    [downImageView addSubview:propertyLabel];
    
    UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(propertyTap)];
    [property addGestureRecognizer:tapG];
}

- (void)openDoor {
    if ([self checkUserNeedLogin]) return;
    
    if (![[TCBuluoApi api] currentUserSession].userInfo.companyID) {
        [MBProgressHUD showHUDWithMessage:@"绑定公司成功后才可使用开门功能"];
        return;
    }
    
    if (_blurImageView == nil) {
        _blurImageView = [[TCBlurImageView alloc] initWithController:self.navigationController endBlock:^{
            _blurImageView = nil;
        }];
    }
    [_blurImageView show];
}

- (void)propertyTap {
    if ([self checkUserNeedLogin]) return;
    TCRepairsViewController *vc = [[TCRepairsViewController alloc] initWithNibName:@"TCRepairsViewController" bundle:[NSBundle mainBundle]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (BOOL)checkUserNeedLogin {
    if ([[TCBuluoApi api] needLogin]) {
        [self showLoginViewController];
    }
    return [[TCBuluoApi api] needLogin];
}

- (void)showLoginViewController {
    TCLoginViewController *vc = [[TCLoginViewController alloc] initWithNibName:@"TCLoginViewController" bundle:[NSBundle mainBundle]];
    TCNavigationController *nav = [[TCNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
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
