//
//  TCMeetingRoomRemind.h
//  individual
//
//  Created by 穆康 on 2017/11/2.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCMeetingRoomRemind : NSObject

@property (nonatomic) int remindTime;

@property (copy, nonatomic) NSString *remindStr;

+ (instancetype)remindWithRemindTime:(int)remindTime remindStr:(NSString *)remindStr;

@end
