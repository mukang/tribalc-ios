//
//  TCRechargeWechatInfo.h
//  individual
//
//  Created by 穆康 on 2016/12/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 调起微信支付接口所需信息
 */
@interface TCRechargeWechatInfo : NSObject

/** 应用ID */
@property (copy, nonatomic) NSString *appid;
/** 商户号 */
@property (copy, nonatomic) NSString *partnerid;
/** 预支付交易会话ID */
@property (copy, nonatomic) NSString *prepayid;
/** 扩展字段 */
@property (copy, nonatomic) NSString *package;
/** 随机字符串 */
@property (copy, nonatomic) NSString *noncestr;
/** 时间戳 */
@property (copy, nonatomic) NSString *timestamp;
/** 签名 */
@property (copy, nonatomic) NSString *sign;

@end
