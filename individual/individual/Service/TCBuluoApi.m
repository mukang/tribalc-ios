//
//  TCBuluoApi.m
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBuluoApi.h"

#import "NSObject+TCModel.h"

#import "TCClient.h"
#import "TCFunctions.h"
#import "TCArchiveService.h"
#import "TCClientRequest.h"
#import "TCClientResponse.h"

NSString *const TCBuluoApiNotificationUserDidLogin = @"TCBuluoApiNotificationUserDidLogin";
NSString *const TCBuluoApiNotificationUserDidLogout = @"TCBuluoApiNotificationUserDidLogout";

@implementation TCBuluoApi {
    TCUserSession *_userSession;
}

+ (instancetype)api {
    static TCBuluoApi *api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[self class] new];
        [api loadArchivedUserSession];
    });
    return api;
}

#pragma mark - 设备相关

- (void)prepareForWorking:(void (^)(NSError *))completion {
    _prepared = YES;
    
    if (completion) {
        completion(nil);
    }
}

#pragma mark - 用户会话相关

- (void)loadArchivedUserSession {
    NSString *sessionModelName = NSStringFromClass([TCUserSession class]);
    TCArchiveService *archiveService = [TCArchiveService sharedService];
    TCUserSession *session = [archiveService unarchiveObject:sessionModelName
                                                forLoginUser:nil
                                                 inDirectory:TCArchiveDocumentDirectory];
    _userSession = session;
}

- (BOOL)isUserSessionValid {
    if (_userSession) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)needLogin {
    return ![self isUserSessionValid];
}

- (TCUserSession *)currentUserSession {
    if ([self isUserSessionValid]) {
        return _userSession;
    } else {
        return nil;
    }
}

- (void)setUserSession:(TCUserSession *)userSession {
    _userSession = userSession;
    if (userSession) {
        BOOL success = [[TCArchiveService sharedService] archiveObject:userSession
                                                          forLoginUser:nil
                                                           inDirectory:TCArchiveDocumentDirectory];
        if (success) {
            TCLog(@"UserSession归档成功");
        } else {
            TCLog(@"UserSession归档失败");
        }
    }
}

- (void)cleanUserSession {
    if (_userSession) {
        _userSession = nil;
    }
    BOOL success = [[TCArchiveService sharedService] cleanObject:NSStringFromClass([TCUserSession class])
                                                    forLoginUser:nil
                                                     inDirectory:TCArchiveDocumentDirectory];
    if (success) {
        TCLog(@"UserSession清除成功");
    } else {
        TCLog(@"UserSession清除失败");
    }
}

#pragma mark - 普通用户资源

- (void)login:(TCUserLoginInfo *)loginInfo result:(void (^)(TCUserSession *, NSError *))resultBlock {
    NSString *apiName = @"persons/login";
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
    NSDictionary *dic = [loginInfo toObjectDictionary];
    for (NSString *key in dic.allKeys) {
        [request setValue:dic[key] forParam:key];
    }
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        NSError *error = response.error;
        if (error) {
            [self setUserSession:nil];
            if (resultBlock) {
                resultBlock(nil, error);
            }
        } else {
            TCUserSession *userSession = [[TCUserSession alloc] initWithObjectDictionary:response.data];
            [self setUserSession:userSession];
            [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationUserDidLogin object:nil];
            if (resultBlock) {
                resultBlock(userSession, nil);
            }
        }
    }];
}

#pragma mark - 验证码资源

- (void)fetchVerificationCodeWithPhone:(NSString *)phone result:(void (^)(BOOL, NSError *))resultBlock {
    NSString *apiName = @"verifications/phone";
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
    [request setValue:phone forParam:@"value"];
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.statusCode == 202) {
            if (resultBlock) {
                resultBlock(YES, nil);
            }
        } else {
            if (resultBlock) {
                resultBlock(NO, response.error);
            }
        }
    }];
}
































@end
