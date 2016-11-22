//
//  TCWalletPasswordViewController.h
//  individual
//
//  Created by 穆康 on 2016/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCWalletPasswordType) {
    TCWalletPasswordTypeOldPassword,
    TCWalletPasswordTypeNewPassword,
    TCWalletPasswordTypeConfirmPassword
};

extern NSString *const TCWalletPasswordKey;
extern NSString *const TCWalletPasswordDidChangeNotification;

@interface TCWalletPasswordViewController : UIViewController

@property (nonatomic, readonly) TCWalletPasswordType passwordType;
/** 旧密码 */
@property (copy, nonatomic) NSString *oldPassword;
/** 新密码 */
@property (copy, nonatomic) NSString *aNewPassword;

/**
 指定初始化方法

 @param passwordType 密码类型
 @return 返回TCWalletPasswordViewController对象
 */
- (instancetype)initWithPasswordType:(TCWalletPasswordType)passwordType;

@end
