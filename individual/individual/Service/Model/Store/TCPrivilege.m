//
//  TCPrivilege.m
//  individual
//
//  Created by 王帅锋 on 2017/7/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPrivilege.h"

@implementation TCPrivilege

- (void)setType:(NSString *)type {
    _type = type;
    
    if ([type isEqualToString:@"DISCOUNT"]) {
        _privilegeType = TCPrivilegeTypeDiscount;
    } else if ([type isEqualToString:@"REDUCE"]) {
        _privilegeType = TCPrivilegeTypeReduce;
    } else if ([type isEqualToString:@"ALIQUOT"]) {
        _privilegeType = TCPrivilegeTypeAliquot;
    }
}

@end
