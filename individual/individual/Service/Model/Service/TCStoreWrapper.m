//
//  TCStoreWrapper.m
//  individual
//
//  Created by 王帅锋 on 2017/7/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStoreWrapper.h"
#import "TCListStore.h"

@implementation TCStoreWrapper

+ (NSDictionary *)objectClassInArray {
    return @{@"content": [TCListStore class]};
}

@end
