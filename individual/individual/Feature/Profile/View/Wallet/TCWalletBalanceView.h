//
//  TCWalletBalanceView.h
//  individual
//
//  Created by 穆康 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCWalletAccount;

typedef NS_ENUM(NSInteger, TCWalletBalanceViewType) {
    TCWalletBalanceViewTypeIndividual = 0,
    TCWalletBalanceViewTypeCompany
};

@interface TCWalletBalanceView : UIView

@property (nonatomic, readonly) TCWalletBalanceViewType type;
@property (strong, nonatomic) TCWalletAccount *walletAccount;

- (instancetype)initWithType:(TCWalletBalanceViewType)type;

@end
