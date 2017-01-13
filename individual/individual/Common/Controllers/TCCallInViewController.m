//
//  TCCallInViewController.m
//  individual
//
//  Created by 王帅锋 on 17/1/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCallInViewController.h"
#import <Masonry.h>


@interface TCCallInViewController ()

@end

@implementation TCCallInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refuseBtn setTitle:@"挂断" forState:UIControlStateNormal];
    [refuseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:refuseBtn];
    [refuseBtn addTarget:self action:@selector(refuse) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *acceptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [acceptBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [acceptBtn setTitle:@"接听" forState:UIControlStateNormal];
    [self.view addSubview:acceptBtn];
    [acceptBtn addTarget:self action:@selector(accept) forControlEvents:UIControlEventTouchUpInside];
    
    [refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(@200);
        make.height.equalTo(@40);
        make.right.equalTo(acceptBtn.mas_left);
        make.width.equalTo(self.view).multipliedBy(0.5);
    }];
    
    [acceptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(refuseBtn);
        make.left.equalTo(refuseBtn.mas_right);
        make.right.equalTo(self.view);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(end) name:@"end" object:nil];
}

- (void)end {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)refuse {
    [self.navigationController popToRootViewControllerAnimated:YES];
    linphone_core_terminate_call(LC, _call);
}

- (void)accept {
    [LinphoneManager.instance acceptCall:_call evenWithVideo:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _call = NULL;
}

- (void)dealloc {
    
    TCLog(@"TCCallInViewController -- dealloc");
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
