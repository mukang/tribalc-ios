//
//  TCBuluoApi.h
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCModelImport.h"

extern NSString *const TCBuluoApiNotificationUserDidLogin;
extern NSString *const TCBuluoApiNotificationUserDidLogout;
extern NSString *const TCBuluoApiNotificationUserInfoDidUpdate;

@interface TCBuluoApi : NSObject

/**
 获取api实例
 
 @return 返回TCBuluoApi实例
 */
+ (instancetype)api;

#pragma mark - 设备相关

@property (nonatomic, assign, readonly, getter=isPrepared) BOOL prepared;

/**
 准备工作

 @param completion 准备完成回调
 */
- (void)prepareForWorking:(void(^)(NSError * error))completion;

#pragma mark - 用户会话相关

/**
 检查是否需要重新登录

 @return 返回BOOL类型的值，YES表示需要，NO表示不需要
 */
- (BOOL)needLogin;

/**
 获取当前已登录用户的会话

 @return 返回currentUserSession实例，返回nil表示当前没有保留的已登录会话或会话已过期
 */
- (TCUserSession *)currentUserSession;

#pragma mark - 普通用户资源

/**
 用户登录，登录后会保留登录状态

 @param loginInfo 用户登录信息，TCUserLoginInfo对象
 @param resultBlock 结果回调，userSession为nil时表示登录失败，失败原因见error的code和userInfo
 */
- (void)login:(TCUserLoginInfo *)loginInfo result:(void (^)(TCUserSession *userSession, NSError *error))resultBlock;

/**
 获取用户基本信息

 @param userID 用户ID
 @param resultBlock 结果回调，userInfo为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchUserInfoWithUserID:(NSString *)userID result:(void (^)(TCUserInfo *userInfo, NSError *error))resultBlock;

/**
 获取用户敏感信息

 @param userID 用户ID
 @param resultBlock 结果回调，userSensitiveInfo为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchUserSensitiveInfoWithUserID:(NSString *)userID result:(void (^)(TCUserSensitiveInfo *userSensitiveInfo, NSError *error))resultBlock;

/**
 修改用户昵称
 
 @param nickName 要改为的昵称
 @param resultBlock 结果回调，success为NO时表示获取失败，失败原因见error的code和userInfo
 */
- (void)changeUserNickName:(NSString *)nickName result:(void (^)(BOOL success, NSError *error))resultBlock;

#pragma mark - 验证码资源

/**
 获取手机验证码
 
 @param phone 手机号码
 @param resultBlock 结果回调，success为NO时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchVerificationCodeWithPhone:(NSString *)phone result:(void (^)(BOOL success, NSError *error))resultBlock;



@end
