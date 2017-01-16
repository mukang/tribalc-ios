//
//  TCPropertyDetailController.h
//  individual
//
//  Created by 王帅锋 on 16/12/16.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBaseViewController.h"
@class TCPropertyManage;

typedef void(^TCCompletionBlock)();

@interface TCPropertyDetailController : TCBaseViewController

/** 支付完成的回调 */
@property (copy, nonatomic) TCCompletionBlock completionBlock;

- (instancetype)initWithPropertyManage:(TCPropertyManage *)property;

@end
