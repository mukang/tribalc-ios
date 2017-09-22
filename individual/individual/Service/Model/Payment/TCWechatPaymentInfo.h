//
//  TCWechatPaymentInfo.h
//  individual
//
//  Created by 穆康 on 2017/9/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCWechatPaymentInfo : NSObject

/** 应用ID */
@property (copy, nonatomic) NSString *appid;
/** 商户号 */
@property (copy, nonatomic) NSString *partnerid;
/** 预支付交易会话ID */
@property (copy, nonatomic) NSString *prepayid;
/** 扩展字段 */
@property (copy, nonatomic) NSString *packageValue;
/** 随机字符串 */
@property (copy, nonatomic) NSString *noncestr;
/** 时间戳 */
@property (copy, nonatomic) NSString *timestamp;
/** 签名 */
@property (copy, nonatomic) NSString *sign;

@end
