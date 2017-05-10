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

@end
