//
//  TCMeetingRoom.m
//  individual
//
//  Created by 王帅锋 on 2017/10/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoom.h"
#import "TCMeetingRoomEquipment.h"

@implementation TCMeetingRoom

+ (NSDictionary *)objectClassInArray {
    return @{
             @"equipments": [TCMeetingRoomEquipment class]
             };
}
@end
