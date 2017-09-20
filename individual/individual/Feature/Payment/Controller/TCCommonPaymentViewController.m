//
//  TCCommonPaymentViewController.m
//  individual
//
//  Created by 穆康 on 2017/9/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommonPaymentViewController.h"

@interface TCCommonPaymentViewController ()

@end

@implementation TCCommonPaymentViewController {
    __weak TCCommonPaymentViewController *weakSelf;
}

- (instancetype)initWithPaymentMode:(TCCommonPaymentMode)paymentMode {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _paymentMode = paymentMode;
        weakSelf = self;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"TCCommonPaymentViewController初始化错误"
                                   reason:@"请使用接口文件提供的初始化方法"
                                 userInfo:nil];
    return nil;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavBar];
    [self setupSubviews];
}

#pragma mark - Setup UI

- (void)setupNavBar {
    NSString *title = nil;
    switch (self.paymentMode) {
        case TCCommonPaymentModeRecharge:
            title = @"余额充值";
            break;
        case TCCommonPaymentModeRepayment:
            title = @"授信还款";
            break;
        case TCCommonPaymentModeCompanyRepayment:
            title = @"企业还款";
            break;
            
        default:
            break;
    }
}

- (void)setupSubviews {
    
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
