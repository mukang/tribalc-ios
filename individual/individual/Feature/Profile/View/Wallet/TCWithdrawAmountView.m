//
//  TCWithdrawAmountView.m
//  store
//
//  Created by 穆康 on 2017/5/5.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCWithdrawAmountView.h"

#import <TCCommonLibs/TCExtendButton.h>

#import "TCWalletAccount.h"

@interface TCWithdrawAmountView ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *symbolLabel;
@property (weak, nonatomic) UILabel *disabledAmountLabel;
@property (weak, nonatomic) UIView *lineView;
@property (weak, nonatomic) TCExtendButton *allWithdrawButton;
@property (weak, nonatomic) UILabel *placeholderLabel;

@end

@implementation TCWithdrawAmountView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
        [self registerNotifications];
    }
    return self;
}

- (void)dealloc {
    [self removeNotifications];
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCGrayColor;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLabel];
    
    UILabel *symbolLabel = [[UILabel alloc] init];
    symbolLabel.text = @"¥";
    symbolLabel.textColor = TCBlackColor;
    symbolLabel.font = [UIFont boldSystemFontOfSize:30];
    [symbolLabel sizeToFit];
    [self addSubview:symbolLabel];
    
    TCNumberTextField *amountTextField = [[TCNumberTextField alloc] init];
    amountTextField.textColor = TCBlackColor;
    amountTextField.font = [UIFont boldSystemFontOfSize:30];
    amountTextField.keyboardType = UIKeyboardTypeDecimalPad;
    amountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:amountTextField];
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.textColor = TCGrayColor;
    placeholderLabel.textAlignment = NSTextAlignmentLeft;
    placeholderLabel.font = [UIFont systemFontOfSize:12];
    [amountTextField addSubview:placeholderLabel];
    self.placeholderLabel = placeholderLabel;
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self addSubview:lineView];
    
    UILabel *disabledAmountLabel = [[UILabel alloc] init];
    disabledAmountLabel.textColor = TCGrayColor;
    disabledAmountLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:disabledAmountLabel];
    
    TCExtendButton *allWithdrawButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [allWithdrawButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"全部提现"
                                                                          attributes:@{
                                                                                       NSForegroundColorAttributeName: TCRGBColor(81, 199, 209),
                                                                                       NSFontAttributeName: [UIFont systemFontOfSize:11]
                                                                                       }]
                                 forState:UIControlStateNormal];
    [allWithdrawButton addTarget:self
                          action:@selector(handleClickAllWithdrawButton:)
                forControlEvents:UIControlEventTouchUpInside];
    allWithdrawButton.hitTestSlop = UIEdgeInsetsMake(-5, -20, -5, -20);
    [self addSubview:allWithdrawButton];
    
    
    self.titleLabel = titleLabel;
    self.symbolLabel = symbolLabel;
    self.amountTextField = amountTextField;
    self.placeholderLabel = placeholderLabel;
    self.lineView = lineView;
    self.disabledAmountLabel = disabledAmountLabel;
    self.allWithdrawButton = allWithdrawButton;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.top.equalTo(weakSelf.mas_top).offset(15);
    }];
    [self.symbolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(20);
    }];
    [self.symbolLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                        forAxis:UILayoutConstraintAxisHorizontal];
    [self.amountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.symbolLabel.mas_right).offset(10);
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(weakSelf.symbolLabel);
    }];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.amountTextField).offset(2);
        make.centerY.equalTo(weakSelf.amountTextField);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.right.equalTo(weakSelf).offset(-20);
        make.bottom.equalTo(weakSelf).offset(-34);
        make.height.mas_equalTo(0.5);
    }];
    [self.disabledAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf).offset(20);
        make.centerY.equalTo(weakSelf.lineView.mas_bottom).offset(17);
    }];
    [self.allWithdrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf).offset(-20);
        make.centerY.equalTo(weakSelf.lineView.mas_bottom).offset(17);
    }];
}

#pragma mark - Actions

- (void)handleClickAllWithdrawButton:(UIButton *)sender {
    self.placeholderLabel.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(didClickAllWithdrawButtonInWithdrawAmountView:)]) {
        [self.delegate didClickAllWithdrawButtonInWithdrawAmountView:self];
    }
}

#pragma mark - Override Methods

- (void)setWalletAccount:(TCWalletAccount *)walletAccount {
    _walletAccount = walletAccount;
    
    self.titleLabel.text = [NSString stringWithFormat:@"提现金额（收取%0.2f元服务费）", walletAccount.withdrawCharge];
    
    NSString *disabledAmountStr = [NSString stringWithFormat:@"%0.2f", walletAccount.limitedBalance];
    NSString *str = [NSString stringWithFormat:@"不可提现金额：%@元", disabledAmountStr];
    NSRange highlightRange = [str rangeOfString:disabledAmountStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str
                                                                               attributes:@{
                                                                                            NSFontAttributeName: [UIFont systemFontOfSize:12],
                                                                                            NSForegroundColorAttributeName: TCGrayColor
                                                                                            }];
    [attStr addAttribute:NSForegroundColorAttributeName value:TCRGBColor(229, 16, 16) range:highlightRange];
    self.disabledAmountLabel.attributedText = attStr;
}

- (void)setEnabledAmount:(double)enabledAmount {
    _enabledAmount = enabledAmount;
    
    self.placeholderLabel.text = [NSString stringWithFormat:@"可提现金额%0.2f元", enabledAmount];
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    TCNumberTextField *textField = (TCNumberTextField *)notification.object;
    if (![textField isEqual:self.amountTextField]) {
        return;
    }
    
    if (textField.text.length) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

@end
