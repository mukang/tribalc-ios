//
//  TCMeetingRoomBookingDetailViewController.h
//  individual
//
//  Created by 王帅锋 on 2017/10/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

typedef void(^DidCancelReservationBlock)();

@interface TCMeetingRoomBookingDetailViewController : TCBaseViewController

@property (copy, nonatomic) DidCancelReservationBlock block;

@property (copy, nonatomic) NSString *reservationID;

@property (assign, nonatomic) BOOL isCompany;

@end
