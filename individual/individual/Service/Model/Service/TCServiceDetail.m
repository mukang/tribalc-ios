//
//  TCServiceDetail.m
//  individual
//
//  Created by WYH on 16/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCServiceDetail.h"

@implementation TCServiceDetail

+ (NSDictionary *)objectClassInDictionary {
    return @{
             @"store":[TCListStore class],
             @"detailStore": [TCDetailStore class]
             };
}



@end
