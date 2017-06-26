//
//  TCRentPlanItem.h
//  individual
//
//  Created by 穆康 on 2017/6/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 缴租计划项
 */
@interface TCRentPlanItem : NSObject

/** 缴租计划项ID */
@property (copy, nonatomic) NSString *ID;
/** 租期协议ID */
@property (copy, nonatomic) NSString *protocolId;
/** 计划缴租日期 */
@property (nonatomic) long long plannedTime;
/** 实际缴租日期 */
@property (nonatomic) long long actualTime;
/** 计划租金额 */
@property (nonatomic) double plannedRental;
/** 实际缴租金额 */
@property (nonatomic) double actualPay;
/** 银行流水号，可能为多条 */
@property (copy, nonatomic) NSArray *bankSerialNum;
/** 是否已经缴租 */
@property (nonatomic) BOOL finished;
/** 租期开始时间 */
@property (nonatomic) long long startTime;
/** 租期结束时间 */
@property (nonatomic) long long endTime;

@end
