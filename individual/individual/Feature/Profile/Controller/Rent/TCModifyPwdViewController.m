//
//  TCModifyPwdViewController.m
//  individual
//
//  Created by 王帅锋 on 2017/6/30.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCModifyPwdViewController.h"
#import "TCRentProtocol.h"
#import "TCNumberTextField.h"
#import <TCCommonLibs/TCCommonButton.h>
#import "TCBuluoApi.h"

#define kLineColor TCRGBColor(221, 221, 221)
#define kScale ([UIScreen mainScreen].bounds.size.width > 375 ? 3.0 : 2.0)

@interface TCModifyPwdViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) UIView *topView;

@property (strong, nonatomic) UILabel *apartmentNumLabel;

@property (strong, nonatomic) UIView *lineView1;

@property (strong, nonatomic) UILabel *apartmentNameTitle;

@property (strong, nonatomic) UILabel *apartmentNameLabel;

@property (strong, nonatomic) UIView *downView;

@property (strong, nonatomic) UIView *lineView2;

@property (strong, nonatomic) UILabel *pwdLabel;

@property (strong, nonatomic) TCNumberTextField *pwdTextField;

@property (strong, nonatomic) UIView *lineView3;

@property (strong, nonatomic) UILabel *mutiPwdLabel;

@property (strong, nonatomic) TCNumberTextField *mutiPwdTextField;

@property (strong, nonatomic) UIView *lineView4;

@property (strong, nonatomic) TCCommonButton *modifyBtn;

@property (strong, nonatomic) UIView *lineView5;

@property (strong, nonatomic) TCRentProtocol *rentProtocol;

@end

@implementation TCModifyPwdViewController

- (instancetype)initWithRentProtocol:(TCRentProtocol *)rentProtocol {
    if (self = [super init]) {
        self.rentProtocol = rentProtocol;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TCBackgroundColor;
    [self setUpSubViews];
}

#pragma mark UITextFieldDelegate



- (void)setUpSubViews {
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.downView];
    
    [self.topView addSubview:self.apartmentNumLabel];
    [self.topView addSubview:self.lineView1];
    [self.topView addSubview:self.apartmentNameTitle];
    [self.topView addSubview:self.apartmentNameLabel];
    
    [self.downView addSubview:self.lineView2];
    [self.downView addSubview:self.pwdLabel];
    [self.downView addSubview:self.pwdTextField];
    [self.downView addSubview:self.lineView3];
    [self.downView addSubview:self.mutiPwdLabel];
    [self.downView addSubview:self.mutiPwdTextField];
    [self.downView addSubview:self.lineView4];
    [self.downView addSubview:self.modifyBtn];
    [self.downView addSubview:self.lineView5];
    
    [self.apartmentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView);
        make.left.equalTo(self.topView).offset(20);
        make.right.equalTo(self.topView).offset(-20);
        make.height.equalTo(@(TCRealValue(30)));
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.apartmentNumLabel);
        make.top.equalTo(self.apartmentNumLabel.mas_bottom);
        make.right.equalTo(self.topView);
        make.height.equalTo(@(1/kScale));
    }];
    
    [self.apartmentNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.apartmentNumLabel);
        make.top.equalTo(self.lineView1.mas_bottom);
        make.height.equalTo(@(TCRealValue(40)));
        make.width.equalTo(@45);
    }];
    
    CGRect rect = [self.apartmentNameLabel.text boundingRectWithSize:CGSizeMake(TCScreenWidth-40-45, 9999.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    
    [self.apartmentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.apartmentNameTitle.mas_right);
        make.top.equalTo(self.apartmentNameTitle);
        make.right.equalTo(self.topView).offset(-20);
        make.height.equalTo(@(rect.size.height >= 20 ? (rect.size.height + 15.0) : TCRealValue(40)));
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.apartmentNameLabel);
    }];
    
    [self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom).offset(TCRealValue(8));
        make.height.equalTo(@(TCRealValue(200)));
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.downView);
        make.height.equalTo(@(1/kScale));
    }];
    
    [self.pwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView2.mas_bottom);
        make.left.equalTo(self.downView).offset(20);
        make.height.equalTo(@(TCRealValue(40)));
    }];
    
    [self.pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pwdLabel.mas_right);
        make.top.height.equalTo(self.pwdLabel);
        make.right.equalTo(self.downView).offset(-20);
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downView).offset(20);
        make.top.equalTo(self.pwdLabel.mas_bottom);
        make.right.equalTo(self.downView).offset(-20);
        make.height.equalTo(@(1/kScale));
    }];
    
    [self.mutiPwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.pwdLabel);
        make.top.equalTo(self.lineView3.mas_bottom);
    }];
    
    [self.mutiPwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.mutiPwdLabel);
        make.right.equalTo(self.downView).offset(-20);
        make.left.equalTo(self.mutiPwdLabel.mas_right);
    }];
    
    [self.lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.lineView3);
        make.top.equalTo(self.mutiPwdLabel.mas_bottom);
    }];
    
    [self.modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downView).offset(30);
        make.right.equalTo(self.downView).offset(-30);
        make.height.equalTo(@(TCRealValue(40)));
        make.top.equalTo(self.lineView4.mas_bottom).offset(TCRealValue(42));
    }];
    
    [self.lineView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.downView);
        make.height.equalTo(self.lineView4);
    }];
    
}

- (void)modify {
    
    [self.view endEditing:YES];
    
    if (self.pwdTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入新密码" afterDelay:1.0];
        return;
    }
    
    if (self.mutiPwdTextField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入重复新密码" afterDelay:1.0];
        return;
    }
    
    if (self.pwdTextField.text.length > 10 || self.pwdTextField.text.length < 6) {
        [MBProgressHUD showHUDWithMessage:@"请输入6到10位密码" afterDelay:1.0];
        [self.pwdTextField becomeFirstResponder];
        return;
    }
    
    if (![self.pwdTextField.text isEqualToString:self.mutiPwdTextField.text]) {
        [MBProgressHUD showHUDWithMessage:@"新密码和重复新密码不一样" afterDelay:1.0];
        return;
    }
    @WeakObj(self)
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] createSmartLockPasswordWithSN:self.rentProtocol.sn sourceId:self.rentProtocol.sourceId password:self.pwdTextField.text result:^(BOOL success, NSError *error) {
        @StrongObj(self)
        if (success) {
            [MBProgressHUD showHUDWithMessage:@"修改成功" afterDelay:1.0];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"修改失败，%@", reason]];
        }
    }];
    
}

- (UIView *)lineView5 {
    if (_lineView5 == nil) {
        _lineView5 = [[UIView alloc] init];
        _lineView5.backgroundColor = kLineColor;
    }
    return _lineView5;
}

- (TCCommonButton *)modifyBtn {
    if (_modifyBtn == nil) {
        _modifyBtn = [TCCommonButton buttonWithTitle:@"确认修改" target:self action:@selector(modify)];
    }
    return _modifyBtn;
}

- (UIView *)lineView4 {
    if (_lineView4 == nil) {
        _lineView4 = [[UIView alloc] init];
        _lineView4.backgroundColor = kLineColor;
    }
    return _lineView4;
}

- (TCNumberTextField *)mutiPwdTextField {
    if (_mutiPwdTextField == nil) {
        _mutiPwdTextField = [[TCNumberTextField alloc] init];
        _mutiPwdTextField.font = [UIFont systemFontOfSize:14];
        _mutiPwdTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _mutiPwdTextField;
}

- (UILabel *)mutiPwdLabel {
    if (_mutiPwdLabel == nil) {
        _mutiPwdLabel = [[UILabel alloc] init];
        _mutiPwdLabel.textColor = TCBlackColor;
        _mutiPwdLabel.text = @"重复新密码：";
        _mutiPwdLabel.font = [UIFont systemFontOfSize:14];
        [_mutiPwdLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _mutiPwdLabel;
}

- (UIView *)lineView3 {
    if (_lineView3 == nil) {
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = kLineColor;
    }
    return _lineView3;
}

- (TCNumberTextField *)pwdTextField {
    if (_pwdTextField == nil) {
        _pwdTextField = [[TCNumberTextField alloc] init];
        _pwdTextField.font = [UIFont systemFontOfSize:14];
        _pwdTextField.keyboardType = UIKeyboardTypeNumberPad;
        _pwdTextField.delegate = self;
    }
    return _pwdTextField;
}

- (UILabel *)pwdLabel {
    if (_pwdLabel == nil) {
        _pwdLabel = [[UILabel alloc] init];
        _pwdLabel.text = @"新密码：";
        _pwdLabel.textColor = TCBlackColor;
        _pwdLabel.font = [UIFont systemFontOfSize:14];
        [_pwdLabel setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _pwdLabel;
}

- (UIView *)lineView2 {
    if (_lineView2 == nil) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = kLineColor;
    }
    return _lineView2;
}

- (UILabel *)apartmentNameLabel {
    if (_apartmentNameLabel == nil) {
        _apartmentNameLabel = [[UILabel alloc] init];
        _apartmentNameLabel.textColor = TCBlackColor;
        _apartmentNameLabel.numberOfLines = 0;
        _apartmentNameLabel.text = self.rentProtocol.sourceName;
//        _apartmentNameLabel.text = @"凄凄切切群群群群凄凄切切群我wwwwwwwwwww";
        _apartmentNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _apartmentNameLabel;
}

- (UILabel *)apartmentNameTitle {
    if (_apartmentNameTitle == nil) {
        _apartmentNameTitle = [[UILabel alloc] init];
        _apartmentNameTitle.textColor = TCBlackColor;
        _apartmentNameTitle.text = @"公寓：";
        [_apartmentNameTitle setContentHuggingPriority:1000 forAxis:UILayoutConstraintAxisHorizontal];
        _apartmentNameTitle.font = [UIFont systemFontOfSize:14];
    }
    return _apartmentNameTitle;
}

- (UIView *)lineView1 {
    if (_lineView1 == nil) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = kLineColor;
    }
    return _lineView1;
}

- (UILabel *)apartmentNumLabel {
    if (_apartmentNumLabel == nil) {
        _apartmentNumLabel = [[UILabel alloc] init];
        _apartmentNumLabel.textColor = TCGrayColor;
        _apartmentNumLabel.text = [NSString stringWithFormat:@"编号：%@",self.rentProtocol.sourceNum];
        _apartmentNumLabel.font = [UIFont systemFontOfSize:12];
    }
    return _apartmentNumLabel;
}

- (UIView *)downView {
    if (_downView == nil) {
        _downView = [[UIView alloc] init];
        _downView.backgroundColor = [UIColor whiteColor];
    }
    return _downView;
}

- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
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
