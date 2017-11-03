//
//  TCBookingRequestInfo.h
//  individual
//
//  Created by 穆康 on 2017/11/2.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCBookingRequestInfo : NSObject

/** 提醒时间 */
@property (nonatomic) int reminderTime;
/** 与会人数 */
@property (nonatomic) int attendance;
/** 会议开始时间 */
@property (nonatomic) long long conferenceBeginTime;
/** 会议结束时间 */
@property (nonatomic) long long conferenceEndTime;
/** 会议主题 */
@property (copy, nonatomic) NSString *subject;
/** 提醒人信息 */
@property (copy, nonatomic) NSArray *conferenceParticipants;

@end
