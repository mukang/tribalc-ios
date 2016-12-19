//
//  TCCommunityReservationInfo.h
//  individual
//
//  Created by 穆康 on 2016/12/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCCommunityReservationInfo : NSObject

/** 社区ID */
@property (copy, nonatomic) NSString *communityId;
/** 预约时间 */
@property (nonatomic) NSInteger reservationDate;
/** 公司名称 */
@property (copy, nonatomic) NSString *companyName;
/** 预约人姓名 */
@property (copy, nonatomic) NSString *reservationPerson;
/** 预约人电话 */
@property (copy, nonatomic) NSString *phone;
/** 参观人数 */
@property (nonatomic) NSInteger reservationPersonNum;
/** 备注 */
@property (copy, nonatomic) NSString *note;

@end
