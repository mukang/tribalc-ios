//
//  TCRentProtocol.h
//  individual
//
//  Created by 穆康 on 2017/6/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 租赁协议
 */
@interface TCRentProtocol : NSObject

/** 租期协议ID */
@property (copy, nonatomic) NSString *ID;
/** 社区ID */
@property (copy, nonatomic) NSString *communityId;
/** 房源ID */
@property (copy, nonatomic) NSString *sourceId;
/** 租户ID */
@property (copy, nonatomic) NSString *ownerId;
/** 协议类型 Default OFFICE From { OFFICE, APARTMENT } Means { 办公、公寓 } */
@property (copy, nonatomic) NSString *type;
/** 协议创建日期 */
@property (nonatomic) long long createTime;
/** 房间号 */
@property (copy, nonatomic) NSString *roomNum;
/** 月租金额 */
@property (nonatomic) double monthlyRent;
/** 缴租周期（单位：月） */
@property (nonatomic) NSUInteger payCycle;
/** 开始日期 */
@property (nonatomic) long long beginTime;
/** 结束日期 */
@property (nonatomic) long long endTime;
/** 待缴租日期 */
@property (nonatomic) long long imminentPayTime;
/** 缴租状态, Default NORMALFrom { NORMAL（正常）, CONFIRM（待确认）, OVERDUE（逾期） } */
@property (copy, nonatomic) NSString *rentStatus;
/** 是否已续签 */
@property (nonatomic) BOOL renewed;
/** 租赁协议状态 Default ACTIVED { INACTIVED (尚未生效), ACTIVED (生效中或有欠缺), FINISHED(已完成未欠款) } */
@property (copy, nonatomic) NSString *status;

/** 公司名称，关联信息 */
@property (copy, nonatomic) NSString *companyName;
/** 是否启用锁权限，关联信息 */
@property (nonatomic) BOOL lockAuthorized;

/** 房源名称 */
@property (copy, nonatomic) NSString *sourceName;
/** 房源编号 */
@property (copy, nonatomic) NSString *sourceNum;
/** 合同照片 */
@property (copy, nonatomic) NSString *pictures;
/** 租客姓名 */
@property (copy, nonatomic) NSString *rentName;
/** 租客性别 */
@property (copy, nonatomic) NSString *rentSex;
/** 租客职业 */
@property (copy, nonatomic) NSString *rentJob;
/** 租客手机号 */
@property (copy, nonatomic) NSString *rentPhone;
/** 租客身份证号 */
@property (copy, nonatomic) NSString *rentIdNo;
/** 锁设备号 */
@property (copy, nonatomic) NSString *sn;

@end
