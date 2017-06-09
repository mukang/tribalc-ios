//
//  MLBPasswordTextField.m
//  MLBPasswordTextFieldDemo
//
//  Created by meilbn on 21/11/2016.
//  Copyright © 2016 meilbn. All rights reserved.
//

#import "MLBPasswordTextField.h"

@interface MLBPasswordTextField ()

@property (nonatomic, strong) MLBPasswordRenderView *mlb_pwdRenderView;

@end

@implementation MLBPasswordTextField

#pragma mark - View Lifecycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNumberOfDigit:(NSInteger)num {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        if (num <= 0) num = kMLBPasswordTextFieldDefaultNumberOfDigit;
        _mlb_numberOfDigit = num;
        _mlb_showCursor = NO;
        _mlb_secureTextEntry = YES;
        [self mlb_setup];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"MLBPasswordTextField初始化错误"
                                   reason:@"请使用接口文件提供的初始化方法"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    @throw [NSException exceptionWithName:@"MLBPasswordTextField初始化错误"
                                   reason:@"请使用接口文件提供的初始化方法"
                                 userInfo:nil];
    return nil;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    @throw [NSException exceptionWithName:@"MLBPasswordTextField初始化错误"
                                   reason:@"请使用接口文件提供的初始化方法"
                                 userInfo:nil];
    return nil;
}

#pragma mark - Parent Methods

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return NO;
}

#pragma mark - Private Methods
- (void)mlb_setup {
    if (!self.mlb_pwdRenderView) {
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = [UIColor clearColor];
        self.tintColor = [UIColor clearColor];
        self.borderStyle = UITextBorderStyleNone;
        self.keyboardType = UIKeyboardTypeNumberPad;
        self.secureTextEntry = YES;
        self.enablesReturnKeyAutomatically = YES;
        self.clearsOnBeginEditing = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        
        self.mlb_pwdRenderView = [[MLBPasswordRenderView alloc] initWithNumberOfDigit:_mlb_numberOfDigit];
        [self addSubview:self.mlb_pwdRenderView];
        [self sendSubviewToBack:self.mlb_pwdRenderView];
        
        NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.mlb_pwdRenderView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        leadingConstraint.priority = 999;
        NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.mlb_pwdRenderView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        trailingConstraint.priority = 999;
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.mlb_pwdRenderView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
        topConstraint.priority = 999;
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.mlb_pwdRenderView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        bottomConstraint.priority = 999;
        
        [self addConstraints:@[leadingConstraint, trailingConstraint, topConstraint, bottomConstraint]];
    }
}

#pragma mark - Setter

- (void)setMlb_borderColor:(UIColor *)mlb_borderColor {
    if (_mlb_borderColor != mlb_borderColor) {
        _mlb_borderColor = mlb_borderColor;
        self.mlb_pwdRenderView.mlb_rBorderColor = _mlb_borderColor;
    }
}

- (void)setMlb_borderWidth:(CGFloat)mlb_borderWidth {
    if (_mlb_borderWidth != mlb_borderWidth) {
        _mlb_borderWidth = mlb_borderWidth;
        self.mlb_pwdRenderView.mlb_rBorderWidth = _mlb_borderWidth;
    }
}

- (void)setMlb_dotColor:(UIColor *)mlb_dotColor {
    if (_mlb_dotColor != mlb_dotColor) {
        _mlb_dotColor = mlb_dotColor;
        self.mlb_pwdRenderView.mlb_rDotColor = _mlb_dotColor;
    }
}

- (void)setMlb_dotRadius:(CGFloat)mlb_dotRadius {
    if (_mlb_dotRadius != mlb_dotRadius) {
        _mlb_dotRadius = mlb_dotRadius;
        self.mlb_pwdRenderView.mlb_rDotRadius = _mlb_dotRadius;
    }
}

- (void)setMlb_cursorColor:(UIColor *)mlb_cursorColor {
    if (_mlb_cursorColor != mlb_cursorColor) {
        _mlb_cursorColor = mlb_cursorColor;
        self.mlb_pwdRenderView.mlb_rCursorColor = _mlb_cursorColor;
    }
}

- (void)setMlb_cursorWidth:(CGFloat)mlb_cursorWidth {
    if (_mlb_cursorWidth != mlb_cursorWidth) {
        _mlb_cursorWidth = mlb_cursorWidth;
        self.mlb_pwdRenderView.mlb_rCursorWidth = _mlb_cursorWidth;
    }
}

- (void)setMlb_cursorHeight:(CGFloat)mlb_cursorHeight {
    if (_mlb_cursorHeight != mlb_cursorHeight) {
        _mlb_cursorHeight = mlb_cursorHeight;
        self.mlb_pwdRenderView.mlb_rCursorHeight = _mlb_cursorHeight;
    }
}

- (void)setMlb_secureTextEntry:(BOOL)mlb_secureTextEntry {
    if (_mlb_secureTextEntry != mlb_secureTextEntry) {
        _mlb_secureTextEntry = mlb_secureTextEntry;
        self.mlb_pwdRenderView.mlb_rSecureTextEntry = _mlb_secureTextEntry;
    }
}

- (void)setMlb_font:(UIFont *)mlb_font {
    if (_mlb_font != mlb_font) {
        _mlb_font = mlb_font;
        self.mlb_pwdRenderView.mlb_rFont = _mlb_font;
    }
}

- (void)setMlb_textColor:(UIColor *)mlb_textColor {
    if (_mlb_textColor != mlb_textColor) {
        _mlb_textColor = mlb_textColor;
        self.mlb_pwdRenderView.mlb_rTextColor = _mlb_textColor;
    }
}

#pragma mark - Notifications

- (void)textDidBeginEditing:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (textField == self) {
        if (_mlb_showCursor) {
            self.mlb_pwdRenderView.mlb_rShowCursor = YES;
        }
    }
}

- (void)textDidEndEditing:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (textField == self) {
        if (_mlb_showCursor) {
            self.mlb_pwdRenderView.mlb_rShowCursor = NO;
        }
    }
}

- (void)textDidChanged:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    if (textField == self) {
        if (textField.text.length > _mlb_numberOfDigit && textField.markedTextRange == nil) {
            textField.text = [textField.text substringWithRange: NSMakeRange(0, _mlb_numberOfDigit)];
        } else {
            self.mlb_pwdRenderView.mlb_rCurrentText = textField.text;
            self.mlb_pwdRenderView.mlb_rCurrentNumberOfDot = textField.text.length;
        }
        
        if (textField.text.length == _mlb_numberOfDigit) {
            if (_mlb_delegate && [_mlb_delegate respondsToSelector:@selector(mlb_passwordTextField:didFilledPassword:)]) {
                [_mlb_delegate mlb_passwordTextField:self didFilledPassword:self.text];
            }
        }
    }
}

@end
