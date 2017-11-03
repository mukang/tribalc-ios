//
//  TCMeetingRoomReservationDetail.h
//  individual
//
//  Created by 王帅锋 on 2017/11/2.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCMeetingRoomReservationDetail : NSObject

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) NSInteger floor;

@property (copy, nonatomic) NSString *communityName;

@property (assign, nonatomic) NSInteger openTime;

@property (assign, nonatomic) NSInteger closeTime;

@property (assign, nonatomic) int64_t conferenceBeginTime;

@property (assign, nonatomic) int64_t conferenceEndTime;

@property (copy, nonatomic) NSArray *equipmentList;

@property (assign, nonatomic) NSInteger galleryful;

@property (assign, nonatomic) NSInteger maxGalleryful;

@property (copy, nonatomic) NSString *personId;

@property (copy, nonatomic) NSString *personName;

@property (copy, nonatomic) NSString *personPhone;

@property (copy, nonatomic) NSString *subject;

@property (copy, nonatomic) NSArray *conferenceParticipants;

@property (copy, nonatomic) NSString *reservationNum;

@property (assign, nonatomic) int64_t createTime;

@property (assign, nonatomic) NSInteger reminderTime;

@property (assign, nonatomic) CGFloat totalFee;

@property (copy, nonatomic) NSString *picture;

@property (copy, nonatomic) NSString *status;

@property (assign, nonatomic) int64_t planEndTime;

@end
