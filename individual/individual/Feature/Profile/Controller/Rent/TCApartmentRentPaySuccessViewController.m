//
//  TCApartmentRentPaySuccessViewController.m
//  individual
//
//  Created by 穆康 on 2017/6/30.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCApartmentRentPaySuccessViewController.h"
#import <YYText.h>
#import <TCCommonLibs/TCCommonButton.h>

@interface TCApartmentRentPaySuccessViewController ()

@end

@implementation TCApartmentRentPaySuccessViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"缴费";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apartment_rent_pay_success"]];
    [self.view addSubview:imageView];
    
    NSString *partStr = @"全部付款计划";
    NSString *totalStr = [NSString stringWithFormat:@"恭喜，第%zd期房租已缴纳成功，可在%@/n中进行查看", self.payCycle, partStr];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [attText setAttributes:@{
                             NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(12.5)],
                             NSForegroundColorAttributeName: TCGrayColor
                             }
                     range:NSMakeRange(0, totalStr.length)];
    YYTextHighlight *highlight = [YYTextHighlight highlightWithAttributes:@{
                                                                            NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(12.5)],
                                                                            NSForegroundColorAttributeName: TCRGBColor(74, 119, 250),
                                                                            NSUnderlineStyleAttributeName: @(1)
                                                                            }];
    highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [self handleClickPayPlan];
    };
    [attText yy_setTextHighlight:highlight range:[totalStr rangeOfString:partStr]];
    
    YYLabel *label = [[YYLabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.attributedText = attText;
    [self.view addSubview:label];
    
    TCCommonButton *backButton = [TCCommonButton buttonWithTitle:@"返  回" target:self action:@selector(handleClickBackButton:)];
    [self.view addSubview:backButton];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(84.5), TCRealValue(87.5)));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(TCRealValue(159.5));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(TCRealValue(27));
        make.centerX.equalTo(self.view);
    }];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(161), TCRealValue(40)));
        make.top.equalTo(label.mas_bottom).offset(TCRealValue(95));
        make.centerX.equalTo(self.view);
    }];
}

- (void)handleClickPayPlan {
    
}

- (void)handleClickBackButton:(id)sender {
    if (self.paySuccess) {
        self.paySuccess();
    }
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
