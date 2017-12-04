//
//  TCMeetingRoomAddAttendeeViewController.h
//  individual
//
//  Created by 穆康 on 2017/11/29.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#import "TCMeetingParticipant.h"

typedef void(^TCAddAttendeeBlock)(TCMeetingParticipant *participant);

/**
 添加参会人
 */
@interface TCMeetingRoomAddAttendeeViewController : TCBaseViewController

@property (copy, nonatomic) TCAddAttendeeBlock addAttendeeblock;

@end
