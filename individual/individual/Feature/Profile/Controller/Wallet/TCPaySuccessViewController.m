//
//  TCPaySuccessViewController.m
//  individual
//
//  Created by 穆康 on 2017/6/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPaySuccessViewController.h"
#import "TCNavigationController.h"

#import <TCCommonLibs/TCCommonButton.h>

@interface TCPaySuccessViewController ()

@property (nonatomic) BOOL originalInteractivePopGestureEnabled;

@end

@implementation TCPaySuccessViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"交易详情";
    
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.fromController) {
        TCNavigationController *nav = (TCNavigationController *)self.navigationController;
        self.originalInteractivePopGestureEnabled = nav.enableInteractivePopGesture;
        nav.enableInteractivePopGesture = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.fromController) {
        TCNavigationController *nav = (TCNavigationController *)self.fromController.navigationController;
        nav.enableInteractivePopGesture = self.originalInteractivePopGestureEnabled;
    }
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"支付成功";
    titleLabel.textColor = TCBlackColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    UIImageView *successImageView = [[UIImageView alloc] init];
    successImageView.image = [UIImage imageNamed:@"payment_success_icon"];
    [self.view addSubview:successImageView];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.layer.borderColor = TCSeparatorLineColor.CGColor;
    containerView.layer.borderWidth = 0.5;
    containerView.layer.cornerRadius = 2.5;
    [self.view addSubview:containerView];
    
    NSString *str = [NSString stringWithFormat:@"收款人 %@", self.storeName];
    NSRange nameRange = [str rangeOfString:self.storeName];
    NSRange titleRange = NSMakeRange(0, str.length - nameRange.length);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttributes:@{
                            NSFontAttributeName: [UIFont systemFontOfSize:16],
                            NSForegroundColorAttributeName: TCGrayColor
                            }
                    range:titleRange];
    [attStr addAttributes:@{
                            NSFontAttributeName: [UIFont systemFontOfSize:16],
                            NSForegroundColorAttributeName: TCBlackColor
                            }
                    range:nameRange];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.attributedText = attStr;
    [containerView addSubview:nameLabel];
    
    UILabel *totalFeeLabel = [[UILabel alloc] init];
    totalFeeLabel.text = [NSString stringWithFormat:@"¥ %0.2f", self.totalAmount];
    totalFeeLabel.textColor = TCBlackColor;
    totalFeeLabel.textAlignment = NSTextAlignmentCenter;
    totalFeeLabel.font = [UIFont boldSystemFontOfSize:30];
    [containerView addSubview:totalFeeLabel];
    
    TCCommonButton *completionButton = [TCCommonButton buttonWithTitle:@"完  成" target:self action:@selector(handleClickCompletionButton:)];
    [self.view addSubview:completionButton];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(31);
        make.centerX.equalTo(self.view);
    }];
    [successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70.5, 70.5));
        make.top.equalTo(self.view).offset(80);
        make.centerX.equalTo(self.view);
    }];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(163);
        make.left.equalTo(self.view).offset(17);
        make.right.equalTo(self.view).offset(-17);
        make.height.mas_equalTo(108);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(20);
        make.left.right.equalTo(containerView);
    }];
    [totalFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(containerView).offset(-22);
        make.left.right.equalTo(containerView);
    }];
    [completionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(315), 40));
        make.top.equalTo(containerView.mas_bottom).offset(36);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - Actions

- (void)handleClickCompletionButton:(id)sender {
    [self back];
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self back];
}

- (void)back {
    if (self.fromController) {
        [self.navigationController popToViewController:self.fromController animated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
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
