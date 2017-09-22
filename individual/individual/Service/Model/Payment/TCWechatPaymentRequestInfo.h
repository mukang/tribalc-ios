//
//  TCWechatPaymentRequestInfo.h
//  individual
//
//  Created by 穆康 on 2017/9/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCWechatPaymentRequestInfo : NSObject

/** 支付金额（元） */
@property (nonatomic) double totalFee;
/** generate_session_id 接口返回的 paymentId */
@property (copy, nonatomic) NSString *paymentId;
/** 充值或付款目标账户 */
@property (copy, nonatomic) NSString *targetId;

@end
