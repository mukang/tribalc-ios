//
//  TCMultiLockKeyWrapper.m
//  individual
//
//  Created by 穆康 on 2017/5/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCMultiLockKeyWrapper.h"
#import "TCMultiLockKey.h"

@implementation TCMultiLockKeyWrapper

+ (NSDictionary *)objectClassInArray {
    return @{@"keys": [TCMultiLockKey class]};
}

@end
