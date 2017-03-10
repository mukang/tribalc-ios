//
//  TCLockKey.h
//  individual
//
//  Created by 王帅锋 on 17/3/10.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCLockKey : NSObject

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *ownerId;

@property (copy, nonatomic) NSString *equipId;

@property (assign, nonatomic) NSInteger createTime;

@property (assign, nonatomic) NSInteger beginTime;

@property (assign, nonatomic) NSInteger endTime;

@property (copy, nonatomic) NSString *key;

@property (copy, nonatomic) NSString *phone;

@property (copy, nonatomic) NSString *name;

@end

