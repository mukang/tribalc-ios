//
//  TCBioEditSMSViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditSMSViewController.h"
#import "TCBiographyViewController.h"

@interface TCBioEditSMSViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *resendButton;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger timeCount;

@end

@implementation TCBioEditSMSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"手机绑定";
    self.noticeLabel.text = [NSString stringWithFormat:@"请输入%@收到的短信校验码", self.phone];
    
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

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - actions

- (IBAction)handleClickResendButton:(UIButton *)sender {
    [self startCountDown];
}

- (IBAction)handleClickCommitButton:(UIButton *)sender {
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

- (void)changeTimeLabel {
    self.timeCount --;
    if (self.timeCount <= 0) {
        [self removeGetSMSTimer];
        self.countdownLabel.hidden = YES;
        self.resendButton.hidden = NO;
    }
    self.countdownLabel.text = [NSString stringWithFormat:@"%02zd秒后重发", self.timeCount];
}

#pragma mark - timer

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
