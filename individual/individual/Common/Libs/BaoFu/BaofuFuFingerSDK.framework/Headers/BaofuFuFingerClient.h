//
//  BaofuFuFingerClient.h
//  BaoFuFingerAcquistSDKDemo
//
//  Created by 路国良 on 16/11/8.
//  Copyright © 2016年 baofoo. All rights reserved.
//

/*--------------------------------------------------------------------------------------------
 版权所有：宝付网络科技（上海）有限公司
 版本号：1.1
 首次发版日期：20161108
 SDK名称：宝付风控设备指纹采集sdk
 文件描述：
 作者:    陆游
 创建描述：
 修改标示：
 修改描述：
 -----------------------------------------------------------------------------------------------*/

#import <Foundation/Foundation.h>

@protocol BaofuFuFingerClientDelegate <NSObject>

/**
 *  代理方法 初始化成功方法回调方法
 *
 */
-(void)initialSucess;

/**
 *  代理方法 初始化失败回调方法
 *
 *  @param errorMessage 错误描述信息
 */
-(void)initialfailed:(NSString*)errorMessage;

@end


@interface BaofuFuFingerClient : NSObject

/*
 *运行环境
 *
 * operational_test                    测试环境
 * operational_true                    正式环境
 */
typedef NS_ENUM(NSInteger,operationalState){
    operational_test = 0,
    operational_true
};
@property(nonatomic,assign)operationalState operState;

@property(nonatomic,weak)id<BaofuFuFingerClientDelegate>delegate;
/**
 *  初始化认证器实例
 *
 *  @param sessionId 参数
 *
 *  @param operState 操作环境枚举类型
 *
 */
- (instancetype)initWithSessionId:(NSString*)sessionId andoperationalState:(operationalState)operState;
@end
