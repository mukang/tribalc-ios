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
#import <TCCommonLibs/TCCommonButton.h>

@interface TCPaymentBankCardView ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) TCExtendButton *backButton;
@property (weak, nonatomic) UIView *separatorView;
@property (weak, nonatomic) UILabel *promptLabel;
@property (weak, nonatomic) UILabel *codeLabel;
@property (weak, nonatomic) UITextField *codeTextField;
@property (weak, nonatomic) TCExtendButton * codeButton;
@property (weak, nonatomic) TCCommonButton *paymentButton;

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

- (void)setupSubviews {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapSuperview:)];
    [self addGestureRecognizer:tap];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择付款方式";
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
    
    UILabel *codeLabel = [[UILabel alloc] init];
    codeLabel.text = @"验证码";
    codeLabel.textColor = TCBlackColor;
    codeLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:codeLabel];
    
    UITextField *codeTextField = [[UITextField alloc] init];
    codeTextField.textColor = TCBlackColor;
    codeTextField.textAlignment = NSTextAlignmentCenter;
    codeTextField.font = [UIFont systemFontOfSize:11];
    codeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入短信验证码"
                                                                          attributes:@{
                                                                                       NSFontAttributeName: [UIFont systemFontOfSize:11],
                                                                                       NSForegroundColorAttributeName: TCGrayColor
                                                                                       }];
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.layer.borderColor = TCSeparatorLineColor.CGColor;
    codeTextField.layer.borderWidth = 0.5;
    codeTextField.layer.cornerRadius = 0.25;
    codeTextField.layer.masksToBounds = YES;
    [self addSubview:codeTextField];
    
    TCExtendButton * codeButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [codeButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"获取验证码"
                                                                   attributes:@{
                                                                                NSFontAttributeName: [UIFont systemFontOfSize:10],
                                                                                NSForegroundColorAttributeName: TCRGBColor(0, 0, 208),
                                                                                NSUnderlineStyleAttributeName: @(1)
                                                                                }]
                          forState:UIControlStateNormal];
    [codeButton addTarget:self action:@selector(handleClickCodeButton:) forControlEvents:UIControlEventTouchUpInside];
    codeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    codeButton.hitTestSlop = UIEdgeInsetsMake(-20, -20, -20, -20);
    [self addSubview:codeButton];
    
    TCCommonButton *paymentButton = [TCCommonButton buttonWithTitle:@"支  付"
                                                              color:TCCommonButtonColorBlue
                                                             target:self
                                                             action:@selector(handleClickPaymentButton:)];
    [self addSubview:paymentButton];
    
    self.titleLabel = titleLabel;
    self.backButton = backButton;
    self.separatorView = separatorView;
    self.promptLabel = promptLabel;
    self.codeLabel = codeLabel;
    self.codeTextField = codeTextField;
    self.codeButton = codeButton;
    self.paymentButton = paymentButton;
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
        make.top.equalTo(weakSelf.separatorView.mas_bottom).offset(12);
    }];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.promptLabel);
        make.top.equalTo(weakSelf.separatorView.mas_bottom).offset(40);
    }];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 26));
        make.centerY.equalTo(weakSelf.codeLabel);
        make.left.equalTo(weakSelf.codeLabel.mas_right).offset(10);
    }];
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(weakSelf.codeLabel);
    }];
    [self.paymentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(weakSelf).offset(30);
        make.right.equalTo(weakSelf).offset(-30);
        make.bottom.equalTo(weakSelf).offset(-38);
    }];
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickBackButtonInBankCardView:)]) {
        [self.delegate didClickBackButtonInBankCardView:self];
    }
}

- (void)handleClickCodeButton:(UIButton *)sender {
    
}

- (void)handleClickPaymentButton:(UIButton *)sender {
    
}

- (void)handleTapSuperview:(UITapGestureRecognizer *)gesture {
    if ([self.codeTextField isFirstResponder]) {
        [self.codeTextField resignFirstResponder];
    }
}

@end
