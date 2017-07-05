//
//  TCRentPlanItemsViewController.h
//  individual
//
//  Created by 穆康 on 2017/7/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
@class TCRentProtocol;

/**
 缴租计划页面
 */
@interface TCRentPlanItemsViewController : TCBaseViewController

@property (strong, nonatomic) TCRentProtocol *rentProtocol;

@end
