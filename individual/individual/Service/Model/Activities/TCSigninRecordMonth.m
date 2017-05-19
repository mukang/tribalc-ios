//
//  TCSigninRecordMonth.m
//  individual
//
//  Created by 穆康 on 2017/5/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSigninRecordMonth.h"
#import "TCSigninRecordDay.h"

@implementation TCSigninRecordMonth

+ (NSDictionary *)objectClassInArray {
    return @{@"monthRecords": [TCSigninRecordDay class]};
}

@end
