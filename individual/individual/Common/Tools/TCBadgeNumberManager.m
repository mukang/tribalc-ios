//
//  TCBadgeNumberManager.m
//  individual
//
//  Created by 穆康 on 2017/8/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBadgeNumberManager.h"
#import <TCCommonLibs/TCArchiveService.h>


@interface TCBadgeNumberManager ()

@property (strong, nonatomic) TCBadgeNumber *badgeNum;

@end

@implementation TCBadgeNumberManager

+ (instancetype)sharedManager {
    static TCBadgeNumberManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initPrivate];
    });
    return manager;
}

- (instancetype)initPrivate {
    if (self = [super init]) {
        TCBadgeNumber *temp = [[TCArchiveService sharedService] unarchiveObject:NSStringFromClass([TCBadgeNumber class])
                                                                   forLoginUser:nil
                                                                    inDirectory:TCArchiveCachesDirectory];
        _badgeNum = temp ? : [[TCBadgeNumber alloc] init];
    }
    return self;
}

- (void)updateAllBadgeNumbersByDictionary:(NSDictionary *)dic {
    if (dic) {
        NSDictionary *badgeNumDic = [dic objectForKey:@"messageTypeCount"];
        if (badgeNumDic && [badgeNumDic isKindOfClass:[NSDictionary class]]) {
            self.badgeNum.badgeNumDic = badgeNumDic;
        } else {
            self.badgeNum.badgeNumDic = nil;
        }
        
        BOOL success = [[TCArchiveService sharedService] archiveObject:self.badgeNum
                                                          forLoginUser:nil
                                                           inDirectory:TCArchiveCachesDirectory];
        if (success) {
            TCLog(@"应用内BadgeNumber更新成功！");
        } else {
            TCLog(@"应用内BadgeNumber更新失败！");
        }
    }
}

- (void)cleanAllBadgeNumbers {
    self.badgeNum.badgeNumDic = nil;
    [[TCArchiveService sharedService] archiveObject:self.badgeNum
                                       forLoginUser:nil
                                        inDirectory:TCArchiveCachesDirectory];
}

- (void)addBadgeNumber:(NSInteger)addNum messageType:(NSString *)type {
    NSDictionary *badgeNumDic = self.badgeNum.badgeNumDic;
    if (badgeNumDic == nil) {
        badgeNumDic = [NSDictionary dictionary];
    }
    
    NSNumber *num = [badgeNumDic objectForKey:type];
    if (num) {
        NSInteger newNum = [num integerValue] + addNum;
        [badgeNumDic setValue:[NSNumber numberWithInteger:newNum] forKey:type];
    } else {
        [badgeNumDic setValue:[NSNumber numberWithInteger:addNum] forKey:type];
    }
    self.badgeNum.badgeNumDic = badgeNumDic;
    [[TCArchiveService sharedService] archiveObject:self.badgeNum
                                       forLoginUser:nil
                                        inDirectory:TCArchiveCachesDirectory];
}

- (void)deleteBadgeNumber:(NSInteger)deleteNum messageType:(NSString *)type {
    NSDictionary *badgeNumDic = self.badgeNum.badgeNumDic;
    if (badgeNumDic == nil) {
        return;
    }
    
    NSNumber *num = [badgeNumDic objectForKey:type];
    if (num) {
        NSInteger newNum = [num integerValue] - deleteNum;
        if (newNum > 0) {
            [badgeNumDic setValue:[NSNumber numberWithInteger:newNum] forKey:type];
            self.badgeNum.badgeNumDic = badgeNumDic;
        } else {
            NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:badgeNumDic];
            [temp removeObjectForKey:type];
            self.badgeNum.badgeNumDic = [temp copy];
        }
        [[TCArchiveService sharedService] archiveObject:self.badgeNum
                                           forLoginUser:nil
                                            inDirectory:TCArchiveCachesDirectory];
    }
}

- (void)deleteBadgeNumberByMessageType:(NSString *)type {
    NSDictionary *badgeNumDic = self.badgeNum.badgeNumDic;
    if (badgeNumDic == nil) {
        return;
    }
    
    NSMutableDictionary *temp = [NSMutableDictionary dictionaryWithDictionary:badgeNumDic];
    [temp removeObjectForKey:type];
    
    self.badgeNum.badgeNumDic = [temp copy];
    [[TCArchiveService sharedService] archiveObject:self.badgeNum
                                       forLoginUser:nil
                                        inDirectory:TCArchiveCachesDirectory];
}

- (NSInteger)getBadgeNumberByMessageType:(NSString *)type {
    NSDictionary *badgeNumDic = self.badgeNum.badgeNumDic;
    if (badgeNumDic == nil) {
        return 0;
    }
    
    NSNumber *num = [badgeNumDic objectForKey:type];
    return [num integerValue];
}

@end


@implementation TCBadgeNumber

@end
