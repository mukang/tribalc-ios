//
//  TCPaymentBankCardView.m
//  individual
//
//  Created by 穆康 on 2017/4/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPaymentBankCardView.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/TCExtendButton.h>

@interface TCPaymentBankCardView () <MLBPasswordTextFieldDelegate>

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) TCExtendButton *backButton;
@property (weak, nonatomic) UIView *separatorView;
@property (weak, nonatomic) UILabel *promptLabel;
@property (weak, nonatomic) TCExtendButton * codeButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger timeCount;

@end

@implementation TCPaymentBankCardView

- (instancetype)initWithBankCard:(TCBankCard *)bankCard {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _bankCard = bankCard;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Life Cycle

- (void)dealloc {
    [self removeGetSMSTimer];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"输入短信验证码";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:titleLabel];
    
    TCExtendButton *backButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"payment_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(handleClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    backButton.hitTestSlop = UIEdgeInsetsMake(-20, -20, -20, -20);
    [self addSubview:backButton];
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TCSeparatorLineColor;
    [self addSubview:separatorView];
    
    NSString *phone = self.bankCard.phone;
    if (phone.length == 11) {
        phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.text = [NSString stringWithFormat:@"请输入手机号%@收到的验证码", phone];
    promptLabel.textColor = TCGrayColor;
    promptLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:promptLabel];
    
    MLBPasswordTextField *codeTextField = [[MLBPasswordTextField alloc] initWithNumberOfDigit:6];
    codeTextField.mlb_secureTextEntry = NO;
    codeTextField.mlb_borderColor = TCSeparatorLineColor;
    codeTextField.mlb_delegate = self;
    [self addSubview:codeTextField];
    
    TCExtendButton * codeButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [codeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"获取验证码"
                                                                   attributes:@{
                                                                                NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                NSForegroundColorAttributeName: TCRGBColor(0, 0, 208),
                                                                                NSUnderlineStyleAttributeName: @(1)
                                                                                }]
                          forState:UIControlStateNormal];
    [codeButton addTarget:self action:@selector(handleClickCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    codeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    codeButton.hitTestSlop = UIEdgeInsetsMake(-20, -20, -20, -20);
    [self addSubview:codeButton];
    
    self.titleLabel = titleLabel;
    self.backButton = backButton;
    self.separatorView = separatorView;
    self.promptLabel = promptLabel;
    self.codeTextField = codeTextField;
    self.codeButton = codeButton;
    
    [self startCountDown];
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 21));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_top).with.offset(31);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 22));
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
        make.centerY.equalTo(weakSelf.titleLabel.mas_centerY);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_top).with.offset(62);
        make.height.mas_equalTo(0.5);
    }];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.top.equalTo(weakSelf.separatorView.mas_bottom).offset(14);
    }];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(weakSelf.promptLabel);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(337), 49.5));
        make.top.equalTo(weakSelf.separatorView.mas_bottom).offset(35);
        make.centerX.equalTo(weakSelf);
    }];
}

#pragma mark - MLBPasswordTextFieldDelegate

- (void)mlb_passwordTextField:(MLBPasswordTextField *)pwdTextField didFilledPassword:(NSString *)password {
    if ([self.delegate respondsToSelector:@selector(bankCardView:didClickConfirmButtonWithCode:)]) {
        [self.delegate bankCardView:self didClickConfirmButtonWithCode:self.codeTextField.text];
    }
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickBackButtonInBankCardView:)]) {
        [self.delegate didClickBackButtonInBankCardView:self];
    }
}

- (void)handleClickCodeButton:(UIButton *)sender {
    if (sender.isEnabled == NO) return;
    
    if ([self.delegate respondsToSelector:@selector(didClickFetchCodeButtonInBankCardView:)]) {
        [self.delegate didClickFetchCodeButtonInBankCardView:self];
    }
}

#pragma mark - Timer

- (void)addGetSMSTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTimeLabel) userInfo:nil repeats:YES];
}

- (void)removeGetSMSTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startCountDown {
    self.timeCount = 60;
    self.codeButton.enabled = NO;
    [self.codeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%02zd)重新获取", self.timeCount]
                                                                        attributes:@{
                                                                                     NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                     NSForegroundColorAttributeName: TCGrayColor
                                                                                     }]
                               forState:UIControlStateDisabled];
    [self addGetSMSTimer];
}

- (void)stopCountDown {
    [self removeGetSMSTimer];
    self.codeButton.enabled = YES;
}

- (void)changeTimeLabel {
    self.timeCount --;
    if (self.timeCount <= 0) {
        [self removeGetSMSTimer];
        self.codeButton.enabled = YES;
        return;
    }
    [self.codeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(%02zd)重新获取", self.timeCount]
                                                                        attributes:@{
                                                                                     NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                     NSForegroundColorAttributeName: TCGrayColor
                                                                                     }]
                               forState:UIControlStateDisabled];
}

@end
