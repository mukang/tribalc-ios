//
//  TCMeetingRoomViewController.h
//  individual
//
//  Created by 穆康 on 2017/10/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#import "TCMeetingRoom.h"
#import "TCMeetingRoomReservationDetail.h"


typedef NS_ENUM(NSInteger, TCMeetingRoomViewControllerType) {
    TCMeetingRoomViewControllerTypeBooking = 0,
    TCMeetingRoomViewControllerTypeModification
};

@interface TCMeetingRoomViewController : TCBaseViewController

@property (strong, nonatomic) TCMeetingRoom *meetingRoom;
@property (strong, nonatomic) TCMeetingRoomReservationDetail *meetingRoomReservationDetail;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@property (nonatomic, readonly) TCMeetingRoomViewControllerType controllerType;

- (instancetype)initWithControllerType:(TCMeetingRoomViewControllerType)type;

@end
