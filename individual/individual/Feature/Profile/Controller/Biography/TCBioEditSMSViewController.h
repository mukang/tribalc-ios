//
//  TCBioEditSMSViewController.h
//  individual
//
//  Created by 穆康 on 2016/11/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCCommonLibs/TCBaseViewController.h>

typedef NS_ENUM(NSInteger, TCMessageCodeType) {
    TCMessageCodeTypeBindPhone,       // 绑定手机号
    TCMessageCodeTypeFindPassword     // 找回支付密码
};

typedef void(^TCEditPhoneBlock)(BOOL isEdit);

@interface TCBioEditSMSViewController : TCBaseViewController

@property (copy, nonatomic) NSString *phone;
@property (nonatomic, readonly) TCMessageCodeType messageCodeType;

/** 编辑新手机号回调 */
@property (copy, nonatomic) TCEditPhoneBlock editPhoneBlock;

/** 钱包id，当修改钱包支付密码时使用 */
@property (copy, nonatomic) NSString *walletID;

- (instancetype)initWithMessageCodeType:(TCMessageCodeType)messageCodeType;

@end
