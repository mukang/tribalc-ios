//
//  TCWalletCreditLimitView.h
//  individual
//
//  Created by 穆康 on 2017/7/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCWalletAccount;

@interface TCWalletCreditLimitView : UIView

@property (strong, nonatomic) TCWalletAccount *walletAccount;

@property (weak, nonatomic) UIImageView *creditIcon;
@property (weak, nonatomic) UIImageView *validIcon;

@end
