//
//  TCCommonPaymentViewController.h
//  individual
//
//  Created by 穆康 on 2017/9/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//


#import <TCCommonLibs/TCBaseViewController.h>
#import "TCPaymentEnum.h"
#import "TCWalletAccount.h"
#import "TCCreditBill.h"

typedef void(^TCRechargeCompletionBlock)();

@interface TCCommonPaymentViewController : TCBaseViewController

@property (nonatomic, readonly) TCCommonPaymentPurpose paymentPurpose;
/** 信用账单 */
@property (strong, nonatomic) TCCreditBill *creditBill;
/** 钱包信息 */
@property (strong, nonatomic) TCWalletAccount *walletAccount;
/** 建议金额 */
@property (nonatomic) double suggestAmount;
/** 充值完成的回调 */
@property (copy, nonatomic) TCRechargeCompletionBlock rechargeCompletionBlock;

@property (weak, nonatomic) UIViewController *fromController;

- (instancetype)initWithPaymentPurpose:(TCCommonPaymentPurpose)paymentPurpose;

@end
