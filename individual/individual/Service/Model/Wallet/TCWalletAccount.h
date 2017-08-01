//
//  TCWalletAccount.h
//  individual
//
//  Created by 穆康 on 2016/11/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCWalletAccount : NSObject

/** 与用户id一致 */
@property (copy, nonatomic) NSString *ID;
/** 账户余额 */
@property (nonatomic) double balance;
/** 账户余额中不可提现金额 */
@property (nonatomic) double limitedBalance;
/** 账户类型 Default PROTOCOL From {
     CARD,       // 会员卡模式，仅用于商户，此时"商户余额"计算公式为 balance - creditBalance，其他额度信息无效
     PROTOCOL    // 协议模式，通用，各项余额正常显示
 } */
@property (copy, nonatomic) NSString *accountType;
/** 单笔转出手续费 */
@property (nonatomic) double withdrawCharge;
/** 账户状态 */
@property (copy, nonatomic) NSString *state;
/** 密码 MD5 签名 */
@property (copy, nonatomic) NSString *password;
/** 最后时间 */
@property (nonatomic) NSInteger lastTrading;
/** 银行卡列表 */
@property (copy, nonatomic) NSArray *bankCards;

/** 已使用信用余额 */
@property (nonatomic) double creditBalance;
/** 总授信额度 */
@property (nonatomic) double creditLimit;
/** 信用账户状态 Default NONE From { NONE(未开通), NORMAL(正常), OVERDUE(预期), DISABLED(停用) } */
@property (copy, nonatomic) NSString *creditStatus;
/** 信用账户账单日 */
@property (nonatomic) NSInteger billDay;
/** 信用账户还款日 */
@property (nonatomic) NSInteger repayDay;

@end
