//
//  TCBookingTime.h
//  individual
//
//  Created by 穆康 on 2017/10/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TCBookingTimeStatus) {
    TCBookingTimeStatusNormal,
    TCBookingTimeStatusSelected,
    TCBookingTimeStatusDisabled
};

@interface TCBookingTime : NSObject

/** 标号 */
@property (nonatomic) int num;
/** 名字，例：t08A */
@property (copy, nonatomic) NSString *name;
/** 时间 */
@property (copy, nonatomic) NSString *timeStr;
/** 状态 */
@property (nonatomic) TCBookingTimeStatus status;

@end
