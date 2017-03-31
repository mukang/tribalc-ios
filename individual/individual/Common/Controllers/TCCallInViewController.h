//
//  TCCallInViewController.h
//  individual
//
//  Created by 王帅锋 on 17/1/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#include "LinphoneManager.h"
#import "TCLinphoneUtils.h"

typedef void (^Myblock)();

@interface TCCallInViewController : TCBaseViewController
@property(nonatomic, assign) LinphoneCall *call;

@property (nonatomic, copy) Myblock myBlock;

@end
