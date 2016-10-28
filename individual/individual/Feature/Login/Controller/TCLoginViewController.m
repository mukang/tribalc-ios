//
//  TCLoginViewController.m
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLoginViewController.h"
#import "TCGetPasswordView.h"

#import <YYText/YYText.h>

@interface TCLoginViewController () <UITextFieldDelegate, TCGetPasswordViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *passwordContainerView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) TCGetPasswordView *getPasswordView;
@property (nonatomic, weak) YYLabel *noticeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alipayButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wechatButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherLabelBottomConstraint;

@end

@implementation TCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupSubviews];
    [self setupConstraints];
}

- (void)setupSubviews {
    
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"请输入手机号"
                                                                        attributes:@{
                                                                                     NSForegroundColorAttributeName : TCRGBColor(211, 211, 211),
                                                                                     NSFontAttributeName : [UIFont systemFontOfSize:14]
                                                                                     }];
    self.accountTextField.attributedPlaceholder = attStr;
    
    attStr = [[NSAttributedString alloc] initWithString:@"请输入验证码"
                                             attributes:@{
                                                          NSForegroundColorAttributeName : TCRGBColor(211, 211, 211),
                                                          NSFontAttributeName : [UIFont systemFontOfSize:14]
                                                          }];
    self.passwordTextField.attributedPlaceholder = attStr;
    
    TCGetPasswordView *getPasswordView = [[[NSBundle mainBundle] loadNibNamed:@"TCGetPasswordView" owner:nil options:nil] firstObject];
    getPasswordView.translatesAutoresizingMaskIntoConstraints = NO;
    getPasswordView.delegate = self;
    [self.passwordContainerView addSubview:getPasswordView];
    self.getPasswordView = getPasswordView;
    
    NSString *userAgreementStr = @"部落公社注册协议";
    NSString *noticeStr = [NSString stringWithFormat:@"注册即视为同意%@", userAgreementStr];
    NSRange highlightRange = [noticeStr rangeOfString:userAgreementStr];
    YYTextHighlight *highlight = [[YYTextHighlight alloc] init];
    highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        NSLog(@"部落公社注册协议");
    };
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:noticeStr];
    attText.yy_font = [UIFont systemFontOfSize:12];
    attText.yy_color = TCRGBColor(211, 211, 211);
    [attText yy_setColor:TCRGBColor(38, 38, 38) range:highlightRange];
    [attText yy_setTextHighlight:highlight range:highlightRange];
    
    YYLabel *noticeLabel = [[YYLabel alloc] init];
    noticeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    noticeLabel.attributedText = attText;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noticeLabel];
    self.noticeLabel = noticeLabel;
}

- (void)setupConstraints {
    // constraint
    self.accountViewTopConstraint.constant = TCRealValue(305);
    self.alipayButtonBottomConstraint.constant = TCRealValue(63.5);
    self.wechatButtonBottomConstraint.constant = TCRealValue(63.5);
    self.otherLabelBottomConstraint.constant = TCRealValue(42);
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.getPasswordView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:0
                                                                 multiplier:1.0
                                                                   constant:71];
    [self.getPasswordView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.getPasswordView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:0
                                             multiplier:1.0
                                               constant:23];
    [self.getPasswordView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.getPasswordView
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.passwordContainerView
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0
                                               constant:0];
    [self.passwordContainerView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.getPasswordView
                                              attribute:NSLayoutAttributeRight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.passwordContainerView
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1.0
                                               constant:-8];
    [self.passwordContainerView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.noticeLabel
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.loginButton
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0
                                               constant:9];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.noticeLabel
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:0
                                             multiplier:1.0
                                               constant:14];
    [self.noticeLabel addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.noticeLabel
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeft
                                             multiplier:1.0
                                               constant:17];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.noticeLabel
                                              attribute:NSLayoutAttributeRight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1.0
                                               constant:-17];
    [self.view addConstraint:constraint];
}


#pragma mark - button action

- (IBAction)handleTapBackButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)handleTapLoginButton:(UIButton *)sender {
    NSLog(@"登录");
}

- (IBAction)handleTapAlipayButton:(UIButton *)sender {
    NSLog(@"支付宝登录");
}

- (IBAction)handleTapWechatButton:(UIButton *)sender {
    NSLog(@"微信登录");
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - TCGetPasswordViewDelegate

- (void)didTapGetPasswordButtonInGetPasswordView:(TCGetPasswordView *)view {
    NSLog(@"发送验证码");
    [self.getPasswordView startCountDown];
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
