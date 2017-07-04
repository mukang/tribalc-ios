//
//  TCCheckPwdViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/7/2.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCheckPwdViewController.h"
#import "TCRentProtocol.h"

@interface TCCheckPwdViewController ()

@property (strong, nonatomic) UIView *bgView;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) UILabel *apartmentNumLabel;

@property (strong, nonatomic) UILabel *apartmentTitleLabel;

@property (strong, nonatomic) UILabel *apartmentNameLabel;

@property (strong, nonatomic) UIImageView *downImageView;

@property (strong, nonatomic) UILabel *pwdLabel;

@end

@implementation TCCheckPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCRGBColor(224, 248, 253);
    [self setUpViews];
}

- (void)setUpViews {
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.apartmentNumLabel];
    [self.view addSubview:self.apartmentTitleLabel];
    [self.view addSubview:self.apartmentNameLabel];
    [self.view addSubview:self.downImageView];
    [self.view addSubview:self.pwdLabel];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(10);
        make.right.bottom.equalTo(self.view).offset(-10);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(TCRealValue(64));
        make.width.equalTo(@(TCRealValue(270)));
        make.height.equalTo(@(TCRealValue(230)));
    }];
    
    [self.apartmentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(50);
        make.top.equalTo(self.imageView.mas_bottom).offset(TCRealValue(55));
        make.height.equalTo(@(TCRealValue(15)));
    }];
    
    [self.apartmentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.apartmentNumLabel);
        make.top.equalTo(self.apartmentNumLabel.mas_bottom).offset(5);
    }];
    
    [self.apartmentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.apartmentTitleLabel.mas_right);
        make.top.equalTo(self.apartmentTitleLabel);
        make.right.equalTo(self.view).offset(-50);
    }];
    
    [self.downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.apartmentNameLabel.mas_bottom).offset(TCRealValue(27));
    }];
    
    [self.pwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view).offset(TCRealValue(20));
        make.centerY.equalTo(self.downImageView);
    }];
}

- (UILabel *)pwdLabel {
    if (_pwdLabel == nil) {
        _pwdLabel = [[UILabel alloc] init];
        _pwdLabel.font = [UIFont systemFontOfSize:16];
        _pwdLabel.textColor = TCBlackColor;
        _pwdLabel.text = [NSString stringWithFormat:@"公寓密码：%@",@"1234567890"];
    }
    return _pwdLabel;
}

- (UIImageView *)downImageView {
    if (_downImageView == nil) {
        _downImageView = [[UIImageView alloc] init];
        _downImageView.image = [UIImage imageNamed:@"checkPwdDownImage"];
    }
    return _downImageView;
}

- (UILabel *)apartmentNameLabel {
    if (_apartmentNameLabel == nil) {
        _apartmentNameLabel = [[UILabel alloc] init];
        _apartmentNameLabel.textColor = TCGrayColor;
        _apartmentNameLabel.font = [UIFont systemFontOfSize:12];
        _apartmentNameLabel.numberOfLines = 0;
        _apartmentNameLabel.text = self.rentProtocol.sourceName;
    }
    return _apartmentNameLabel;
}

- (UILabel *)apartmentTitleLabel {
    if (_apartmentTitleLabel == nil) {
        _apartmentTitleLabel = [[UILabel alloc] init];
        _apartmentTitleLabel.textColor = TCGrayColor;
        _apartmentTitleLabel.font = [UIFont systemFontOfSize:12];
        _apartmentTitleLabel.text = @"公寓：";
        [_apartmentTitleLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _apartmentTitleLabel;
}

- (UILabel *)apartmentNumLabel {
    if (_apartmentNumLabel == nil) {
        _apartmentNumLabel = [[UILabel alloc] init];
        _apartmentNumLabel.textColor = TCGrayColor;
        _apartmentNumLabel.font = [UIFont systemFontOfSize:12];
        _apartmentNumLabel.text = [NSString stringWithFormat:@"编号：%@",self.rentProtocol.sourceNum];
    }
    return _apartmentNumLabel;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"checkPwdTopImage"];
    }
    return _imageView;
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 5.0;
        _bgView.clipsToBounds = YES;
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
