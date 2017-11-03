//
//  TCMeetingRoomRemind.m
//  individual
//
//  Created by 穆康 on 2017/11/2.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMeetingRoomRemind.h"

@implementation TCMeetingRoomRemind

+ (instancetype)remindWithRemindTime:(int)remindTime remindStr:(NSString *)remindStr {
    TCMeetingRoomRemind *remind = [[self alloc] init];
    remind.remindTime = remindTime;
    remind.remindStr = remindStr;
    return remind;
}

@end
