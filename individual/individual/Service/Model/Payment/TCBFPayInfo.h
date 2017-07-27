//
//  TCBFPayInfo.h
//  individual
//
//  Created by 穆康 on 2017/4/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCBFPayInfo : NSObject

/** 银行卡id */
@property (copy, nonatomic) NSString *bankCardId;
/** 支付金额（元） */
@property (nonatomic) double totalFee;
/** generate_session_id 接口返回的 paymentId */
@property (copy, nonatomic) NSString *paymentId;
/** 充值目标账户，主要用于企业身份充值（个人），传递企业账户ID. 个人充值传递个人账户ID，当此值为 null 时，默认为充值者个人账 */
@property (copy, nonatomic) NSString *targetId;

@end
