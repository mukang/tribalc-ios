//
//  TCStoreWrapper.h
//  individual
//
//  Created by 王帅锋 on 2017/7/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCListStore.h"

@interface TCStoreWrapper : NSObject

/** 当前类别 */
@property (copy, nonatomic) NSString *category;
/** 当前排序规则 */
@property (copy, nonatomic) NSString *sort;
/** 当前结果中的前置跳过 */
@property (copy, nonatomic) NSString *prevSkip;
/** 当前结果中的最后跳过规则，可用于下次查询 */
@property (copy, nonatomic) NSString *nextSkip;
/** 是否还有条目待获取 */
@property (nonatomic) BOOL hasMore;
/** 服务列表，TCListStore对象数组 */
@property (copy, nonatomic) NSArray *content;

@end
