//
//  TCTestBoss.m
//  individual
//
//  Created by 穆康 on 2016/10/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCTestBoss.h"

@implementation TCTestBoss

+ (NSDictionary *)objectClassInArray {
    return @{@"staffs": [TCTestStaff class]};
}

+ (NSDictionary *)objectClassInDictionary {
    return @{@"manager": [TCTestStaff class]};
}

@end



@implementation TCTestStaff

+ (NSDictionary *)objectClassInArray {
    return @{@"littleDogs": [TCTestDog class]};
}

+ (NSDictionary *)objectClassInDictionary {
    return @{@"dog": [TCTestDog class]};
}

@end



@implementation TCTestDog

@end

