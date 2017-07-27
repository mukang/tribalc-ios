//
//  TCCreditViewController.h
//  individual
//
//  Created by 王帅锋 on 2017/7/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

@class TCWalletAccount;

@interface TCCreditViewController : TCBaseViewController

/** 企业id，有值则代表是企业授信 */
@property (copy, nonatomic) NSString *companyID;
@property (strong, nonatomic) TCWalletAccount *walletAccount;

@end
