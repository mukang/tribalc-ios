//
//  TCRechargeViewController.h
//  individual
//
//  Created by 穆康 on 2016/12/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
@class TCWalletAccount;

typedef void(^TCRechargeCompletionBlock)();

@interface TCRechargeViewController : TCBaseViewController

/** 钱包信息 */
@property (strong, nonatomic) TCWalletAccount *walletAccount;
/** 建议金额 */
@property (nonatomic) double suggestMoney;
/** 充值完成的回调 */
@property (copy, nonatomic) TCRechargeCompletionBlock completionBlock;

@end
