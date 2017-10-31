//
//  TCMeetingRoomBookingTimeViewController.h
//  individual
//
//  Created by 穆康 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#import "TCBookingDate.h"
#import "TCBookingTime.h"

@interface TCMeetingRoomBookingTimeViewController : TCBaseViewController

@property (copy, nonatomic) NSString *meetingRoomID;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;

@property (strong, nonatomic) TCBookingDate *bookingDate;
@property (strong, nonatomic) TCBookingTime *startBookingTime;
@property (strong, nonatomic) TCBookingTime *endBookingTime;

@end
