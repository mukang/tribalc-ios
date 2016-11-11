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
#import "TCClientRequestError.h"

NSString *const TCBuluoApiNotificationUserDidLogin = @"TCBuluoApiNotificationUserDidLogin";
NSString *const TCBuluoApiNotificationUserDidLogout = @"TCBuluoApiNotificationUserDidLogout";
NSString *const TCBuluoApiNotificationUserInfoDidUpdate = @"TCBuluoApiNotificationUserInfoDidUpdate";

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

- (void)fetchCurrentUserInfoWithUserID:(NSString *)userID {
    [self fetchUserInfoWithUserID:userID result:^(TCUserInfo *userInfo, NSError *error) {
        if (userInfo) {
            TCUserSession *userSession = self.currentUserSession;
            userSession.userInfo = userInfo;
            [self setUserSession:userSession];
            [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationUserInfoDidUpdate object:nil];
        }
    }];
}

- (void)fetchCurrentUserSensitiveInfoWithUserID:(NSString *)userID {
    [self fetchUserSensitiveInfoWithUserID:userID result:^(TCUserSensitiveInfo *userSensitiveInfo, NSError *error) {
        if (userSensitiveInfo) {
            TCUserSession *userSession = self.currentUserSession;
            userSession.userSensitiveInfo = userSensitiveInfo;
            [self setUserSession:userSession];
        }
    }];
}

#pragma mark - 普通用户资源

- (void)login:(TCUserPhoneInfo *)phoneInfo result:(void (^)(TCUserSession *, NSError *))resultBlock {
    NSString *apiName = @"persons/login";
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
    NSDictionary *dic = [phoneInfo toObjectDictionary];
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
            [self fetchCurrentUserInfoWithUserID:userSession.assigned];
            [self fetchCurrentUserSensitiveInfoWithUserID:userSession.assigned];
            [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationUserDidLogin object:nil];
            if (resultBlock) {
                resultBlock(userSession, nil);
            }
        }
    }];
}

- (void)fetchUserInfoWithUserID:(NSString *)userID result:(void (^)(TCUserInfo *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"persons/%@", userID];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        NSError *error = response.error;
        if (error) {
            if (resultBlock) {
                resultBlock(nil, error);
            }
        } else {
            TCUserInfo *userInfo = [[TCUserInfo alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                resultBlock(userInfo, nil);
            }
        }
    }];
}

- (void)fetchUserSensitiveInfoWithUserID:(NSString *)userID result:(void (^)(TCUserSensitiveInfo *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"persons/%@/sensitive_info", userID];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        NSError *error = response.error;
        if (error) {
            if (resultBlock) {
                resultBlock(nil, error);
            }
        } else {
            TCUserSensitiveInfo *info = [[TCUserSensitiveInfo alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                resultBlock(info, nil);
            }
        }
    }];
}

- (void)changeUserNickname:(NSString *)nickname result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/nickname", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        [request setValue:nickname forParam:@"nickname"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.nickname = nickname;
                [self setUserSession:userSession];
                if (resultBlock) {
                    resultBlock(YES, nil);
                }
            } else {
                if (resultBlock) {
                    resultBlock(NO, response.error);
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            resultBlock(NO, sessionError);
        }
    }
}

- (void)changeUserAvatar:(NSString *)avatar result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/picture", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        [request setValue:avatar forParam:@"picture"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.picture = avatar;
                [self setUserSession:userSession];
                if (resultBlock) {
                    resultBlock(YES, nil);
                }
            } else {
                if (resultBlock) {
                    resultBlock(NO, response.error);
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            resultBlock(NO, sessionError);
        }
    }
}

- (void)changeUserGender:(TCUserGender)gender result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/sex", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        NSString *sex = nil;
        switch (gender) {
            case TCUserGenderMale:
                sex = @"MALE";
                break;
            case TCUserGenderFemale:
                sex = @"FEMALE";
                break;
            default:
                break;
        }
        [request setValue:sex forParam:@"sex"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.sex = sex;
                userSession.userInfo.gender = gender;
                [self setUserSession:userSession];
                if (resultBlock) {
                    resultBlock(YES, nil);
                }
            } else {
                if (resultBlock) {
                    resultBlock(NO, response.error);
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            resultBlock(NO, sessionError);
        }
    }
}

- (void)changeUserBirthdate:(NSDate *)birthdate result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/birthday", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        NSTimeInterval timestamp = [birthdate timeIntervalSince1970];
        [request setValue:[NSNumber numberWithUnsignedInteger:(NSUInteger)(timestamp * 1000)] forParam:@"birthday"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.birthday = (NSUInteger)(timestamp * 1000);
                [self setUserSession:userSession];
                if (resultBlock) {
                    resultBlock(YES, nil);
                }
            } else {
                if (resultBlock) {
                    resultBlock(NO, response.error);
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            resultBlock(NO, sessionError);
        }
    }
}

- (void)changeUserEmotionState:(TCUserEmotionState)emotionState result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/emotion", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        NSString *emotion = nil;
        switch (emotionState) {
            case TCUserEmotionStateMarried:
                
                break;
            case TCUserEmotionStateSingle:
                emotion = @"SINGLE";
                break;
            case TCUserEmotionStateLove:
                
                break;
            default:
                break;
        }
        [request setValue:emotion forKey:@"emotion"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.emotion = emotion;
                userSession.userInfo.emotionState = emotionState;
                [self setUserSession:userSession];
                if (resultBlock) {
                    resultBlock(YES, nil);
                }
            } else {
                if (resultBlock) {
                    resultBlock(NO, response.error);
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            resultBlock(NO, sessionError);
        }
    }
}

- (void)changeUserAddress:(TCUserAddress *)userAddress result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/province,city,district", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        NSDictionary *dic = [userAddress toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.province = userAddress.province;
                userSession.userInfo.city = userAddress.city;
                userSession.userInfo.district = userAddress.district;
                [self setUserSession:userSession];
                if (resultBlock) {
                    resultBlock(YES, nil);
                }
            } else {
                if (resultBlock) {
                    resultBlock(NO, response.error);
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            resultBlock(NO, sessionError);
        }
    }
}

- (void)changeUserCoordinate:(NSArray *)coordinate result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/coordinate", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        [request setValue:coordinate forParam:@"coordinate"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.coordinate = coordinate;
                [self setUserSession:userSession];
                if (resultBlock) {
                    resultBlock(YES, nil);
                }
            } else {
                if (resultBlock) {
                    resultBlock(NO, response.error);
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            resultBlock(NO, sessionError);
        }
    }
}

- (void)changeUserPhone:(TCUserPhoneInfo *)phoneInfo result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/sensitive_info/phone", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        NSDictionary *dic = [phoneInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userSensitiveInfo.phone = phoneInfo.phone;
                [self setUserSession:userSession];
                if (resultBlock) {
                    resultBlock(YES, nil);
                }
            } else {
                if (resultBlock) {
                    resultBlock(NO, response.error);
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            resultBlock(NO, sessionError);
        }
    }
}

- (void)addUserChippingAddress:(TCUserChippingAddress *)chippingAddress result:(void (^)(BOOL, TCUserChippingAddress *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/addresses", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        NSDictionary *dic = [chippingAddress toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 201) {
                TCUserChippingAddress *address = [[TCUserChippingAddress alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    resultBlock(YES, address, nil);
                }
            } else {
                if (resultBlock) {
                    resultBlock(NO, nil, response.error);
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            resultBlock(NO, nil, sessionError);
        }
    }
}

- (void)fetchUserChippingAddressList:(void (^)(NSArray *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/addresses", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            NSError *error = response.error;
            if (error) {
                if (resultBlock) {
                    resultBlock(nil, error);
                }
            } else {
                NSMutableArray *addressList = [NSMutableArray array];
                NSArray *dics = response.data;
                for (NSDictionary *dic in dics) {
                    TCUserChippingAddress *address = [[TCUserChippingAddress alloc] initWithObjectDictionary:dic];
                    [addressList addObject:address];
                }
                if (resultBlock) {
                    resultBlock([addressList copy], nil);
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            resultBlock(nil, sessionError);
        }
    }
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
