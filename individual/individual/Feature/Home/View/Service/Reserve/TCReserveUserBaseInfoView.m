//
//  TCReserveUserBaseInfoView.m
//  individual
//
//  Created by WYH on 16/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCReserveUserBaseInfoView.h"
#import "TCBuluoApi.h"

@interface TCReserveUserBaseInfoView ()

@property (nonatomic, strong) NSTimer *timer;

@property (assign, nonatomic) int timeCount;

@end

@implementation TCReserveUserBaseInfoView {
    UIView *downLineView;
    UIView *additionalView;
    UIView *baseInfoView;
    UIView *verificationCodeView;
    UIButton *modifyBtn;
    UIButton *cancelModifyBtn;
    
    UIView *sendVerficationCodeView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = TCBackgroundColor;
        
        _isNeedVerification = NO;
        
        baseInfoView = [self getNameAndSenderViewWithFrame:CGRectMake(0, 0, self.width, TCRealValue(40))];
        [self addSubview:baseInfoView];
        
        UIView *phoneView = [self getPhoneViewWithFrame:CGRectMake(0, baseInfoView.y + baseInfoView.height, self.width, TCRealValue(40))];
        [self addSubview:phoneView];
        
        verificationCodeView = [self getVerificationCodeViewWithFrame:CGRectMake(0, phoneView.y + phoneView.height, self.width, TCRealValue(40))];
        verificationCodeView.hidden = YES;
        [self addSubview:verificationCodeView];
        
        sendVerficationCodeView = [self getSendVerficationCodeViewWithFrame:CGRectMake(0, verificationCodeView.y + verificationCodeView.height, self.width, TCRealValue(21))];
        [self addSubview:sendVerficationCodeView];
        sendVerficationCodeView.hidden = YES;
        
        UIView *topLineView = [self getLineViewWithFrame:CGRectMake(0, 0, self.width, TCRealValue(0.5))];
        [self addSubview:topLineView];
        
        downLineView = [self getLineViewWithFrame:CGRectMake(0, baseInfoView.y + baseInfoView.height + TCRealValue(40) - TCRealValue(1), self.width, TCRealValue(1))];
        [self addSubview:downLineView];
        
        
        additionalView = [self getAdditionalViewWithFrame:CGRectMake(0, phoneView.y + phoneView.height + TCRealValue(11), self.width, self.height - baseInfoView.y - baseInfoView.height - TCRealValue(11))];
        [self addSubview:additionalView];
        
    }
    
    return self;
}


- (UIView *)getLineViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = TCBackgroundColor;
    
    return view;
}

- (UIView *)getSendVerficationCodeViewWithFrame:(CGRect)frame {
    UIView *sendView = [[UIView alloc] initWithFrame:frame];
    UILabel *sendLab = [TCComponent createLabelWithText:@"收不到短信验证码？点击" AndFontSize:TCRealValue(11)];
    sendLab.frame = CGRectMake(TCRealValue(20), 0, sendLab.width, frame.size.height);
    [sendView addSubview:sendLab];
    
    UIButton *sendBtn = [TCComponent createButtonWithFrame:CGRectMake(sendLab.x + sendLab.width, 0, self.width - sendLab.x - sendLab.width, sendLab.height) AndTitle:@"获取语音验证码" AndFontSize:TCRealValue(11)];
    [sendBtn setTitleColor:TCRGBColor(81, 199, 209) forState:UIControlStateNormal];
    [sendBtn sizeToFit];
    sendBtn.height = frame.size.height;
    [sendView addSubview:sendBtn];
    
    return sendView;
}

- (UIView *)getVerificationCodeViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    _verificationCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(TCRealValue(20), 0, self.width - TCRealValue(40), view.height)];
    _verificationCodeTextField.placeholder = @"请输入您的验证码";
    _verificationCodeTextField.font = [UIFont systemFontOfSize:TCRealValue(14)];
    [_verificationCodeTextField setValue:TCGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [_verificationCodeTextField setValue:[UIFont systemFontOfSize:TCRealValue(14)] forKeyPath:@"_placeholderLabel.font"];
    [view addSubview:_verificationCodeTextField];
    _verificationCodeTextField.delegate = self;
    _verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    _verificationCodeTextField.tag = 10011;
    
    UIView *topLine = [self getLineViewWithFrame:CGRectMake(TCRealValue(20), 0, self.width - TCRealValue(40), TCRealValue(1))];
    [view addSubview:topLine];
    
    return view;
}


- (UIView *)getAdditionalViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    _additionalTextField = [[UITextField alloc] initWithFrame:CGRectMake(TCRealValue(20), 0, self.width - TCRealValue(40), TCRealValue(40))];
    _additionalTextField.backgroundColor = [UIColor whiteColor];
    _additionalTextField.font = [UIFont systemFontOfSize:TCRealValue(11)];
    _additionalTextField.placeholder = @"可填写附加要求，我们会尽量安排，不超过20字";
    [_additionalTextField setValue:TCLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [_additionalTextField setValue:[UIFont systemFontOfSize:TCRealValue(11)] forKeyPath:@"_placeholderLabel.font"];
    [view addSubview:_additionalTextField];
    
    UIView *line = [self getLineViewWithFrame:CGRectMake(0, _additionalTextField.y + _additionalTextField.height, self.width, TCRealValue(1.5))];
    [view addSubview:line];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, _additionalTextField.y + _additionalTextField.height + TCRealValue(2), self.width, frame.size.height - _additionalTextField.y - _additionalTextField.height)];
    backView.backgroundColor = [UIColor whiteColor];
    [view addSubview:backView];
    
    
    
    return view;
}

- (TCUserInfo *)getUserInfo {
    return [TCBuluoApi api].currentUserSession.userInfo;
}

- (TCUserInfo *)getUserSensitiveInfo {
    return [TCBuluoApi api].currentUserSession.userInfo;
}

- (UIView *)getNameAndSenderViewWithFrame:(CGRect)frame {
    UIView *nameAndSenderView = [[UIView alloc] initWithFrame:frame];
    nameAndSenderView.backgroundColor = [UIColor whiteColor];
    
    _nameLab = [TCComponent createLabelWithText:[self getUserInfo].nickname AndFontSize:TCRealValue(14)];
    _nameLab.height = frame.size.height;
    _nameLab.x = TCRealValue(20);
    [nameAndSenderView addSubview:_nameLab];
    
    _senderView = [[TCReserveRadioBtnView alloc] initWithFrame:CGRectMake(TCScreenWidth - TCRealValue(20) - TCRealValue(109.5), 0, TCRealValue(109.5), nameAndSenderView.height)];
    [nameAndSenderView addSubview:_senderView];
    
    return nameAndSenderView;
}

- (UIView *)getPhoneViewWithFrame:(CGRect)frame {
    UIView *phoneView = [[UIView alloc] initWithFrame:frame];
    phoneView.backgroundColor  =[UIColor whiteColor];
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(TCRealValue(20), 0, TCRealValue(247), phoneView.height)];
    _phoneTextField.text = [self getUserSensitiveInfo].phone;
    _phoneTextField.font = [UIFont systemFontOfSize:TCRealValue(14)];
    _phoneTextField.placeholder = @"请输入电话号码";
    _phoneTextField.delegate = self;
    _phoneTextField.tag = 10010;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneTextField setValue:TCGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneTextField setValue:[UIFont systemFontOfSize:TCRealValue(14)] forKeyPath:@"_placeholderLabel.font"];
    _phoneTextField.userInteractionEnabled = NO;
    [phoneView addSubview:_phoneTextField];
    
    
    modifyBtn = [TCComponent createImageBtnWithFrame:CGRectMake(self.width - TCRealValue(20) - TCRealValue(21), phoneView.height / 2 - TCRealValue(21) / 2, TCRealValue(21), TCRealValue(21)) AndImageName:@"profile_address_edit_button"];
    [modifyBtn addTarget:self action:@selector(touchModifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:modifyBtn];
    
    cancelModifyBtn = [self getCancelModifyBtnWithFrame:CGRectMake(self.width - TCRealValue(30) - TCRealValue(60), phoneView.height / 2 - TCRealValue(22) / 2, TCRealValue(65) , TCRealValue(22))];
    [phoneView addSubview:cancelModifyBtn];
    
    UIView *topLine = [self getLineViewWithFrame:CGRectMake(TCRealValue(20), 0, self.width - TCRealValue(40), TCRealValue(1))];
    [phoneView addSubview:topLine];
    
    return phoneView;
}


- (UIButton *)getCancelModifyBtnWithFrame:(CGRect)frame {
    UIButton *cancelBtn = [TCComponent createButtonWithFrame:frame AndTitle:@"取消修改" AndFontSize:12 AndBackColor:TCRGBColor(255, 254, 254) AndTextColor:TCRGBColor(81, 199, 209)];
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.cornerRadius = 5;
    cancelBtn.layer.borderColor = TCRGBColor(81, 199, 209).CGColor;
    cancelBtn.hidden = YES;
    [cancelBtn addTarget:self action:@selector(touchCancelModifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cancelBtn;
}

- (void)modifyPhoneView {
    
    
    _phoneTextField.userInteractionEnabled = !_phoneTextField.userInteractionEnabled;
    cancelModifyBtn.hidden = !cancelModifyBtn.hidden;
    modifyBtn.hidden = !modifyBtn.hidden;
    _phoneTextField.text = [_phoneTextField.text isEqualToString:@""] ? [self getUserSensitiveInfo].phone : @"";
    
}

- (void)startCountDown {
    self.timeCount = 60;
    cancelModifyBtn.enabled = NO;
    [cancelModifyBtn setTitle:[NSString stringWithFormat:@"%02ds",self.timeCount] forState:UIControlStateNormal];
    [self addGetSMSTimer];
}

- (void)stopCountDown {
    [self removeGetSMSTimer];
    cancelModifyBtn.enabled = YES;
    [cancelModifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
}

- (void)changeTimeLabel {
    self.timeCount --;
    if (self.timeCount <= 0) {
        [self removeGetSMSTimer];
        [cancelModifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        cancelModifyBtn.enabled = YES;
        return;
    }
    [cancelModifyBtn setTitle:[NSString stringWithFormat:@"%02ds",self.timeCount] forState:UIControlStateNormal];
}

#pragma mark - Timer

- (void)addGetSMSTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeLabel) userInfo:nil repeats:YES];
}

- (void)removeGetSMSTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)touchCancelModifyBtn:(UIButton *)button {
    if (_phoneTextField.text.length > 0) {
        //发验证码
        if (_phoneTextField.text.length == 11) {
            [self startCountDown];
            @WeakObj(self)
            [[TCBuluoApi api] fetchVerificationCodeWithPhone:self.phoneTextField.text result:^(BOOL success, NSError *error) {
                @StrongObj(self)
                if (!success) {
                    [self stopCountDown];
                    NSString *reason = error.localizedDescription ?: @"请稍后再试";
                    [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"验证码发送失败，%@", reason]];
                }
            }];
        }else {
            [MBProgressHUD showHUDWithMessage:@"请输入有效手机号"];
        }
        
        
    }else {
        [self modifyPhoneView];
        verificationCodeView.hidden = YES;
        sendVerficationCodeView.hidden = YES;
        downLineView.y = baseInfoView.y + baseInfoView.height + TCRealValue(40) - TCRealValue(1);
        
        _phoneTextField.text = [self getUserSensitiveInfo].phone;
        
        additionalView.y = downLineView.y + downLineView.height + TCRealValue(11);
        
        _isNeedVerification = NO;
    }
    
}

- (void)touchModifyBtn:(UIButton *)button {
    [self modifyPhoneView];
    
    verificationCodeView.hidden = NO;
    sendVerficationCodeView.hidden = NO;
    downLineView.y = verificationCodeView.y + verificationCodeView.height;
    
    additionalView.y = downLineView.y + downLineView.height + TCRealValue(45);
    
    _verificationCodeTextField.text = @"";
    
    _isNeedVerification = YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSInteger tag = textField.tag;
    if (tag == 10010) {
        //手机号
        if (textField.text.length >= 11 && ![string isEqualToString:@""]) {
            return NO;
        }
        
        if (textField.text.length + string.length > 11) {
            return NO;
        }
        
        if (textField.text.length == 1 && [string isEqualToString:@""]) {
            //取消修改
            [self stopCountDown];
            [cancelModifyBtn setTitle:@"取消修改" forState:UIControlStateNormal];
        }else if (![string isEqualToString:@""] || textField.text.length > 0) {
            //发验证码
            if (self.timer) {
                
            }else {
                [cancelModifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            }
            
        }
        
        
        
    }else if (tag == 10011) {
        //验证码
        if (textField.text.length >= 6) {
            return NO;
        }
    }
    
    return YES;
}



@end
