//
//  TCPrivilege.h
//  individual
//
//  Created by 王帅锋 on 2017/7/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCPrivilege : NSObject

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *ownerId;

@property (copy, nonatomic) NSString *type;

@property (assign, nonatomic) CGFloat condition;

@property (assign, nonatomic) CGFloat value;

@property (copy, nonatomic) NSArray *activityTime;

@property (assign, nonatomic) NSInteger startDate;

@property (assign, nonatomic) NSInteger endDate;

@end
