//
//  TCPaySuccessViewController.h
//  individual
//
//  Created by 穆康 on 2017/6/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

@interface TCPaySuccessViewController : TCBaseViewController

/** 金额 */
@property (nonatomic) double totalAmount;
/** 商家名称 */
@property (copy, nonatomic) NSString *storeName;

@property (weak, nonatomic) UIViewController *fromController;

@end
