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

@protocol TCMeetingRoomBookingTimeViewControllerDelegate;
@interface TCMeetingRoomBookingTimeViewController : TCBaseViewController

@property (copy, nonatomic) NSString *meetingRoomID;

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) NSDate *selectedDate;

@property (strong, nonatomic) TCBookingDate *bookingDate;
@property (strong, nonatomic) TCBookingTime *startBookingTime;
@property (strong, nonatomic) TCBookingTime *endBookingTime;

/** 原始的起始时间，修改时间时使用 */
@property (strong, nonatomic) TCBookingDate *originalBookingDate;
@property (strong, nonatomic) TCBookingTime *originalStartBookingTime;
@property (strong, nonatomic) TCBookingTime *originalEndBookingTime;

@property (weak, nonatomic) id<TCMeetingRoomBookingTimeViewControllerDelegate> delegate;

@end

@protocol TCMeetingRoomBookingTimeViewControllerDelegate <NSObject>

@optional
- (void)didClickConfirmButtonInBookingTimeViewController:(TCMeetingRoomBookingTimeViewController *)vc;

@end
