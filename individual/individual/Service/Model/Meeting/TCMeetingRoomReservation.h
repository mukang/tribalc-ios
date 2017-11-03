//
//  TCMeetingRoomReservation.h
//  individual
//
//  Created by 王帅锋 on 2017/11/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCMeetingRoomReservation : NSObject

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *reservationNum;

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) NSInteger floor;

@property (assign, nonatomic) int64_t conferenceBeginTime;

@property (assign, nonatomic) int64_t conferenceEndTime;

@property (assign, nonatomic) double totalFee;

@property (copy, nonatomic) NSString *status;

@property (copy, nonatomic) NSString *picture;

@property (copy, nonatomic) NSString *subject;

@end
