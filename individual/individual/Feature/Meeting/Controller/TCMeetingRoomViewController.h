//
//  TCMeetingRoomViewController.h
//  individual
//
//  Created by 穆康 on 2017/10/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#import "TCMeetingRoom.h"

@class TCMeetingRoomReservationDetail;

@interface TCMeetingRoomViewController : TCBaseViewController

@property (strong, nonatomic) TCMeetingRoom *meetingRoom;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@property (strong, nonatomic) TCMeetingRoomReservationDetail *meetingRoomReservationDetail;

@end
