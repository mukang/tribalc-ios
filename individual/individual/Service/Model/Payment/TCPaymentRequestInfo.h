//
//  TCPaymentRequestInfo.h
//  individual
//
//  Created by 穆康 on 2017/6/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCEnum.h"

/**
 付款申请信息
 */
@interface TCPaymentRequestInfo : NSObject

/** 支付密码，只有 payChannel 为 BALANCE 必须 */
@property (copy, nonatomic) NSString *password;
/** 支付方式 */
@property (nonatomic) TCPayChannel payChannel;
/** 商品订单ID列表 或 物业报修单ID列表 */
@property (copy, nonatomic) NSArray *orderIds;
/** 目标商户ID，面对面付款时必须 */
@property (copy, nonatomic) NSString *targetId;
/** 付款金额，面对面付款时必须 */
@property (nonatomic) double totalFee;

@end
