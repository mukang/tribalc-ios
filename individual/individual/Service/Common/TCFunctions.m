//
//  TCFunctions.m
//  individual
//
//  Created by 穆康 on 2016/10/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCFunctions.h"
#import <sys/utsname.h>
#import <UIKit/UIKit.h>

#ifndef _TCFUNCTIONS_M
#define _TCFUNCTIONS_M

#pragma mark - 设备操作

NSString * TCGetDeviceModel() {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

NSString * TCGetDeviceUUID() {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

NSString * TCGetDeviceOSVersion() {
    return [NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]];
}

NSString * TCGetAppIdentifier() {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
}

NSString * TCGetAppVersion() {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

NSString * TCGetAppBuildVersion() {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

NSString * TCGetAppFullVersion() {
    return [NSString stringWithFormat:@"%@ (Build %@)", TCGetAppVersion(), TCGetAppBuildVersion()];
}

#endif
