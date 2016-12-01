//
//  TCOrderWrapper.m
//  individual
//
//  Created by WYH on 16/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCOrderWrapper.h"
#import "TCOrder.h"

@implementation TCOrderWrapper

+ (NSDictionary *)objectClassInArray {
    return @{@"content": [TCOrder class]};
}


@end
