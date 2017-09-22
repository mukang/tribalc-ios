//
//  TCCommonPaymentInputView.m
//  individual
//
//  Created by 穆康 on 2017/9/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommonPaymentInputView.h"

@interface TCCommonPaymentInputView ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *symbolLable;
@property (weak, nonatomic) UIView *lineView;
@property (weak, nonatomic) UILabel *repaymentLabel;

@end

@implementation TCCommonPaymentInputView

- (instancetype)initWithPaymentPurpose:(TCCommonPaymentPurpose)paymentPurpose {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _paymentPurpose = paymentPurpose;
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
    UILabel *titleLabel = [self creatLabelWithTextColor:TCGrayColor fontOfSize:12];
    [self addSubview:titleLabel];
    
    UILabel *symbolLable = [self creatLabelWithTextColor:TCBlackColor fontOfSize:24];
    symbolLable.text = @"¥";
    [self addSubview:symbolLable];
    
    TCNumberTextField *textField = [[TCNumberTextField alloc] init];
    textField.textColor = TCBlackColor;
    textField.font = [UIFont systemFontOfSize:24];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:textField];
    
    UILabel *placeholderLabel = [self creatLabelWithTextColor:TCLightGrayColor fontOfSize:16];
    if (_paymentPurpose == TCCommonPaymentPurposeRecharge || _paymentPurpose == TCCommonPaymentPurposeCompanyRecharge) {
        placeholderLabel.text = @"请输入充值金额";
    } else {
        placeholderLabel.text = @"请输入还款金额";
    }
    [textField addSubview:placeholderLabel];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self addSubview:lineView];
    
    UILabel *repaymentLabel = [[UILabel alloc] init];
    [self addSubview:repaymentLabel];
    
    if (_paymentPurpose == TCCommonPaymentPurposeRecharge || _paymentPurpose == TCCommonPaymentPurposeCompanyRecharge) {
        titleLabel.text = @"充值金额";
        repaymentLabel.hidden = YES;
    } else {
        titleLabel.text = @"还款金额";
        repaymentLabel.hidden = NO;
    }
    
    self.titleLabel = titleLabel;
    self.symbolLable = symbolLable;
    self.textField = textField;
    self.placeholderLabel = placeholderLabel;
    self.lineView = lineView;
    self.repaymentLabel = repaymentLabel;
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(10);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.bottom.equalTo(self).offset(-35);
    }];
    [self.symbolLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView);
        make.bottom.equalTo(self.lineView.mas_top).offset(-15);
    }];
    [self.symbolLable setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(45);
        make.left.equalTo(self.symbolLable.mas_right).offset(20);
        make.centerY.equalTo(self.symbolLable);
        make.right.equalTo(self.lineView);
    }];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField).offset(2);
        make.centerY.equalTo(self.textField);
    }];
    [self.repaymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView);
        make.centerY.equalTo(self.mas_bottom).offset(-17.5);
    }];
}

- (UILabel *)creatLabelWithTextColor:(UIColor *)textColor fontOfSize:(CGFloat)size {
    UILabel *lable = [[UILabel alloc] init];
    lable.textColor = textColor;
    lable.font = [UIFont systemFontOfSize:size];
    return lable;
}

- (void)setRepaymentAmount:(double)repaymentAmount {
    _repaymentAmount = repaymentAmount;
    
    NSString *amountStr = [NSString stringWithFormat:@"%0.2f", repaymentAmount];
    NSString *str = [NSString stringWithFormat:@"应还金额：%@元", amountStr];
    NSRange amountRange = [str rangeOfString:amountStr];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:str];
    [attText setAttributes:@{
                             NSFontAttributeName: [UIFont systemFontOfSize:12],
                             NSForegroundColorAttributeName: TCGrayColor
                             }
                     range:NSMakeRange(0, str.length)];
    [attText setAttributes:@{
                             NSFontAttributeName: [UIFont systemFontOfSize:12],
                             NSForegroundColorAttributeName: TCRGBColor(244, 55, 49)
                             }
                     range:amountRange];
    self.repaymentLabel.attributedText = attText;
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
    if (![textField isEqual:self.textField]) {
        return;
    }
    
    if (textField.hasText) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

@end
