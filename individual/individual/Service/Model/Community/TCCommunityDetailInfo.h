//
//  TCCommunityDetailInfo.h
//  individual
//
//  Created by 穆康 on 2016/11/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCCommunityDetailInfo : NSObject

/** 社区ID */
@property (copy, nonatomic) NSString *ID;
/** 社区名称 */
@property (copy, nonatomic) NSString *name;
/** 详细地址 */
@property (copy, nonatomic) NSString *address;
/** 联系电话 */
@property (copy, nonatomic) NSString *phone;
/** 社区主图 */
@property (copy, nonatomic) NSString *mainPicture;
/** 图片数组 */
@property (copy, nonatomic) NSArray *pictures;
/** 城市 */
@property (copy, nonatomic) NSString *city;
/** 区域 */
@property (copy, nonatomic) NSString *district;
/** 描述 */
@property (copy, nonatomic) NSString *desc;
/** 地图图片地址 */
@property (copy, nonatomic) NSString *map;
/** 社区周边餐饮列表 */
@property (copy, nonatomic) NSArray *repastList;
/** 社区周边娱乐列表 */
@property (copy, nonatomic) NSArray *entertainmentList;

@end
