//
//  TCRechargeViewController.h
//  individual
//
//  Created by 穆康 on 2016/12/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TCRechargeCompletionBlock)();

@interface TCRechargeViewController : UIViewController

@property (nonatomic) CGFloat balance;
@property (nonatomic) CGFloat suggestMoney;

@property (copy, nonatomic) TCRechargeCompletionBlock completionBlock;

@end
