//
//  BaofuFuFingerClient.h/Users/baofoocom/Desktop/宝付sdk/邦盛金融设备指纹采集/BaoFuFingerAcquistSDKDemo/BaoFuFingerAcquistSDKDemo
//  BaoFuFingerAcquistSDKDemo
//
//  Created by 路国良 on 16/11/8.
//  Copyright © 2016年 baofoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaofuFuFingerClientDelegate <NSObject>

-(void)initialSucess;
-(void)initialfailed:(NSString*)errorMessage;

@end


@interface BaofuFuFingerClient : NSObject

/*
 0:测试环境
 1:准生产环境
 2:正式环境
 */
typedef NS_ENUM(NSInteger,operationalState){
    operational_test = 0,
    operational_associateProduction,
    operational_true
};
@property(nonatomic,assign)operationalState operState;

@property(nonatomic,retain)id<BaofuFuFingerClientDelegate>delegate;
/**
 *  初始化认证器实例
 *
 *  @param sessionId 参数
 *
 */
- (instancetype)initWithSessionId:(NSString*)sessionId andoperationalState:(operationalState)operState;
@end
