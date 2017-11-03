//
//  TCMeetingRoomReservationDetail.m
//  individual
//
//  Created by 王帅锋 on 2017/11/2.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomReservationDetail.h"
#import "TCMeetingRoomEquipment.h"
#import "TCMeetingParticipant.h"

@implementation TCMeetingRoomReservationDetail

+ (NSDictionary *)objectClassInArray {
    return @{
             @"equipmentList": [TCMeetingRoomEquipment class],
             @"conferenceParticipants": [TCMeetingParticipant class]
             };
}

@end
