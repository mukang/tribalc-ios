//
//  TCAppDelegate+Push.m
//  individual
//
//  Created by 穆康 on 2017/8/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCAppDelegate+Push.h"

#import <XGPush.h>
#import <XGSetting.h>

#import "TCTabBarController.h"
#import "TCNavigationController.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>

@interface TCAppDelegate() <UNUserNotificationCenterDelegate>
@end
#endif

@interface TCAppDelegate ()

@end

@implementation TCAppDelegate (Push)

- (void)pushApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[XGSetting getInstance] enableDebug:YES];
    [XGPush startApp:2200259391 appKey:@"IWZ2X9187TVW"];
    
    [XGPush isPushOn:^(BOOL isPushOn) {
        TCLog(@"[XGDemo] Push Is %@", isPushOn ? @"ON" : @"OFF");
    }];
    
    [self registerAPNS];
    
    [XGPush handleLaunching:launchOptions successCallback:^{
        TCLog(@"[XGDemo] Handle launching success");
    } errorCallback:^{
        TCLog(@"[XGDemo] Handle launching error");
    }];
}

- (void)pushApplication:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken account:@"myAccount" successCallback:^{
        TCLog(@"[XGDemo] register push success");
    } errorCallback:^{
        TCLog(@"[XGDemo] register push error");
    }];
    NSLog(@"[XGDemo] device token is %@", deviceTokenStr);
}

- (void)pushApplication:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

/**
 收到通知的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 */
- (void)pushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          TCLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          TCLog(@"[XGDemo] Handle receive error");
                      }];
}

/**
 收到静默推送的回调
 
 @param application  UIApplication 实例
 @param userInfo 推送时指定的参数
 @param completionHandler 完成回调
 */
- (void)pushApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [XGPush handleReceiveNotification:userInfo
                      successCallback:^{
                          TCLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          TCLog(@"[XGDemo] Handle receive error");
                      }];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

// iOS 10 新增 API
// iOS 10 会走新 API, iOS 10 以前会走到老 API
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// App 用户点击通知的回调
// 无论本地推送还是远程推送都会走这个回调
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    NSLog(@"[XGDemo] click notification");
    [XGPush handleReceiveNotification:response.notification.request.content.userInfo
                      successCallback:^{
                          TCLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          TCLog(@"[XGDemo] Handle receive error");
                      }];
    
    completionHandler();
}

// App 在前台弹通知需要调用这个接口
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}
#endif

- (void)registerAPNS {
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (sysVer >= 10) {
        // iOS 10
        [self registerPush10];
    } else if (sysVer >= 8) {
        // iOS 8-9
        [self registerPush8to9];
    } else {
        // before iOS 8
        
    }
#else
    if (sysVer < 8) {
        // before iOS 8
        [self registerPushBefore8];
    } else {
        // iOS 8-9
        [self registerPush8to9];
    }
#endif
}

- (void)registerPush10{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    
    [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
        }
    }];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
}

- (void)registerPush8to9{
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)handlePushNotiWithDic:(NSDictionary *)dic {
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *str = dic[@"router"];
        if ([str isKindOfClass:[NSString class]]) {
            if ([str hasPrefix:@"signin://"]) {
                TCTabBarController *tabVC = (TCTabBarController *)self.window.rootViewController;
                TCNavigationController *navVC = tabVC.selectedViewController;
                if (navVC) {
                    [navVC popToRootViewControllerAnimated:NO];
                    tabVC.selectedIndex = 3;
                }
            }
        }
    }
    
}



@end
