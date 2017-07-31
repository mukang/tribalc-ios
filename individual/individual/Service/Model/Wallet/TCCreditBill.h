//
//  TCCreditBill.h
//  individual
//
//  Created by 王帅锋 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCCreditBill : NSObject

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *ownerId;
/** 账号余额 */
@property (assign, nonatomic) CGFloat amount;
/** 已还金额 */
@property (assign, nonatomic) CGFloat paidAmount;
/** 起算日期 */
@property (assign, nonatomic) int64_t zeroDate;
/** 账单日期 */
@property (assign, nonatomic) int64_t billDate;
/** 还款日期 */
@property (assign, nonatomic) int64_t repayDate;
/** 创建日期 */
@property (assign, nonatomic) int64_t createTime;
/** 提现状态 */
@property (copy, nonatomic) NSString *status;

/** 年份信息 */
@property (copy, nonatomic) NSString *yearDate;
/** 月份信息 */
@property (copy, nonatomic) NSString *monthDate;
/** 周信息 */
@property (copy, nonatomic) NSString *weekday;
/** 日期时间 */
@property (copy, nonatomic) NSString *detailTime;
/** 交易具体日期时间 */
@property (copy, nonatomic) NSString *tradingTime;

@end
