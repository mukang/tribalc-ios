//
//  TCBadgeNumberManager.h
//  individual
//
//  Created by 穆康 on 2017/8/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCBadgeNumberManager : NSObject

+ (instancetype)sharedManager;

- (void)updateAllBadgeNumbersByDictionary:(NSDictionary *)dic;
- (void)cleanAllBadgeNumbers;

- (void)addBadgeNumber:(NSInteger)addNum messageType:(NSString *)type;
- (void)deleteBadgeNumber:(NSInteger)deleteNum messageType:(NSString *)type;
- (void)deleteBadgeNumberByMessageType:(NSString *)type;

- (NSInteger)getBadgeNumberByMessageType:(NSString *)type;

@end



@interface TCBadgeNumber : NSObject

@property (copy, nonatomic) NSDictionary *badgeNumDic;

@end
