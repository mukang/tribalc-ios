//
//  TCRentProtocolWithholdInfo.h
//  individual
//
//  Created by 穆康 on 2017/6/30.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 协议租金代扣信息
 */
@interface TCRentProtocolWithholdInfo : NSObject

/** 协议ID */
@property (copy, nonatomic) NSString *ID;
/** 持卡人姓名 */
@property (copy, nonatomic) NSString *userName;
/** 开户行名称 */
@property (copy, nonatomic) NSString *bankName;
/** 开户行代码 */
@property (copy, nonatomic) NSString *bankCode;
/** 银行卡号 */
@property (copy, nonatomic) NSString *bankCardNum;
/** 预留手机号 */
@property (copy, nonatomic) NSString *phone;
/** 持卡人身份证号码 */
@property (copy, nonatomic) NSString *idNo;

@end
