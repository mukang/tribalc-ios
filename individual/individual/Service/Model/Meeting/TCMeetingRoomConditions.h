//
//  TCMeetingRoomConditions.h
//  individual
//
//  Created by 王帅锋 on 2017/10/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCMeetingRoomConditions : NSObject

@property (copy, nonatomic) NSString *startFloor;

@property (copy, nonatomic) NSString *endFloor;

@property (copy, nonatomic) NSString *number;

@property (copy, nonatomic) NSString *hours;

@property (copy, nonatomic) NSString *startDate;

@property (copy, nonatomic) NSString *endDate;

@property (copy, nonatomic) NSString *startDateStr;

@property (copy, nonatomic) NSString *endDateStr;

@property (strong, nonatomic) NSMutableSet *selectedDevices;

@end
