//
//  TCAppConfigs.h
//  individual
//
//  Created by 穆康 on 2017/5/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 应用配置信息
 */
@interface TCAppConfigs : NSObject

/** 最新版本号 */
@property (copy, nonatomic) NSString *lastVersion;
/** 当前版本是否仍被支持 */
@property (nonatomic) BOOL supported;
/** 接口URL路由标记 */
@property (copy, nonatomic) NSString *router;

@end
