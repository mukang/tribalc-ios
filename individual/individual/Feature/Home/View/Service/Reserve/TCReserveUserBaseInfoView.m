//
//  TCReserveUserBaseInfoView.m
//  individual
//
//  Created by WYH on 16/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCReserveUserBaseInfoView.h"
#import "TCBuluoApi.h"

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
        self.backgroundColor = TCRGBColor(242, 242, 242);
        
        _isNeedVerification = NO;
        
        baseInfoView = [self getNameAndSenderViewWithFrame:CGRectMake(0, 0, self.width, 40)];
        [self addSubview:baseInfoView];
        
        UIView *phoneView = [self getPhoneViewWithFrame:CGRectMake(0, baseInfoView.y + baseInfoView.height, self.width, 40)];
        [self addSubview:phoneView];
        
        verificationCodeView = [self getVerificationCodeViewWithFrame:CGRectMake(0, phoneView.y + phoneView.height, self.width, 40)];
        verificationCodeView.hidden = YES;
        [self addSubview:verificationCodeView];
        
        sendVerficationCodeView = [self getSendVerficationCodeViewWithFrame:CGRectMake(0, verificationCodeView.y + verificationCodeView.height, self.width, 21)];
        [self addSubview:sendVerficationCodeView];
        sendVerficationCodeView.hidden = YES;
        
        UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        [self addSubview:topLineView];
        
        downLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, baseInfoView.y + baseInfoView.height + 40 - 1, self.width, 1)];
        [self addSubview:downLineView];
        
        
        additionalView = [self getAdditionalViewWithFrame:CGRectMake(0, phoneView.y + phoneView.height + 11, self.width, self.height - baseInfoView.y - baseInfoView.height - 11)];
        [self addSubview:additionalView];
        
    }
    
    return self;
}

- (UIView *)getSendVerficationCodeViewWithFrame:(CGRect)frame {
    UIView *sendView = [[UIView alloc] initWithFrame:frame];
    UILabel *sendLab = [TCComponent createLabelWithText:@"收不到短信验证码？点击" AndFontSize:11];
    sendLab.frame = CGRectMake(20, 0, sendLab.width, frame.size.height);
    [sendView addSubview:sendLab];
    
    UIButton *sendBtn = [TCComponent createButtonWithFrame:CGRectMake(sendLab.x + sendLab.width, 0, self.width - sendLab.x - sendLab.width, sendLab.height) AndTitle:@"获取语音验证码" AndFontSize:11];
    [sendBtn setTitleColor:TCRGBColor(81, 199, 209) forState:UIControlStateNormal];
    [sendBtn sizeToFit];
    sendBtn.height = frame.size.height;
    [sendView addSubview:sendBtn];
    
    return sendView;
}

- (UIView *)getVerificationCodeViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    _verificationCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, self.width - 40, view.height)];
    _verificationCodeTextField.placeholder = @"请输入您的验证码";
    _verificationCodeTextField.font = [UIFont systemFontOfSize:14];
    [_verificationCodeTextField setValue:TCRGBColor(154, 154, 154) forKeyPath:@"_placeholderLabel.textColor"];
    [_verificationCodeTextField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    [view addSubview:_verificationCodeTextField];
    
    UIView *topLine = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, self.width - 40, 1)];
    [view addSubview:topLine];
    
    return view;
}


- (UIView *)getAdditionalViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    _additionalTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, self.width - 40, 30)];
    _additionalTextField.backgroundColor = [UIColor whiteColor];
    _additionalTextField.font = [UIFont systemFontOfSize:11];
    _additionalTextField.placeholder = @"可填写附加要求，我们会尽量安排，不超过20字";
    [_additionalTextField setValue:TCRGBColor(186, 186, 186) forKeyPath:@"_placeholderLabel.textColor"];
    [_additionalTextField setValue:[UIFont systemFontOfSize:11] forKeyPath:@"_placeholderLabel.font"];
    [view addSubview:_additionalTextField];
    
    UIView *line = [TCComponent createGrayLineWithFrame:CGRectMake(0, _additionalTextField.y + _additionalTextField.height, self.width, 1.5)];
    [view addSubview:line];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, _additionalTextField.y + _additionalTextField.height + 2, self.width, frame.size.height - _additionalTextField.y - _additionalTextField.height)];
    backView.backgroundColor = [UIColor whiteColor];
    [view addSubview:backView];
    
    
    
    return view;
}

- (TCUserInfo *)getUserInfo {
    return [TCBuluoApi api].currentUserSession.userInfo;
}

- (TCUserSensitiveInfo *)getUserSensitiveInfo {
    return [TCBuluoApi api].currentUserSession.userSensitiveInfo;
}

- (UIView *)getNameAndSenderViewWithFrame:(CGRect)frame {
    UIView *nameAndSenderView = [[UIView alloc] initWithFrame:frame];
    nameAndSenderView.backgroundColor = [UIColor whiteColor];
    
    _nameLab = [TCComponent createLabelWithText:[self getUserInfo].nickname AndFontSize:14];
    _nameLab.height = frame.size.height;
    _nameLab.x = 20;
    [nameAndSenderView addSubview:_nameLab];
    
    _senderView = [[TCReserveRadioBtnView alloc] initWithFrame:CGRectMake(TCScreenWidth - 20 - 109.5, 0, 109.5, nameAndSenderView.height)];
    [nameAndSenderView addSubview:_senderView];
    
    return nameAndSenderView;
}

- (UIView *)getPhoneViewWithFrame:(CGRect)frame {
    UIView *phoneView = [[UIView alloc] initWithFrame:frame];
    phoneView.backgroundColor  =[UIColor whiteColor];
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, 247, phoneView.height)];
    _phoneTextField.text = [self getUserSensitiveInfo].phone;
    _phoneTextField.font = [UIFont systemFontOfSize:14];
    _phoneTextField.placeholder = @"请输入电话号码";
    [_phoneTextField setValue:TCRGBColor(154, 154, 154) forKeyPath:@"_placeholderLabel.textColor"];
    [_phoneTextField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    _phoneTextField.userInteractionEnabled = NO;
    [phoneView addSubview:_phoneTextField];
    
    
    modifyBtn = [TCComponent createImageBtnWithFrame:CGRectMake(self.width - 20 - 18, phoneView.height / 2 - 18 / 2, 18, 18) AndImageName:@"order_write"];
    [modifyBtn addTarget:self action:@selector(touchModifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [phoneView addSubview:modifyBtn];
    
    cancelModifyBtn = [self getCancelModifyBtnWithFrame:CGRectMake(self.width - 25 - 60, phoneView.height / 2 - 22 / 2, 60 , 22)];
    [phoneView addSubview:cancelModifyBtn];
    
    UIView *topLine = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, self.width - 40, 1)];
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

- (void)touchCancelModifyBtn:(UIButton *)button {
    [self modifyPhoneView];
    verificationCodeView.hidden = YES;
    sendVerficationCodeView.hidden = YES;
    downLineView.y = baseInfoView.y + baseInfoView.height + 40 - 1;
    
    _phoneTextField.text = [self getUserSensitiveInfo].phone;
    
    additionalView.y = downLineView.y + downLineView.height + 11;
    
    _isNeedVerification = NO;
}

- (void)touchModifyBtn:(UIButton *)button {
    [self modifyPhoneView];
    
    verificationCodeView.hidden = NO;
    sendVerficationCodeView.hidden = NO;
    downLineView.y = verificationCodeView.y + verificationCodeView.height;
    
    additionalView.y = downLineView.y + downLineView.height + 45;
    
    _verificationCodeTextField.text = @"";
    
    _isNeedVerification = YES;
    
}




@end
