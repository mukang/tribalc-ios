//
//  TCPaymentPasswordView.m
//  individual
//
//  Created by 穆康 on 2016/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPaymentPasswordView.h"
#import <TCCommonLibs/TCExtendButton.h>

@interface TCPaymentPasswordView () <MLBPasswordTextFieldDelegate>

@property (weak, nonatomic) IBOutlet TCExtendButton *backButton;

@end

@implementation TCPaymentPasswordView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    MLBPasswordTextField *textField = [[MLBPasswordTextField alloc] initWithNumberOfDigit:6];
    textField.mlb_borderColor = TCSeparatorLineColor;
    textField.mlb_dotColor = TCBlackColor;
    textField.mlb_dotRadius = 7;
    textField.mlb_delegate = self;
    [self addSubview:textField];
    self.textField = textField;
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(337), 49.5));
        make.top.equalTo(self).offset(85);
        make.centerX.equalTo(self);
    }];
    
    self.backButton.hitTestSlop = UIEdgeInsetsMake(-20, -20, -20, -20);
}

- (void)mlb_passwordTextField:(MLBPasswordTextField *)pwdTextField didFilledPassword:(NSString *)password {
    if ([self.delegate respondsToSelector:@selector(paymentPasswordView:didFilledPassword:)]) {
        [self.delegate paymentPasswordView:self didFilledPassword:password];
    }
}

- (IBAction)handleClickBackButton:(UIButton *)sender {
    if ([self.textField isFirstResponder]) {
        [self.textField resignFirstResponder];
    }
    if ([self.delegate respondsToSelector:@selector(didClickBackButtonInPaymentPasswordView:)]) {
        [self.delegate didClickBackButtonInPaymentPasswordView:self];
    }
}

@end
