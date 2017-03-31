//
//  TCRechargeViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRechargeViewController.h"

#import "TCRechargeInputView.h"
#import "TCRechargeMethodsView.h"
#import <TCCommonLibs/TCCommonButton.h>

#import "TCBuluoApi.h"
#import "WXApiManager.h"

@interface TCRechargeViewController () <TCRechargeMethodsViewDelegate, UITextFieldDelegate, WXApiManagerDelegate>

@property (weak, nonatomic) UILabel *balanceLabel;

@property (weak, nonatomic) UITextField *textField;
/** 输入框里是否含有小数点 */
@property (nonatomic, getter=isHavePoint) BOOL havePoint;

@property (nonatomic) TCRechargeMethod rechargeMethod;
/** 预支付ID，查询微信支付结果时使用 */
@property (copy, nonatomic) NSString *prepayID;

@end

@implementation TCRechargeViewController {
    __weak TCRechargeViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.view.backgroundColor = TCRGBColor(226, 238, 252);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapViewGesture:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
    self.rechargeMethod = TCRechargeMethodWechat;
    
    [self setupNavBar];
    [self setupSubviews];
}

#pragma mark - Private Methods

- (void)setupNavBar {
    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTintColor:TCBlackColor];
    
    UIImage *barImage = [UIImage imageNamed:@"TransparentPixel"];
    [self.navigationController.navigationBar setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:barImage];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item_black"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    UIImageView *balanceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_recharge_balance_bg"]];
    [self.view addSubview:balanceImageView];
    
    UILabel *balanceLabel = [[UILabel alloc] init];
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.textColor = TCBlackColor;
    balanceLabel.font = [UIFont boldSystemFontOfSize:17];
    balanceLabel.text = [NSString stringWithFormat:@"余额：¥%0.2f", self.balance];
    [self.view addSubview:balanceLabel];
    self.balanceLabel = balanceLabel;
    
    TCRechargeInputView *inputView = [[TCRechargeInputView alloc] init];
    inputView.textField.keyboardType = UIKeyboardTypeDecimalPad;
    inputView.textField.textColor = TCBlackColor;
    inputView.textField.font = [UIFont systemFontOfSize:14];
    inputView.textField.delegate = self;
    if (self.suggestMoney) {
        inputView.textField.text = [NSString stringWithFormat:@"%0.2f", self.suggestMoney];
    }
    [self.view addSubview:inputView];
    self.textField = inputView.textField;
    
    TCRechargeMethodsView *methodsView = [[TCRechargeMethodsView alloc] init];
    methodsView.rechargeMethod = self.rechargeMethod;
    methodsView.delegate = self;
    [self.view addSubview:methodsView];
    
    TCCommonButton *rechargeButton = [TCCommonButton buttonWithTitle:@"充  值" target:self action:@selector(handleClickRechargeButton:)];
    [self.view addSubview:rechargeButton];
    
    [balanceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(128, 128));
        make.top.equalTo(weakSelf.view.mas_top).with.offset(73);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    [balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(50);
        make.centerY.equalTo(balanceImageView.mas_centerY);
    }];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(balanceImageView.mas_bottom).with.offset(TCRealValue(47));
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
    [methodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView.mas_bottom).with.offset(TCRealValue(58));
        make.left.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(130);
    }];
    [rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(30);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-30);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(TCRealValue(-40));
        make.height.mas_equalTo(40);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    /*
     * 不能输入.0-9以外的字符
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.havePoint = YES;
    } else {
        self.havePoint = NO;
    }
    
    if (string.length > 0) {
        // 当前输入的字符
        unichar character = [string characterAtIndex:0];
        TCLog(@"single = %c",character);
        
        // 不能输入.0-9以外的字符
        if (((character < '0') || (character > '9')) && (character != '.')) {
            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHavePoint && character == '.') {
            return NO;
        }
        
        // 如果第一位是.则前面加上0
        if (textField.text.length == 0 && character == '.') {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondCharacter = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondCharacter isEqualToString:@"."]) {
                    return NO;
                }
            } else {
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHavePoint) {
            NSRange pointRange = [textField.text rangeOfString:@"."];
            if (range.location > pointRange.location) {
                if ([textField.text pathExtension].length > 1) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark - TCRechargeMethodsViewDelegate

- (void)rechargeMethodsView:(TCRechargeMethodsView *)view didSelectedMethodButtonWithMethod:(TCRechargeMethod)rechargeMethod {
    self.rechargeMethod = rechargeMethod;
}

#pragma mark - WXApiManagerDelegate

- (void)managerDidRecvPayResponse:(PayResp *)response {
    switch (response.errCode) {
        case WXSuccess:
            [self handleCheckWechatRechargeResult];
            break;
            
        default:
            [MBProgressHUD showHUDWithMessage:@"充值失败"];
            break;
    }
}

#pragma mark - Actions 

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleTapViewGesture:(UITapGestureRecognizer *)gesture {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
}

- (void)handleClickRechargeButton:(UIButton *)sender {
    if (self.textField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入充值金额"];
        return;
    }
    double money = [self.textField.text doubleValue];
    if (self.rechargeMethod == TCRechargeMethodWechat) {
        [MBProgressHUD showHUD:YES];
        [[TCBuluoApi api] fetchWechatRechargeInfoWithMoney:money result:^(TCWechatRechargeInfo *wechatRechargeInfo, NSError *error) {
            if (wechatRechargeInfo) {
                [MBProgressHUD hideHUD:NO];
                [weakSelf handleArouseWechatRecharge:wechatRechargeInfo];
            } else {
                NSString *reason = error.localizedDescription ?: @"请稍后再试";
                [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"充值失败，%@", reason]];
            }
        }];
    } else if (self.rechargeMethod == TCRechargeMethodAlipay) {
        // TODO:
    }
}

/**
 调起微信支付
 */
- (void)handleArouseWechatRecharge:(TCWechatRechargeInfo *)rechargeInfo {
    
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD showHUDWithMessage:@"您未安装微信客户端，无法充值"];
        return;
    }
    
    [WXApiManager sharedManager].delegate = self;
    self.prepayID = rechargeInfo.prepayid;
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = rechargeInfo.partnerid;
    req.prepayId = rechargeInfo.prepayid;
    req.nonceStr = rechargeInfo.noncestr;
    req.timeStamp = [rechargeInfo.timestamp intValue];
    req.package = rechargeInfo.package;
    req.sign = rechargeInfo.sign;
    [WXApi sendReq:req];
}

/**
 查询微信支付结果
 */
- (void)handleCheckWechatRechargeResult {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchWechatRechargeResultWithPrepayID:self.prepayID result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD showHUDWithMessage:@"充值成功"];
            weakSelf.balanceLabel.text = [NSString stringWithFormat:@"余额：¥%0.2f", weakSelf.balance + [weakSelf.textField.text doubleValue]];
            if (weakSelf.completionBlock) {
                weakSelf.completionBlock();
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"查询充值结果失败，%@", reason]];
        }
    }];
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
