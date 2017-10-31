//
//  TCMeetingRoom.h
//  individual
//
//  Created by 王帅锋 on 2017/10/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCMeetingRoom : NSObject

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *communityId;

@property (copy, nonatomic) NSString *name;

@property (assign, nonatomic) CGFloat fee;

@property (assign, nonatomic) NSInteger floor;

@property (assign, nonatomic) NSInteger galleryful;

@property (assign, nonatomic) NSInteger maxGalleryful;

@property (assign, nonatomic) int openTime;

@property (assign, nonatomic) int closeTime;

@property (copy, nonatomic) NSArray *equipments;

@property (copy, nonatomic) NSArray *pictures;

@end
