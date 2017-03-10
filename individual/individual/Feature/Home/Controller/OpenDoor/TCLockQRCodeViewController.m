//
//  TCLockQRCodeViewController.m
//  individual
//
//  Created by 穆康 on 2017/3/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLockQRCodeViewController.h"

#import "TCLockQRCodeTitleView.h"

#define navBarH     64.0

@interface TCLockQRCodeViewController ()

@property (weak, nonatomic) UINavigationBar *navBar;
@property (weak, nonatomic) UINavigationItem *navItem;

@property (weak, nonatomic) UILabel *timeLabel;
@property (weak, nonatomic) TCLockQRCodeView *QRCodeView;
@property (weak, nonatomic) TCLockQRCodeTitleView *titleView;

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
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, navBarH)];
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
        make.top.leading.bottom.trailing.equalTo(weakSelf.view);
    }];
    
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    TCLockQRCodeView *QRCodeView = [[TCLockQRCodeView alloc] initWithLockQRCodeType:self.type];
    [self.view addSubview:QRCodeView];
    self.QRCodeView = QRCodeView;
    
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(14);
        make.leading.trailing.equalTo(QRCodeView);
    }];
    [QRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(TCRealValue(329)), TCRealValue(325)));
        make.centerX.equalTo(weakSelf.view);
    }];
    
    CGFloat timeLabelTop, QRCodeViewTop;
    if (self.type == TCLockQRCodeTypeOneself) {
        timeLabelTop = navBarH + TCRealValue(46.5);
        QRCodeViewTop = navBarH + TCRealValue(69);
        
        
    } else {
        timeLabelTop = navBarH + TCRealValue(31);
        QRCodeViewTop = navBarH + TCRealValue(153.5);
        
        TCLockQRCodeTitleView *titleView = [[TCLockQRCodeTitleView alloc] init];
        [self.view addSubview:titleView];
        self.titleView = titleView;
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(TCRealValue(329), TCRealValue(90)));
            make.top.equalTo(weakSelf.view).offset(navBarH + TCRealValue(53));
            make.centerX.equalTo(weakSelf.view);
        }];
        
        titleView.deviceLabel.text = @"设备名称：一楼主门锁";
        titleView.visitorLabel.text = @"访客姓名：张晓华";
        titleView.phoneLabel.text = @"手机号：15647642113";
    }
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(timeLabelTop);
    }];
    [QRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(QRCodeViewTop);
    }];
    
    timeLabel.text = @"有效期截止：2月2日 16时30分";
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
