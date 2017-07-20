//
//  TCPrivilege.h
//  individual
//
//  Created by 王帅锋 on 2017/7/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TCPrivilegeType) {
    TCPrivilegeTypeDiscount = 0,  // 折扣
    TCPrivilegeTypeReduce,        // 满减
    TCPrivilegeTypeAliquot        // 叠加满减
};

@interface TCPrivilege : NSObject

/** 优惠id */
@property (copy, nonatomic) NSString *ID;
/** 商户id */
@property (copy, nonatomic) NSString *ownerId;
/** Default DISCOUNT From ｛ DISCOUNT(折扣类型), REDUCE(满减), ALIQUOT(满减叠加)} */
@property (copy, nonatomic) NSString *type;
/** 枚举 */
@property (nonatomic) TCPrivilegeType privilegeType;
/** 要满足的金额 */
@property (assign, nonatomic) double condition;
/** 折扣 或 满减金额 */
@property (assign, nonatomic) double value;
/** 可用时间段 */
@property (copy, nonatomic) NSArray *activityTime;
/** 开始日期 */
@property (assign, nonatomic) int64_t startDate;
/** 结束日期 */
@property (assign, nonatomic) int64_t endDate;

/** UI上被选中 */
@property (nonatomic) BOOL selected;
/** UI上减免的金额 */
@property (nonatomic) double deductibleValue;

@end
