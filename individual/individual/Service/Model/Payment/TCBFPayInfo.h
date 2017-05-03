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
/** 可选参数，支付申请ID（参见POST /wallets/{id}/payments 返回值id属性），如果传递，则完成扣款操作后，金额不再进入余额，而是直接抵扣账单金额，同时支付申请关闭并完成所有后继到账处理；如果不传参数，则为账户余额充值 */
@property (copy, nonatomic) NSString *paymentId;

@end
