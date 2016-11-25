//
//  TCWalletPasswordViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWalletPasswordViewController.h"

#import "MLBPasswordTextField.h"

#import "TCFunctions.h"
#import "TCBuluoApi.h"

NSString *const TCWalletPasswordKey = @"TCWalletPasswordKey";
NSString *const TCWalletPasswordDidChangeNotification = @"TCWalletPasswordDidChangeNotification";

@interface TCWalletPasswordViewController () <MLBPasswordTextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) MLBPasswordTextField *passwordTextField;
@property (copy, nonatomic) NSString *password;

@end

@implementation TCWalletPasswordViewController {
    __weak TCWalletPasswordViewController *weakSelf;
}

- (instancetype)initWithPasswordType:(TCWalletPasswordType)passwordType {
    self = [super initWithNibName:@"TCWalletPasswordViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        weakSelf = self;
        _passwordType = passwordType;
    }
    return self;
}

- (instancetype)init {
    return [self initWithPasswordType:TCWalletPasswordTypeOldPassword];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self initWithPasswordType:TCWalletPasswordTypeOldPassword];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![self.passwordTextField isFirstResponder]) {
        [self.passwordTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
    }
}

- (void)setupNavBar {
    self.navigationItem.title = @"支付密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    switch (self.passwordType) {
        case TCWalletPasswordTypeOldPassword:
            self.titleLabel.text = @"请输入旧的支付密码：";
            [self.doneButton setTitle:@"确认" forState:UIControlStateNormal];
            break;
        case TCWalletPasswordTypeNewPassword:
            self.titleLabel.text = @"请输入新的支付密码：";
            [self.doneButton setTitle:@"继续" forState:UIControlStateNormal];
            break;
        case TCWalletPasswordTypeConfirmPassword:
            self.titleLabel.text = @"请再次输入新的支付密码：";
            [self.doneButton setTitle:@"确认" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    self.doneButton.layer.cornerRadius = 2.5;
    self.doneButton.layer.masksToBounds = YES;
    
    MLBPasswordTextField *textField = [[MLBPasswordTextField alloc] init];
    textField.mlb_numberOfDigit = 6;
    textField.mlb_borderColor = TCRGBColor(221, 221, 221);
    textField.mlb_borderWidth = 0.5;
    textField.mlb_dotColor = TCRGBColor(42, 42, 42);
    textField.mlb_dotRadius = 3.5;
    textField.mlb_delegate = self;
    textField.size = CGSizeMake(TCRealValue(337), TCRealValue(50));
    textField.centerX = TCScreenWidth * 0.5;
    textField.y = 55;
    [self.view addSubview:textField];
    self.passwordTextField = textField;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - MLBPasswordTextFieldDelegate

- (void)mlb_passwordTextField:(MLBPasswordTextField *)pwdTextField didFilledPassword:(NSString *)password {
    self.password = password;
}

#pragma mark - Actions

- (IBAction)handleDidClickDoneButton:(UIButton *)sender {
    if (!self.password) {
        [MBProgressHUD showHUDWithMessage:@"请输入支付密码！"];
    }
    switch (self.passwordType) {
        case TCWalletPasswordTypeOldPassword:
            [self checkOldPassword];
            break;
        case TCWalletPasswordTypeNewPassword:
        {
            TCWalletPasswordViewController *vc = [[TCWalletPasswordViewController alloc] initWithPasswordType:TCWalletPasswordTypeConfirmPassword];
            vc.aNewPassword = self.password;
            vc.oldPassword = self.oldPassword;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case TCWalletPasswordTypeConfirmPassword:
            [self setNewPassword];
            break;
        default:
            break;
    }
}

- (void)checkOldPassword {
    NSString *digestStr = TCDigestMD5(self.password);
    if ([digestStr isEqualToString:self.oldPassword]) {
        TCWalletPasswordViewController *vc = [[TCWalletPasswordViewController alloc] initWithPasswordType:TCWalletPasswordTypeNewPassword];
        vc.oldPassword = self.password;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [MBProgressHUD showHUDWithMessage:@"密码错误，请重新输入！"];
    }
}

- (void)setNewPassword {
    if (![self.aNewPassword isEqualToString:self.password]) {
        [MBProgressHUD showHUDWithMessage:@"两次输入的新密码不一致，请重新输入！"];
        return;
    }
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeWalletPassword:self.oldPassword aNewPassword:self.aNewPassword result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD showHUDWithMessage:@"设置成功！"];
            [[NSNotificationCenter defaultCenter] postNotificationName:TCWalletPasswordDidChangeNotification object:nil userInfo:@{TCWalletPasswordKey: TCDigestMD5(weakSelf.password)}];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIViewController *vc = weakSelf.navigationController.childViewControllers[1];
                [weakSelf.navigationController popToViewController:vc animated:YES];
            });
        } else {
            [MBProgressHUD showHUDWithMessage:@"设置失败！"];
        }
    }];
}

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
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
