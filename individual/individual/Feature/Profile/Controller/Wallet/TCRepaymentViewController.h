//
//  TCRepaymentViewController.h
//  individual
//
//  Created by 穆康 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
@class TCWalletAccount;
@class TCCreditBill;

@interface TCRepaymentViewController : TCBaseViewController

/** 信用账单 */
@property (strong, nonatomic) TCCreditBill *creditBill;
/** 钱包信息 */
@property (strong, nonatomic) TCWalletAccount *walletAccount;

@end
