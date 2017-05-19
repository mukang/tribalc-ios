//
//  TCSigninRecordMonth.h
//  individual
//
//  Created by 穆康 on 2017/5/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCSigninRecordDay;

@interface TCSigninRecordMonth : NSObject

/** 月编号（1-12） */
@property (nonatomic) NSInteger monthNumber;
/** 本月签到记录 */
@property (copy, nonatomic) NSArray *monthRecords;

@end
