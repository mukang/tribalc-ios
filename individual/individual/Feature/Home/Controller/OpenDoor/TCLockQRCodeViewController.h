//
//  TCLockQRCodeViewController.h
//  individual
//
//  Created by 穆康 on 2017/3/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBaseViewController.h"
#import "TCLockQRCodeView.h"

@interface TCLockQRCodeViewController : TCBaseViewController

@property (nonatomic, readonly) TCLockQRCodeType type;

- (instancetype)initWithLockQRCodeType:(TCLockQRCodeType)type;

@end
