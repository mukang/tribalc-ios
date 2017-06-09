//
//  MLBPasswordTextField.h
//  MLBPasswordTextFieldDemo
//
//  Created by meilbn on 21/11/2016.
//  Copyright © 2016 meilbn. All rights reserved.
//
//  Version: 0.0.4

#import <UIKit/UIKit.h>
#import "MLBPasswordRenderView.h"

@class MLBPasswordTextField;

@protocol MLBPasswordTextFieldDelegate <NSObject>

@optional

- (void)mlb_passwordTextField:(MLBPasswordTextField *)pwdTextField didFilledPassword:(NSString *)password;

@end


@interface MLBPasswordTextField : UITextField

@property (nonatomic, assign, readonly) NSUInteger mlb_numberOfDigit; // default is 6

@property (nonatomic, weak) id <MLBPasswordTextFieldDelegate> mlb_delegate;

// border
@property (nonatomic, strong) UIColor *mlb_borderColor; // default is MLBPasswordRenderViewDefaultBorderColor
@property (nonatomic, assign) CGFloat mlb_borderWidth; // default is 0.5

// dot
@property (nonatomic, strong) UIColor *mlb_dotColor; // default is black
@property (nonatomic, assign) CGFloat mlb_dotRadius; // default is 8.0

// cursor
@property (nonatomic, strong) UIColor *mlb_cursorColor; // default is MLBPasswordDefaultCursorColor, like UITextField's cursor
@property (nonatomic, assign) CGFloat mlb_cursorWidth; // default is 2, like UITextField's cursor
@property (nonatomic, assign) CGFloat mlb_cursorHeight; // default is 20

@property (nonatomic, assign) BOOL mlb_showCursor; // default is NO

@property (nonatomic) BOOL mlb_secureTextEntry; // default is YES
@property (strong, nonatomic) UIFont *mlb_font; // default is font 20 pt
@property (strong, nonatomic) UIColor *mlb_textColor; // default is 42, 42, 42


/**
 初始化方法
 */
- (instancetype)initWithNumberOfDigit:(NSInteger)num;

@end
