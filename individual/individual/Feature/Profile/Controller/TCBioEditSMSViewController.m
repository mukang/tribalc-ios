//
//  TCBioEditSMSViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditSMSViewController.h"
#import "TCBiographyViewController.h"

#import "MBProgressHUD+Category.h"

#import "TCBuluoApi.h"

@interface TCBioEditSMSViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger timeCount;

@end

@implementation TCBioEditSMSViewController {
    __weak TCBioEditSMSViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    self.noticeLabel.text = [NSString stringWithFormat:@"请输入%@收到的短信校验码", self.phone];
    [self setupNavBar];
    [self startCountDown];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (void)dealloc {
    [self removeGetSMSTimer];
}

- (void)setupNavBar {
    self.navigationItem.title = @"手机绑定";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleCickBackButton:)];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Actions

- (IBAction)handleClickResendButton:(UIButton *)sender {
    [self startCountDown];
    
    [[TCBuluoApi api] fetchVerificationCodeWithPhone:self.phone result:^(BOOL success, NSError *error) {
        if (!success) {
            [MBProgressHUD showHUDWithMessage:@"手机号格式错误！"];
            [weakSelf stopCountDown];
        }
    }];
}

- (IBAction)handleClickCommitButton:(UIButton *)sender {
    NSString *code = self.textField.text;
    if (code.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入验证码"];
        return;
    }
    
    TCUserPhoneInfo *phoneInfo = [[TCUserPhoneInfo alloc] init];
    phoneInfo.phone = self.phone;
    phoneInfo.verificationCode = code;
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeUserPhone:phoneInfo result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            if (self.editPhoneBlock) {
                self.editPhoneBlock(YES);
            }
            TCBiographyViewController *bioVC = self.navigationController.viewControllers[1];
            [self.navigationController popToViewController:bioVC animated:YES];
        } else {
            [MBProgressHUD showHUDWithMessage:@"手机号修改失败！"];
        }
    }];
}

- (void)handleCickBackButton:(UIBarButtonItem *)sender {
    TCBiographyViewController *bioVC = self.navigationController.viewControllers[1];
    [self.navigationController popToViewController:bioVC animated:YES];
}

- (void)startCountDown {
    self.timeCount = 60;
    self.countdownLabel.text = [NSString stringWithFormat:@"%02zd秒后重发", self.timeCount];
    self.countdownLabel.hidden = NO;
    self.resendButton.hidden = YES;
    [self addGetSMSTimer];
}

- (void)stopCountDown {
    [self removeGetSMSTimer];
    self.countdownLabel.hidden = YES;
    self.resendButton.hidden = NO;
}

- (void)changeTimeLabel {
    self.timeCount --;
    if (self.timeCount <= 0) {
        [self removeGetSMSTimer];
        self.countdownLabel.hidden = YES;
        self.resendButton.hidden = NO;
        return;
    }
    self.countdownLabel.text = [NSString stringWithFormat:@"%02zd秒后重发", self.timeCount];
}

#pragma mark - Timer

- (void)addGetSMSTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeLabel) userInfo:nil repeats:YES];
}

- (void)removeGetSMSTimer {
    [self.timer invalidate];
    self.timer = nil;
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
