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
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"callInBg"];
    [self.view addSubview:imageView];
    
    UIImageView *person = [[UIImageView alloc] init];
    person.image = [UIImage imageNamed:@""];
    [self.view addSubview:person];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"您有客人来访，是否接听！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    UIButton *hangUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:hangUpBtn];
    [hangUpBtn addTarget:self action:@selector(refuse) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *hangUpImage = [[UIImageView alloc] init];
    hangUpImage.image = [UIImage imageNamed:@"callInHangUp"];
    [hangUpBtn addSubview:hangUpImage];
    
    UILabel *hangUpLabel = [[UILabel alloc] init];
    hangUpLabel.textAlignment = NSTextAlignmentCenter;
    hangUpLabel.textColor = [UIColor whiteColor];
    hangUpLabel.text = @"拒绝";
    [hangUpBtn addSubview:hangUpLabel];
    
    UIButton *holdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:holdBtn];
    [holdBtn addTarget:self action:@selector(accept) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *holdImage = [[UIImageView alloc] init];
    holdImage.image = [UIImage imageNamed:@"callInHold"];
    [holdBtn addSubview:holdImage];
    
    UILabel *holdLabel = [[UILabel alloc] init];
    holdLabel.textAlignment = NSTextAlignmentCenter;
    holdLabel.textColor = [UIColor whiteColor];
    holdLabel.text = @"接听";
    [holdBtn addSubview:holdLabel];
    
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [hangUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(TCRealValue(60));
        make.bottom.equalTo(self.view).offset(-TCRealValue(50));
        make.height.equalTo(@(TCRealValue(95)));
        make.width.equalTo(@(TCRealValue(65)));
    }];
    
    [hangUpImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(hangUpBtn);
        make.height.equalTo(@(hangUpBtn.width));
    }];
    
    [hangUpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hangUpImage.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(hangUpBtn);
    }];
    
    [holdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.width.height.equalTo(hangUpBtn);
        make.right.equalTo(self.view).offset(-TCRealValue(60));
    }];
    
    [holdImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(holdBtn);
        make.height.equalTo(@(holdBtn.width));
    }];
    
    [holdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(holdImage.mas_bottom).offset(10);
        make.left.right.bottom.equalTo(holdBtn);
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
