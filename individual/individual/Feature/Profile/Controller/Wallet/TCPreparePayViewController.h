//
//  TCPreparePayViewController.h
//  individual
//
//  Created by 王帅锋 on 17/6/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

@interface TCPreparePayViewController : TCBaseViewController

@property (copy, nonatomic) NSString *storeId;

@property (weak, nonatomic) UIViewController *fromController;

@end
