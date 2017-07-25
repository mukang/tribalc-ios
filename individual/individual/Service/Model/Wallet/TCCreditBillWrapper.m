//
//  TCCreditBillWrapper.m
//  individual
//
//  Created by 王帅锋 on 2017/7/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCreditBillWrapper.h"
#import "TCCreditBill.h"

@implementation TCCreditBillWrapper

+ (NSDictionary *)objectClassInArray {
    return @{@"content": [TCCreditBill class]};
}

@end
