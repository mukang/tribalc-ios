//
//  TCAppDelegate.m
//  individual
//
//  Created by 穆康 on 2016/10/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCAppDelegate.h"
#import "TCTabBarController.h"
#import "TCLaunchViewController.h"
#import "TCUnitySetUpViewController.h"
#import "TCNavigationController.h"

#import "WXApiManager.h"
#import <Bugly/Bugly.h>

#import "TCBuluoApi.h"
#import "TCUserDefaultsKeys.h"
#import "TCPromotionsManager.h"

#import "TCAppDelegate+Push.h"

@interface TCAppDelegate ()

@end

@implementation TCAppDelegate

static NSString *const kBuglyAppID = @"900059019";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    TCTabBarController *tabBarController = [[TCTabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    [self registerNotifications];
    
    [self showLaunchWindow];
    application.statusBarHidden = NO;
    
    // 获取应用初始化信息
    [self setupAppInitializedInfo];
    
    // wechat
    [WXApi registerApp:kWXAppID];
    
    // Bugly
    [Bugly startWithAppId:kBuglyAppID];
    
    // 推送
    [self pushApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

#pragma mark - 推送相关

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self pushApplication:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [self pushApplication:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self pushApplication:application didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self pushApplication:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
}

#pragma mark - 启动视窗相关

/** 显示启动视窗 */
- (void)showLaunchWindow {
    TCLaunchViewController *launchViewController = [[TCLaunchViewController alloc] init];
    self.launchWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.launchWindow.rootViewController = launchViewController;
    self.launchWindow.windowLevel = UIWindowLevelAlert;
    self.launchWindow.hidden = NO;
    launchViewController.launchWindow = self.launchWindow;
}

#pragma mark - 初始化信息

- (void)setupAppInitializedInfo {
    [[TCBuluoApi api] fetchAppInitializationInfo:^(TCAppInitializationInfo *info, NSError *error) {
        if (info.promotions) {
            [[TCPromotionsManager sharedManager] storePromotionsAndLoadImageWithPromotions:info.promotions];
        }
        if (info.switches) {
            BOOL recharge = YES, withdraw = YES;
            recharge = info.switches.bf_recharge;
            withdraw = info.switches.bf_withdraw;
            [[NSUserDefaults standardUserDefaults] setObject:@(recharge) forKey:TCUserDefaultsKeySwitchBfRecharge];
            [[NSUserDefaults standardUserDefaults] setObject:@(withdraw) forKey:TCUserDefaultsKeySwitchBfWithdraw];
        }
    }];
}

#pragma mark - Notification

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleLaunchWindowDidDisappear)
                                                 name:TCLaunchWindowDidDisappearNotification object:nil];
}

#pragma mark - Actions

- (void)handleLaunchWindowDidDisappear {
    self.launchWindow.rootViewController = nil;
    self.launchWindow = nil;
}

#pragma mark - 其它代理方法

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self loadUnReadPushNumber];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([url.absoluteString hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    if ([url.absoluteString hasPrefix:@"buluoindividual"]) {
        [self pushUnitySetUpViewController];
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.absoluteString hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
    }
    
    if ([url.absoluteString hasPrefix:@"buluoindividual"]) {
        [self pushUnitySetUpViewController];
        return YES;
    }
    
    return NO;
}

- (void)loadUnReadPushNumber {
    if (![[TCBuluoApi api] needLogin]) {
        [[TCBuluoApi api] fetchUnReadPushMessageNumberWithResult:^(NSDictionary *unreadNumDic, NSError *error) {
            if ([unreadNumDic isKindOfClass:[NSDictionary class]]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TCFetchUnReadMessageNumber" object:nil userInfo:unreadNumDic];
            }
        }];
    }
}

- (void)pushUnitySetUpViewController {
    TCUnitySetUpViewController *setUpVC = [[TCUnitySetUpViewController alloc] init];
    setUpVC.hidesBottomBarWhenPushed = YES;
    TCTabBarController *tabVC = (TCTabBarController *)self.window.rootViewController;
    TCNavigationController *navVC = tabVC.selectedViewController;
    if (navVC) {
        [navVC pushViewController:setUpVC animated:YES];
    }
}

@end
