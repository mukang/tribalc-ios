//
//  TCApartmentAddWithholdViewController.h
//  individual
//
//  Created by 穆康 on 2017/7/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
@class TCRentProtocolWithholdInfo;

typedef void(^TCApartmentAddWithholdSuccess)();

@interface TCApartmentAddWithholdViewController : TCBaseViewController

@property (nonatomic) BOOL isEdit; // 是否是修改代扣信息
@property (strong, nonatomic) TCRentProtocolWithholdInfo *withholdInfo;
@property (copy, nonatomic) NSArray *banks;

@property (copy, nonatomic) TCApartmentAddWithholdSuccess addWithholdSuccess;

@end
