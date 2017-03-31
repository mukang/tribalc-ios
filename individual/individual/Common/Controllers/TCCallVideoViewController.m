//
//  TCCallVideoViewController.m
//  individual
//
//  Created by 王帅锋 on 17/1/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCallVideoViewController.h"
#import "LinphoneManager.h"
#import "TCLinphoneUtils.h"
#import "TCSipAPI.h"
#import <TCCommonLibs/UIImage+Category.h>


@interface TCCallVideoViewController ()

@property (strong, nonatomic) UIView *videoView;

@end


@implementation TCCallVideoViewController

+ (instancetype)shareInstance {
    static TCCallVideoViewController *shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[TCCallVideoViewController alloc] init];
    });
    return shareInstance;
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self refuse];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"开锁";
    self.view.backgroundColor = [UIColor blackColor];
    
    // Do any additional setup after loading the view.
    _videoView = [[UIView alloc] init];
    [self.view addSubview:_videoView];
    
    @WeakObj(self)
    [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        @StrongObj(self)
        make.top.left.right.height.equalTo(self.view);
    }];
    
    UIButton *refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refuseBtn setTitle:@"挂断" forState:UIControlStateNormal];
    [refuseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:refuseBtn];
    [refuseBtn setImage:[UIImage imageNamed:@"openD"] forState:UIControlStateNormal];
    [refuseBtn addTarget:self action:@selector(refuse) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *openDoorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [openDoorBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openDoorBtn setTitle:@"开锁" forState:UIControlStateNormal];
    [self.view addSubview:openDoorBtn];
    [openDoorBtn setImage:[UIImage imageNamed:@"hangUp"] forState:UIControlStateNormal];
    [openDoorBtn addTarget:self action:@selector(open) forControlEvents:UIControlEventTouchUpInside];
    
    [refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.bottom.equalTo(self.view).offset(-35);
        make.height.equalTo(@40);
        make.width.equalTo(@60);
    }];
    
    [openDoorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.width.height.equalTo(refuseBtn);
    }];
    
    linphone_core_set_video_device(LC, "AV Capture: com.apple.avfoundation.avcapturedevice.built-in_video:1");

}

- (void)end {
    [self popToRootViewController];
}

- (void)opend {
    [self popToRootViewController];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[TCSipAPI api] close];
    });
}

- (void)popToRootViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KTCCALLINVIEWDISMISS" object:nil];
}

- (void)refuse {
    [[TCSipAPI api] close];
    
    [self popToRootViewController];

}

- (void)open {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TCOPENDOOR" object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    
    UIImage *bgImage = [UIImage imageWithColor:TCARGBColor(255, 255, 255, 0.00)];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    LinphoneManager.instance.nextCallIsTransfer = NO;
    
    linphone_core_set_native_video_window_id(LC, (__bridge void *)(_videoView));
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(opend) name:@"opend" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(end) name:@"end" object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)displayAskToEnableVideoCall:(LinphoneCall *)call {
    if (linphone_core_get_video_policy(LC)->automatically_accept)
        return;

}


- (void)dealloc {
    _videoView = nil;
    TCLog(@"TCCallVideoViewController -- dealloc");
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
