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

 @param phoneInfo 用户登录信息，TCUserPhoneInfo对象
 @param resultBlock 结果回调，userSession为nil时表示登录失败，失败原因见error的code和userInfo
 */
- (void)login:(TCUserPhoneInfo *)phoneInfo result:(void (^)(TCUserSession *userSession, NSError *error))resultBlock;

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
 
 @param nickname 要改为的昵称
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserNickname:(NSString *)nickname result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户头像

 @param avatar 用户头像地址
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserAvatar:(NSString *)avatar result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户性别

 @param gender 性别枚举值（只能传入TCUserGenderMale和TCUserGenderFemale）
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserGender:(TCUserGender)gender result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户出生日期

 @param birthdate 出生日期
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserBirthdate:(NSDate *)birthdate result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户情感状况

 @param emotionState 情感状况枚举值（不能传入TCUserEmotionStateUnknown）
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserEmotionState:(TCUserEmotionState)emotionState result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户常用地址

 @param userAddress 常用地址，TCUserAddress对象
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserAddress:(TCUserAddress *)userAddress result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户坐标

 @param coordinate 用户坐标，[经度, 维度]
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserCoordinate:(NSArray *)coordinate result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户手机（敏感信息）

 @param phoneInfo TCUserPhoneInfo对象
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserPhone:(TCUserPhoneInfo *)phoneInfo result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 修改用户默认收货地址

 @param chippingAddressID 收货地址ID
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserDefaultChippingAddress:(NSString *)chippingAddressID result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 添加用户收货地址

 @param chippingAddress 用户收货地址，TCUserChippingAddress对象
 @param resultBlock 结果回调，success为NO时表示添加失败，失败原因见error的code和userInfo
 */
- (void)addUserChippingAddress:(TCUserChippingAddress *)chippingAddress result:(void (^)(BOOL success, TCUserChippingAddress *chippingAddress, NSError *error))resultBlock;

/**
 获取用户收货地址列表

 @param resultBlock 结果回调，addressList为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchUserChippingAddressList:(void (^)(NSArray *addressList, NSError *error))resultBlock;

/**
 获取用户单个收货地址

 @param chippingAddressID 收货地址ID
 @param resultBlock 结果回调，chippingAddress为nil时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchUserChippingAddress:(NSString *)chippingAddressID result:(void (^)(TCUserChippingAddress *chippingAddress, NSError *error))resultBlock;

/**
 修改用户收货地址

 @param chippingAddress TCUserChippingAddress对象
 @param resultBlock 结果回调，success为NO时表示修改失败，失败原因见error的code和userInfo
 */
- (void)changeUserChippingAddress:(TCUserChippingAddress *)chippingAddress result:(void (^)(BOOL success, NSError *error))resultBlock;

/**
 删除用户收货地址

 @param chippingAddressID 收货地址ID
 @param resultBlock 结果回调，success为NO时表示删除失败，失败原因见error的code和userInfo
 */
- (void)deleteUserChippingAddress:(NSString *)chippingAddressID result:(void (^)(BOOL success, NSError *error))resultBlock;

#pragma mark - 验证码资源

/**
 获取手机验证码
 
 @param phone 手机号码
 @param resultBlock 结果回调，success为NO时表示获取失败，失败原因见error的code和userInfo
 */
- (void)fetchVerificationCodeWithPhone:(NSString *)phone result:(void (^)(BOOL success, NSError *error))resultBlock;



@end
