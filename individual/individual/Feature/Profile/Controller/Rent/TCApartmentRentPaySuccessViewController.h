//
//  TCApartmentRentPaySuccessViewController.h
//  individual
//
//  Created by 穆康 on 2017/6/30.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
@class TCRentProtocol;

typedef void(^TCApartmentRentPaySuccess)();

@interface TCApartmentRentPaySuccessViewController : TCBaseViewController

@property (nonatomic) NSInteger itemNum;
@property (strong, nonatomic) TCRentProtocol *rentProtocol;
@property (copy, nonatomic) TCApartmentRentPaySuccess paySuccess;

@end
