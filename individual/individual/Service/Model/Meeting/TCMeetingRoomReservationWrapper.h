//
//  TCMeetingRoomReservationWrapper.h
//  individual
//
//  Created by 王帅锋 on 2017/11/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCMeetingRoomReservationWrapper : NSObject

@property (copy, nonatomic) NSArray *content;

@property (assign, nonatomic) BOOL hasMore;
/** 当前结果中的前置跳过 */
@property (copy, nonatomic) NSString *prevSkip;
/** 当前结果中的最后跳过规则，可用于下次查询 */
@property (copy, nonatomic) NSString *nextSkip;
/** 排序 */
@property (copy, nonatomic) NSString *sort;

@property (copy, nonatomic) NSString *status;

@end
