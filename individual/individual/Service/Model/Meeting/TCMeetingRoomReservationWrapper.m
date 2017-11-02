//
//  TCMeetingRoomReservationWrapper.m
//  individual
//
//  Created by 王帅锋 on 2017/11/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomReservationWrapper.h"
#import "TCMeetingRoomReservation.h"

@implementation TCMeetingRoomReservationWrapper
+ (NSDictionary *)objectClassInArray {
    return @{
             @"content": [TCMeetingRoomReservation class]
             };
}
@end
