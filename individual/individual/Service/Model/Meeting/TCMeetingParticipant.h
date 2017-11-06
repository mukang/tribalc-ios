//
//  TCMeetingParticipant.h
//  individual
//
//  Created by 王帅锋 on 2017/10/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCMeetingParticipant : NSObject

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *conferenceReservationId;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *phone;

@property (nonatomic, getter=isSelected) BOOL selected;

@property (copy, nonatomic) NSString *avatar;

@end
