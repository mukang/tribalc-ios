//
//  TCPaymentEnum.h
//  individual
//
//  Created by 穆康 on 2017/9/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#ifndef TCPaymentEnum_h
#define TCPaymentEnum_h

#import <Foundation/Foundation.h>

/** 通用付款目的 */
typedef NS_ENUM(NSInteger, TCCommonPaymentPurpose) {
    TCCommonPaymentPurposeRecharge = 0,         // 个人充值
    TCCommonPaymentPurposeRepayment,            // 个人还款
    TCCommonPaymentPurposeCompanyRecharge,      // 企业充值
    TCCommonPaymentPurposeCompanyRepayment      // 企业还款
};

/** 付款方式 */
typedef NS_ENUM(NSInteger, TCPaymentMethod) {
    TCPaymentMethodNone = 0,        // 无
    TCPaymentMethodBalance,         // 余额
    TCPaymentMethodWechat,          // 微信
    TCPaymentMethodBankCard         // 银行卡
};

#endif /* TCPaymentEnum_h */
