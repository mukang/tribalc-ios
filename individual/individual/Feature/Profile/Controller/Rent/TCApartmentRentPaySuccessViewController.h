//
//  TCApartmentRentPaySuccessViewController.h
//  individual
//
//  Created by 穆康 on 2017/6/30.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

typedef void(^TCApartmentRentPaySuccess)();

@interface TCApartmentRentPaySuccessViewController : TCBaseViewController

@property (nonatomic) NSUInteger payCycle;
@property (copy, nonatomic) TCApartmentRentPaySuccess paySuccess;

@end
