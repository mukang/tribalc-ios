//
//  TCSigninRecordDay.h
//  individual
//
//  Created by 穆康 on 2017/5/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCSigninRecordDay : NSObject

/** 最后签到时间戳 */
@property (nonatomic) long long lastTimestamp;
/** 连续签到天数 */
@property (nonatomic) NSInteger continuityDays;

@end
