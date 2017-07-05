//
//  TCBuluoApi.m
//  individual
//
//  Created by 穆康 on 2016/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBuluoApi.h"
#import <TCCommonLibs/TCClient.h>
#import <TCCommonLibs/TCFunctions.h>
#import <TCCommonLibs/TCArchiveService.h>
#import <TCCommonLibs/NSObject+TCModel.h>

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
            if (userInfo.addressID) {
                [self fetchUserDefaultShippingAddressWithAddressID:userInfo.addressID];
            }
        }
    }];
}

- (void)fetchUserDefaultShippingAddressWithAddressID:(NSString *)addressID {
    [self fetchUserShippingAddress:addressID result:^(TCUserShippingAddress *shippingAddress, NSError *error) {
        if (shippingAddress) {
            TCUserSession *userSession = self.currentUserSession;
            userSession.userInfo.shippingAddress = shippingAddress;
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
        TCUserSession *userSession = nil;
        NSError *error = response.error;
        if (error) {
            [self setUserSession:nil];
        } else {
            userSession = [[TCUserSession alloc] initWithObjectDictionary:response.data];
            [self setUserSession:userSession];
            [self fetchCurrentUserInfoWithUserID:userSession.assigned];
            
            TC_CALL_ASYNC_MQ({
                [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationUserDidLogin object:nil];
            });
        }
        if (resultBlock) {
            if (error) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, error));
            } else {
                TC_CALL_ASYNC_MQ(resultBlock(userSession, nil));
            }
        }
    }];
}

- (void)logout:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
        }
    } else {
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
        }
    }
    [self cleanUserSession];
    [[NSNotificationCenter defaultCenter] postNotificationName:TCBuluoApiNotificationUserDidLogout object:nil];
}

- (void)fetchUserInfoWithUserID:(NSString *)userID result:(void (^)(TCUserInfo *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"persons/%@", userID];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        NSError *error = response.error;
        if (error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, error));
            }
        } else {
            TCUserInfo *userInfo = [[TCUserInfo alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(userInfo, nil));
            }
        }
    }];
}

- (void)changeUserNickname:(NSString *)nickname result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/nickname", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:nickname forParam:@"nickname"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.nickname = nickname;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeUserAvatar:(NSString *)avatar result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/picture", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:avatar forParam:@"picture"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.picture = avatar;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeUserCover:(NSString *)cover result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/cover", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:cover forParam:@"cover"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.cover = cover;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeUserGender:(TCUserGender)gender result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/sex", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        NSString *sex = @"UNKNOWN";
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
            if (response.codeInResponse == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.sex = sex;
                userSession.userInfo.gender = gender;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeUserBirthdate:(NSDate *)birthdate result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/birthday", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        NSTimeInterval timestamp = [birthdate timeIntervalSince1970];
        [request setValue:[NSNumber numberWithInteger:(timestamp * 1000)] forParam:@"birthday"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.birthday = (NSUInteger)(timestamp * 1000);
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeUserEmotionState:(TCUserEmotionState)emotionState result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/emotion", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        NSString *emotion = @"UNKNOWN";
        switch (emotionState) {
            case TCUserEmotionStateMarried:
                emotion = @"MARRIED";
                break;
            case TCUserEmotionStateSingle:
                emotion = @"SINGLE";
                break;
            case TCUserEmotionStateLove:
                emotion = @"LOVE";
                break;
            default:
                break;
        }
        [request setValue:emotion forKey:@"emotion"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.emotion = emotion;
                userSession.userInfo.emotionState = emotionState;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeUserAddress:(TCUserAddress *)userAddress result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/province,city,district", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [userAddress toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.province = userAddress.province;
                userSession.userInfo.city = userAddress.city;
                userSession.userInfo.district = userAddress.district;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeUserCoordinate:(NSArray *)coordinate result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/coordinate", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:coordinate forParam:@"coordinate"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.coordinate = coordinate;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeUserPhone:(TCUserPhoneInfo *)phoneInfo result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/phone", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [phoneInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.phone = phoneInfo.phone;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)setUserDefaultShippingAddress:(TCUserShippingAddress *)shippingAddress result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/addressID", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:shippingAddress.ID forKey:@"value"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo.addressID = shippingAddress.ID;
                userSession.userInfo.shippingAddress = shippingAddress;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)addUserShippingAddress:(TCUserShippingAddress *)shippingAddress result:(void (^)(BOOL, TCUserShippingAddress *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/addresses", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [shippingAddress toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 201) {
                TCUserShippingAddress *address = [[TCUserShippingAddress alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, address, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, nil, sessionError));
        }
    }
}

- (void)fetchUserShippingAddressList:(void (^)(NSArray *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/addresses", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            NSError *error = response.error;
            if (error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, error));
                }
            } else {
                NSMutableArray *addressList = [NSMutableArray array];
                NSArray *dics = response.data;
                for (NSDictionary *dic in dics) {
                    TCUserShippingAddress *address = [[TCUserShippingAddress alloc] initWithObjectDictionary:dic];
                    [addressList addObject:address];
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock([addressList copy], nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchUserShippingAddress:(NSString *)shippingAddressID result:(void (^)(TCUserShippingAddress *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/addresses/%@", self.currentUserSession.assigned, shippingAddressID];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCUserShippingAddress *address = [[TCUserShippingAddress alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(address, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)changeUserShippingAddress:(TCUserShippingAddress *)shippingAddress result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/addresses/%@", self.currentUserSession.assigned, shippingAddress.ID];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [shippingAddress toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                if ([shippingAddress.ID isEqualToString:self.currentUserSession.userInfo.addressID]) {
                    TCUserSession *userSession = self.currentUserSession;
                    userSession.userInfo.shippingAddress = shippingAddress;
                    [self setUserSession:userSession];
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)deleteUserShippingAddress:(NSString *)shippingAddressID result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/addresses/%@", self.currentUserSession.assigned, shippingAddressID];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodDelete apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 204) {
                if ([shippingAddressID isEqualToString:self.currentUserSession.userInfo.addressID]) {
                    TCUserSession *userSession = [self currentUserSession];
                    userSession.userInfo.addressID = nil;
                    userSession.userInfo.shippingAddress = nil;
                    [self setUserSession:userSession];
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)fetchCompanyBlindStatus:(void (^)(TCUserCompanyInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/company_bind_request", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCUserCompanyInfo *userCompanyInfo = [[TCUserCompanyInfo alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(userCompanyInfo, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)bindCompanyWithUserCompanyInfo:(TCUserCompanyInfo *)userCompanyInfo result:(void (^)(TCUserInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/company_bind_request", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:userCompanyInfo.company.ID forParam:@"value"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserInfo *userInfo = [[TCUserInfo alloc] initWithObjectDictionary:response.data];
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo = userInfo;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(userInfo, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)authorizeUserIdentity:(TCUserIDAuthInfo *)userIDAuthInfo result:(void (^)(TCUserInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/authentication", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [userIDAuthInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserInfo *userInfo = [[TCUserInfo alloc] initWithObjectDictionary:response.data];
                TCUserSession *userSession = self.currentUserSession;
                userSession.userInfo = userInfo;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(userInfo, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)reserveCommunity:(TCCommunityReservationInfo *)communityReservationInfo result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/community_reservation", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [communityReservationInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 201) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

#pragma mark - 钱包资源

- (void)fetchWalletAccountInfo:(void (^)(TCWalletAccount *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCWalletAccount *walletAccount = [[TCWalletAccount alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(walletAccount, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchWalletBillWrapper:(NSString *)tradingType count:(NSUInteger)count sortSkip:(NSString *)sortSkip result:(void (^)(TCWalletBillWrapper *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *tradingTypePart = tradingType ? [NSString stringWithFormat:@"tradingType=%@&", tradingType] : @"";
        NSString *limitSizePart = [NSString stringWithFormat:@"limitSize=%zd", count];
        NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/bills?%@%@%@", self.currentUserSession.assigned, tradingTypePart, limitSizePart, sortSkipPart];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCWalletBillWrapper *walletBillWrapper = [[TCWalletBillWrapper alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(walletBillWrapper, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)changeWalletPassword:(NSString *)messageCode anOldPassword:(NSString *)anOldPassword aNewPassword:(NSString *)aNewPassword result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName;
        if (messageCode) {
            apiName = [NSString stringWithFormat:@"wallets/%@/password?vcode=%@", self.currentUserSession.assigned, messageCode];
        } else {
            apiName = [NSString stringWithFormat:@"wallets/%@/password", self.currentUserSession.assigned];
        }
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:anOldPassword forParam:@"oldPassword"];
        [request setValue:aNewPassword forParam:@"newPassword"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)fetchBankCardList:(void (^)(NSArray *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/bank_cards", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                NSMutableArray *bankCardList = [NSMutableArray array];
                NSArray *dics = response.data;
                for (NSDictionary *dic in dics) {
                    TCBankCard *bankCard = [[TCBankCard alloc] initWithObjectDictionary:dic];
                    [bankCardList addObject:bankCard];
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock([bankCardList copy], nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)addBankCard:(TCBankCard *)bankCard withVerificationCode:(NSString *)verificationCode result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/bank_cards?vcode=%@", self.currentUserSession.assigned, verificationCode];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [bankCard toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 201) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)prepareAddBankCard:(TCBankCard *)bankCard result:(void (^)(TCBankCard *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/bank_cards", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [bankCard toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 201) {
                TCBankCard *card = [[TCBankCard alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(card, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)confirmAddBankCardWithID:(NSString *)bankCardID verificationCode:(NSString *)verificationCode result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/bank_cards/%@", self.currentUserSession.assigned, bankCardID];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:verificationCode forKey:@"value"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)deleteBankCard:(NSString *)bankCardID result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/bank_cards/%@", self.currentUserSession.assigned, bankCardID];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodDelete apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 204) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)commitPaymentRequest:(TCPaymentRequestInfo *)paymentRequestInfo payPurpose:(TCPayPurpose)payPurpose result:(void (^)(TCUserPayment *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *purpose = nil;
        switch (payPurpose) {
            case TCPayPurposeOrder:
                purpose = @"order";
                break;
            case TCPayPurposeMaintain:
                purpose = @"maintain";
                break;
            case TCPayPurposeFace2Face:
                purpose = @"face2face";
                break;
            case TCPayPurposeRent:
                purpose = @"rent";
                break;
                
            default:
                break;
        }
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/payments?type=%@", self.currentUserSession.assigned, purpose];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [paymentRequestInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        switch (paymentRequestInfo.payChannel) {
            case TCPayChannelBalance:
                [request setValue:@"BALANCE" forParam:@"payChannel"];
                break;
            case TCPayChannelAlipay:
                [request setValue:@"ALIPAY" forParam:@"payChannel"];
                break;
            case TCPayChannelWechat:
                [request setValue:@"WECHAT" forParam:@"payChannel"];
                break;
            case TCPayChannelBankCard:
                [request setValue:@"BF_BANKCARD" forParam:@"payChannel"];
                break;
                
            default:
                break;
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserPayment *payment = [[TCUserPayment alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(payment, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchUserPayment:(NSString *)paymentID result:(void (^)(TCUserPayment *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/payments/%@", self.currentUserSession.assigned, paymentID];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCUserPayment *payment = [[TCUserPayment alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(payment, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)commitWithdrawReqWithAmount:(double)amount bankCardID:(NSString *)bankCardID result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"wallets/%@/withdraw", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:[NSNumber numberWithDouble:amount] forParam:@"amount"];
        [request setValue:bankCardID forParam:@"bankCardId"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

#pragma mark - 验证码资源

- (void)fetchVerificationCodeWithPhone:(NSString *)phone result:(void (^)(BOOL, NSError *))resultBlock {
    NSString *apiName = @"verifications/phone";
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
    request.token = self.currentUserSession.token;
    [request setValue:phone forParam:@"value"];
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.codeInResponse == 202) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
            }
        } else {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
            }
        }
    }];
}

- (void)authorizeImageData:(NSData *)imageData result:(void (^)(TCUploadInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"oss_authorization/picture?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:@"iOS_image.jpg" forParam:@"key"];
        [request setValue:@"image/jpeg" forParam:@"contentType"];
        [request setValue:TCDigestMD5ToData(imageData) forParam:@"contentMD5"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCUploadInfo *uploadInfo = [[TCUploadInfo alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(uploadInfo, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

#pragma mark - 商品类资源

- (void)fetchGoodsWrapper:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip result:(void (^)(TCGoodsWrapper *, NSError *))resultBlock {
    NSString *limitSizePart = [NSString stringWithFormat:@"limitSize=%zd", limitSize];
    NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
    NSString *apiName = [NSString stringWithFormat:@"goods?%@%@", limitSizePart, sortSkipPart];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCGoodsWrapper *goodsWrapper = [[TCGoodsWrapper alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(goodsWrapper, nil));
            }
        }
    }];
}

- (void)fetchGoodDetail:(NSString *)goodsID result:(void (^)(TCGoodDetail *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"goods/%@", goodsID];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            
            TCGoodDetail *goodDetail = [[TCGoodDetail alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(goodDetail, nil));
            }
        }
    }];
}

- (void)fetchGoodStandards:(NSString *)goodStandardId result:(void (^)(TCGoodStandards *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"goods_standards/%@", goodStandardId];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCGoodStandards *goodStandard = [[TCGoodStandards alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(goodStandard, nil));
            }
        }
    }];
}



#pragma mark - 服务类资源

- (void)fetchServiceWrapperWithQuery:(NSString *)query result:(void (^)(TCServiceWrapper *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"store_set_meals?%@", query];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCServiceWrapper *serviceWrapper = [[TCServiceWrapper alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(serviceWrapper, nil));
            }
        }
    }];
}

- (void)fetchServiceDetail:(NSString *)serviceID result:(void (^)(TCServiceDetail *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"store_set_meals/%@", serviceID];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCServiceDetail *serviceDetail = [[TCServiceDetail alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(serviceDetail, nil));
            }
        }
    }];
}

#pragma mark - 订单类资源
- (void)fetchOrderWrapper:(NSString *)status limiSize:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip result:(void (^)(TCOrderWrapper *, NSError *))resultBlock {

    if ([self isUserSessionValid]) {
        NSString *statusPart = status ? [NSString stringWithFormat:@"&status=%@", status] : @"";
        NSString *limitSizePart = limitSize ? [NSString stringWithFormat:@"&limitSize=%lu", (unsigned long)limitSize] : @"";
        NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
        NSString *apiName = [NSString stringWithFormat:@"orders?type=owner&me=%@%@%@%@", self.currentUserSession.assigned, statusPart, limitSizePart, sortSkipPart];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCOrderWrapper *orderWrapper = [[TCOrderWrapper alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(orderWrapper, nil));
                }
            }
        }];
    }else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchOrderDetailWithOrderID:(NSString *)orderID result:(void (^)(TCOrder *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"orders/%@?me=%@", orderID, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCOrder *order = [[TCOrder alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(order, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)createOrderWithItemList:(NSArray *)itemList AddressId:(NSString *)addressId result:(void(^)(NSArray *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"orders?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;

        [request setValue:addressId forParam:@"addressId"];
        [request setValue:itemList forParam:@"itemList"];
        
        
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                NSArray *result = response.data;
                NSMutableArray *orderList = [[NSMutableArray alloc] init];
                for (int i = 0; i < result.count; i++) {
                    TCOrder *order = [[TCOrder alloc] initWithObjectDictionary:result[i]];
                    [orderList addObject:order];
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock([orderList copy], nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    }  else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)changeOrderStatus:(NSString *)statusStr OrderId:(NSString *)orderId result:(void(^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"orders/%@/status?type=owner&me=%@", orderId, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:statusStr forParam:@"value"];
        [[TCClient client] send:request finish:^(TCClientResponse *respone) {
            if (respone.codeInResponse == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, respone.error));
                }
            }
        }];
    }  else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeOrderStatus:(NSString *)status orderID:(NSString *)orderID result:(void (^)(BOOL, TCOrder *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"orders/%@/status?type=owner&me=%@", orderID, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:status forParam:@"value"];
        [[TCClient client] send:request finish:^(TCClientResponse *respone) {
            if (respone.codeInResponse == 200) {
                if (resultBlock) {
                    TCOrder *order = [[TCOrder alloc] initWithObjectDictionary:respone.data];
                    TC_CALL_ASYNC_MQ(resultBlock(YES, order, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, nil, respone.error));
                }
            }
        }];
    }  else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, nil, sessionError));
        }
    }
}


#pragma mark - 服务预订资源
- (void)fetchReservationWrapper:(NSString *)status limiSize:(NSUInteger)limitSize sortSkip:(NSString *)sortSkip result:(void (^)(TCReservationWrapper *, NSError *))resultBlock {
    
    if ([self isUserSessionValid]) {
        NSString *statusPart = status ? [NSString stringWithFormat:@"&status=%@", status] : @"";
        NSString *limitSizePart = limitSize ? [NSString stringWithFormat:@"&limitSize=%lu", (unsigned long)limitSize] : @"";
        NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
        NSString *apiName = [NSString stringWithFormat:@"reservations?type=owner&me=%@%@%@%@", self.currentUserSession.assigned, statusPart, limitSizePart, sortSkipPart];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCReservationWrapper *orderWrapper = [[TCReservationWrapper alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(orderWrapper, nil));
                }
            }
        }];
    }else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchReservationDetail:(NSString *)reserveID result:(void (^)(TCReservationDetail *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"reservations/%@?type=owner&me=%@", reserveID, [self currentUserSession].assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCReservationDetail *reservationDetail = [[TCReservationDetail alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(reservationDetail, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)changeReservationStatus:(NSString *)statusStr ReservationId:(NSString *)reservationId result:(void(^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"reservations/%@/status?type=owner&me=%@", reservationId, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:@"CANCEL" forParam:@"value"];
        
        [[TCClient client] send:request finish:^(TCClientResponse *respone) {
            if (respone.codeInResponse == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, respone.error));
                }
            }
        }];
    }  else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}


- (void)createReservationWithStoreSetMealId:(NSString *)storeSetMealId appintTime:(NSInteger)appintTime personNum:(NSInteger)personNum linkman:(NSString *)linkman phone:(NSString *)phone note:(NSString *)note vcode:(NSString *)vcode result:(void(^)(TCReservationDetail *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        
        NSString *vcodeStr = vcode ? [NSString stringWithFormat:@"&vcode=%@", vcode] : @"";
        NSString *apiName = [NSString stringWithFormat:@"reservations?me=%@%@", self.currentUserSession.assigned, vcodeStr];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        
        [request setValue:storeSetMealId forParam:@"storeSetMealId"];
        [request setValue:[NSNumber numberWithInteger:appintTime] forParam:@"appointTime"];
        [request setValue:[NSNumber numberWithInteger:personNum] forParam:@"personNum"];
        [request setValue:linkman forParam:@"linkman"];
        [request setValue:phone forParam:@"phone"];
        [request setValue:note forParam:@"note"];
        
        [[TCClient client] send:request finish:^(TCClientResponse *respone) {
            TCReservationDetail *result = [[TCReservationDetail alloc] initWithObjectDictionary:respone.data];
            if (respone.codeInResponse == 201) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(result, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, respone.error));
                }
            }
        }];
    }  else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}


#pragma mark - 购物车资源
- (void)fetchShoppingCartWrapperWithSortSkip:(NSString *)sortSkip result:(void (^)(TCShoppingCartWrapper *, NSError *))resultBlock {
    
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/shopping_cart?limitSize=50", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCShoppingCartWrapper *shoppingWrapper = [[TCShoppingCartWrapper alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(shoppingWrapper, nil));
                }
            }
        }];
    }else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)createShoppingCartWithAmount:(NSInteger)amount goodsId:(NSString *)goodsId result:(void(^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/shopping_cart", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        
        [request setValue:[NSNumber numberWithInteger:amount] forParam:@"amount"];
        [request setValue:goodsId forParam:@"goodsId"];
        
        [[TCClient client] send:request finish:^(TCClientResponse *respone) {
            if (respone.codeInResponse == 201) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, respone.error));
                }
            }
        }];
    }  else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)changeShoppingCartWithShoppingCartGoodsId:(NSString *)shoppingCartGoodsId AndNewGoodsId:(NSString *)newGoodsId AndAmount:(NSInteger)amount result:(void(^)(TCCartItem *, NSError *))resultBlock{
    if ([self isUserSessionValid]) {

        NSString *apiName = [NSString stringWithFormat:@"persons/%@/shopping_cart", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:shoppingCartGoodsId forParam:@"shoppingCartGoodsId"];
        [request setValue:newGoodsId forParam:@"newGoodsId"];
        [request setValue:[NSNumber numberWithInteger:amount] forParam:@"amount"];
        
        [[TCClient client ] send:request finish:^(TCClientResponse *respone) {
            if (respone.codeInResponse == 200) {
                TCCartItem *result = [[TCCartItem alloc] initWithObjectDictionary:respone.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(result, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, respone.error));
                }
            }
        }];
    }  else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }

}

- (void)deleteShoppingCartWithShoppingCartArr:(NSArray *)cartArr result:(void(^)(BOOL, NSError *))resultBlock{
    if ([self isUserSessionValid]) {
        
        NSString *shoppingCartGoodIdStr = @"";
        for (int i = 0; i < cartArr.count; i++) {
            shoppingCartGoodIdStr = (i == 0) ? [NSString stringWithFormat:@"/%@", cartArr[i]] : [NSString stringWithFormat:@"%@,%@", shoppingCartGoodIdStr, cartArr[i]];
        }
        
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/shopping_cart%@", self.currentUserSession.assigned, shoppingCartGoodIdStr];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodDelete apiName:apiName];
        request.token = self.currentUserSession.token;
        
        [[TCClient client] send:request finish:^(TCClientResponse *respone) {
            if (respone.codeInResponse == 204) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, respone.error));
                }
            }
        }];
    }  else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
    
}



#pragma mark - 上传图片资源

- (void)uploadImageData:(NSData *)imageData progress:(void (^)(NSProgress *))progress result:(void (^)(BOOL, TCUploadInfo *, NSError *))resultBlock {
    [self authorizeImageData:imageData result:^(TCUploadInfo *uploadInfo, NSError *error) {
        if (error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(NO, nil, error));
            }
        } else {
            NSString *uploadURLString = uploadInfo.url;
            TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut uploadURLString:uploadURLString];
            [request setImageData:imageData];
            [[TCClient client] upload:request progress:progress finish:^(TCClientResponse *response) {
                if (response.statusCode == 200) {
                    if (resultBlock) {
                        TC_CALL_ASYNC_MQ(resultBlock(YES, uploadInfo, nil));
                    }
                } else {
                    if (resultBlock) {
                        TC_CALL_ASYNC_MQ(resultBlock(NO, nil, response.error));
                    }
                }
            }];
        }
    }];
}

#pragma mark - 社区资源

- (void)fetchCommunityList:(void (^)(NSArray *, NSError *))resultBlock {
    NSString *apiName = @"communities";
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            NSMutableArray *communityList = [NSMutableArray array];
            NSArray *dics = response.data;
            for (NSDictionary *dic in dics) {
                TCCommunity *community = [[TCCommunity alloc] initWithObjectDictionary:dic];
                [communityList addObject:community];
            }
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock([communityList copy], nil));
            }
        }
    }];
}

- (void)fetchCommunityDetailInfo:(NSString *)communityID result:(void (^)(TCCommunityDetailInfo *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"communities/%@", communityID];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCCommunityDetailInfo *communityDetailInfo = [[TCCommunityDetailInfo alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(communityDetailInfo, nil));
            }
        }
    }];
}

- (void)fetchCommunityListGroupByCity:(void (^)(NSArray *, NSError *))resultBlock {
    NSString *apiName = @"communities/property_management";
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            NSMutableArray *communities = [NSMutableArray array];
            NSDictionary *dic = response.data;
            for (NSString *key in dic.allKeys) {
                NSMutableArray *communityList = [NSMutableArray array];
                for (NSDictionary *communityDic in dic[key]) {
                    TCCommunity *community = [[TCCommunity alloc] initWithObjectDictionary:communityDic];
                    [communityList addObject:community];
                }
                TCCommunityListInCity *communityListInCity = [[TCCommunityListInCity alloc] init];
                communityListInCity.city = key;
                communityListInCity.communityList = [communityList copy];
                [communities addObject:communityListInCity];
            }
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock([communities copy], nil));
            }
        }
    }];
}

#pragma mark - 公司资源

- (void)fetchCompanyList:(NSString *)communityID result:(void (^)(NSArray *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"companies?communityId=%@", communityID];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            NSMutableArray *companyList = [NSMutableArray array];
            NSArray *dicArray = response.data;
            for (NSDictionary *dic in dicArray) {
                TCCompanyInfo *companyInfo = [[TCCompanyInfo alloc] initWithObjectDictionary:dic];
                [companyList addObject:companyInfo];
            }
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock([companyList copy], nil));
            }
        }
    }];
}
#pragma mark - 物业报修

- (void)fetchPropertyWrapper:(NSString *)status count:(NSUInteger)count sortSkip:(NSString *)sortSkip result:(void (^)(TCPropertyManageWrapper *propertyManageWrapper, NSError *error))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *s = status ? [NSString stringWithFormat:@"status=%@&", status] : @"";
        NSString *limitSizePart = [NSString stringWithFormat:@"limitSize=%zd", count];
        NSString *sortSkipPart = sortSkip ? [NSString stringWithFormat:@"&sortSkip=%@", sortSkip] : @"";
        NSString *apiName = [NSString stringWithFormat:@"property_orders?type=owner&me=%@&%@%@%@", self.currentUserSession.assigned, s, limitSizePart, sortSkipPart];
//        NSString *apiName = [NSString stringWithFormat:@"persons/%@/property_management?%@%@%@", @"5824287f0cf210fc9cef5e42", s, limitSizePart, sortSkipPart];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCPropertyManageWrapper *propertyManageWrapper = [[TCPropertyManageWrapper alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(propertyManageWrapper, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)commitPropertyRepairsInfo:(TCPropertyRepairsInfo *)repairsInfo result:(void (^)(BOOL, TCPropertyManage *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"property_orders/?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [repairsInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCPropertyManage *propertyManage = [[TCPropertyManage alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, propertyManage, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, nil, sessionError));

        }
    }
}

#pragma 手机开锁
- (void)openDoorWithResult:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"persons/%@/unlock_door?", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:@"ssssss" forParam:@"value"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));

                }
            }
        }];
    }else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
            
        }
    }
}

- (void)cancelPropertyOrderWithOrderID:(NSString *)orderId result:(void(^)(BOOL success, NSError *error))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"property_orders/%@?type=owner&me=%@", orderId,self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

#pragma mark - 第三方支付

- (void)fetchWechatRechargeInfoWithMoney:(double)money result:(void (^)(TCWechatRechargeInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"recharge/wechat/unifiedorder?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:[NSNumber numberWithDouble:money] forParam:@"value"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCWechatRechargeInfo *rechargeInfo = [[TCWechatRechargeInfo alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(rechargeInfo, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchWechatRechargeResultWithPrepayID:(NSString *)prepayID result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"recharge/wechat/orderquery?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:prepayID forParam:@"value"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)fetchBFSessionInfoWithPaymentID:(NSString *)paymentID result:(void (^)(TCBFSessionInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"recharge/bf_bankcard/generate_session_id?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        if (paymentID) {
            [request setValue:paymentID forParam:@"value"];
        } else {
            [request setValue:[NSNull null] forKey:@"value"];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                NSDictionary *dic = [response.data objectForKey:@"result"];
                TCBFSessionInfo *sessionInfo = [[TCBFSessionInfo alloc] initWithObjectDictionary:dic];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(sessionInfo, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)prepareBFPayWithInfo:(TCBFPayInfo *)payInfo result:(void (^)(NSString *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"recharge/bf_bankcard/prepare_order?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [payInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                NSDictionary *dataDic = response.data;
                NSString *payID = dataDic[@"result"];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(payID, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)confirmBFPayWithPayID:(NSString *)payID vCode:(NSString *)vCode result:(void (^)(TCBFPayResult, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"recharge/bf_bankcard/confirm_order?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:payID forParam:@"rechargeId"];
        [request setValue:vCode forParam:@"vcode"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                NSDictionary *dataDic = response.data;
                NSString *resultStr = dataDic[@"result"];
                TCBFPayResult payResult = TCBFPayResultError;
                if ([resultStr isEqualToString:@"1"]) {
                    payResult = TCBFPayResultSucceed;
                } else if ([resultStr isEqualToString:@"2"]) {
                    payResult = TCBFPayResultFailure;
                } else if ([resultStr isEqualToString:@"3"]) {
                    payResult = TCBFPayResultProcessing;
                } else if ([resultStr isEqualToString:@"4"]) {
                    payResult = TCBFPayResultNotPay;
                } else {
                    payResult = TCBFPayResultError;
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(payResult, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(TCBFPayResultError, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(TCBFPayResultError, sessionError));
        }
    }
}

- (void)queryBFPayWithPayID:(NSString *)payID result:(void (^)(TCBFPayResult, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"recharge/bf_bankcard/query_order?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:payID forParam:@"value"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                NSDictionary *dataDic = response.data;
                NSString *resultStr = dataDic[@"result"];
                TCBFPayResult payResult = TCBFPayResultError;
                if ([resultStr isEqualToString:@"1"]) {
                    payResult = TCBFPayResultSucceed;
                } else if ([resultStr isEqualToString:@"2"]) {
                    payResult = TCBFPayResultFailure;
                } else if ([resultStr isEqualToString:@"3"]) {
                    payResult = TCBFPayResultProcessing;
                } else if ([resultStr isEqualToString:@"4"]) {
                    payResult = TCBFPayResultNotPay;
                } else {
                    payResult = TCBFPayResultError;
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(payResult, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(TCBFPayResultError, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(TCBFPayResultError, sessionError));
        }
    }
}

#pragma mark - 门锁设备

- (void)fetchMyLockListResult:(void (^)(NSArray *lockList, NSError *error))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"locks?me=%@&type=owner", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                if (resultBlock) {
                    NSMutableArray *lockList = [NSMutableArray array];
                    NSArray *dicArray = response.data;
                    for (NSDictionary *dic in dicArray) {
                        TCLockEquip *lockEquip = [[TCLockEquip alloc] initWithObjectDictionary:dic];
                        [lockList addObject:lockEquip];
                    }
                    TC_CALL_ASYNC_MQ(resultBlock([lockList copy], nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }

}

- (void)fetchMyLockKeysResult:(void (^)(NSArray *lockKeysList, NSError *error))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"keys?me=%@&type=owner", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                if (resultBlock) {
                    NSMutableArray *lockList = [NSMutableArray array];
                    NSArray *dicArray = response.data;
                    for (NSDictionary *dic in dicArray) {
                        TCLockWrapper *lockWrapper = [[TCLockWrapper alloc] initWithObjectDictionary:dic];
                        [lockList addObject:lockWrapper];
                    }
                    TC_CALL_ASYNC_MQ(resultBlock([lockList copy], nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchLockKeyWithVisitorInfo:(TCVisitorInfo *)visitorInfo result:(void (^)(TCLockKey *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"keys?me=%@&type=owner", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [visitorInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCLockKey *lockKey = [[TCLockKey alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(lockKey, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)deleteLockKeyWithID:(NSString *)lockKeyID result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"keys/%@?me=%@&type=owner",lockKeyID,self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodDelete apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 204) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)fetchMultiLockKeyWithVisitorInfo:(TCVisitorInfo *)visitorInfo result:(void (^)(TCMultiLockKey *, BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"keys?me=%@&type=owner&multi=true", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [visitorInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 201) {
                TCMultiLockKey *multiLockKey = [[TCMultiLockKey alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(multiLockKey, NO, nil));
                }
            } else if (response.codeInResponse == 300) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, NO, sessionError));
        }
    }
}

- (void)deleteMultiLockKeyWithID:(NSString *)multiLockKeyID result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"keys/%@?me=%@&type=owner&multi=true",multiLockKeyID, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodDelete apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 204) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)fetchVisitorMultiLockKeyList:(void(^)(NSArray *multiLockKeyList, NSError *error))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"keys?me=%@&type=owner&multi=true", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                if (resultBlock) {
                    NSMutableArray *lockList = [NSMutableArray array];
                    NSArray *dicArray = response.data;
                    for (NSDictionary *dic in dicArray) {
                        TCMultiLockKey *multiLockKey = [[TCMultiLockKey alloc] initWithObjectDictionary:dic];
                        [lockList addObject:multiLockKey];
                    }
                    TC_CALL_ASYNC_MQ(resultBlock([lockList copy], nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

#pragma mark - 系统初始化接口

- (void)fetchAppInitializationInfo:(void (^)(TCAppInitializationInfo *, NSError *))resultBlock {
    NSString *apiName = [NSString stringWithFormat:@"configs/init?uid=%@&edition=individual&os=ios", self.currentUserSession.assigned];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCAppInitializationInfo *info = [[TCAppInitializationInfo alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(info, nil));
            }
        }
    }];
}

- (void)fetchAppVersionInfo:(void (^)(TCAppVersion *, NSError *))resultBlock {
    NSString *apiName = @"configs/version?edition=individual&os=ios";
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            TCAppVersion *versionInfo = [[TCAppVersion alloc] initWithObjectDictionary:response.data];
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(versionInfo, nil));
            }
        }
    }];
}

- (void)fetchMainPageList:(void (^)(NSArray *, NSError *))resultBlock {
    NSString *apiName = @"configs/mainpage";
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            NSArray *dicArray = [response.data objectForKey:@"banner"];
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dic in dicArray) {
                TCMainPage *mainPage = [[TCMainPage alloc] initWithObjectDictionary:dic];
                [temp addObject:mainPage];
            }
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock([temp copy], nil));
            }
        }
    }];
}

- (void)fetchBFSupportedBankListByType:(TCBFSupportedBankType)type result:(void (^)(NSArray *, NSError *))resultBlock {
    NSString *typeStr = nil;
    switch (type) {
        case TCBFSupportedBankTypeWithhold:
            typeStr = @"WITHHOLD";
            break;
            
        default:
            typeStr = @"WITHHOLD";
            break;
    }
    NSString *apiName = [NSString stringWithFormat:@"configs/bf_supported_bank?type=%@", typeStr];
    TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
    request.token = self.currentUserSession.token;
    [[TCClient client] send:request finish:^(TCClientResponse *response) {
        if (response.error) {
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
            }
        } else {
            NSArray *dicArray = [response.data objectForKey:@"banner"];
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dic in dicArray) {
                TCBankCard *bankCard = [[TCBankCard alloc] initWithObjectDictionary:dic];
                [temp addObject:bankCard];
            }
            if (resultBlock) {
                TC_CALL_ASYNC_MQ(resultBlock([temp copy], nil));
            }
        }
    }];
}

#pragma mark - 线上活动

- (void)signinDaily:(void (^)(TCSigninRecordDay *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"activities/signin?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCSigninRecordDay *signinRecordDay = [[TCSigninRecordDay alloc] initWithObjectDictionary:response.data];
                TCUserSession *userSession = self.currentUserSession;
                if (!userSession.activities) {
                    userSession.activities = [[TCActivityInfo alloc] init];
                }
                userSession.activities.signin = signinRecordDay;
                [self setUserSession:userSession];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(signinRecordDay, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchSigninRecordMonth:(void (^)(TCSigninRecordMonth *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"activities/signin?me=%@", self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                TCSigninRecordMonth *signinRecordMonth = [[TCSigninRecordMonth alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(signinRecordMonth, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

#pragma mark - 商铺资源

- (void)fetchStoreDetailInfoWithStoreId:(NSString *)storeId result:(void (^)(TCStoreDetailInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"stores/%@?me=%@",storeId,[TCBuluoApi api].currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCStoreDetailInfo *detailInfo = [[TCStoreDetailInfo alloc] initWithObjectDictionary:response.data];
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(detailInfo, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

#pragma mark - 租赁资源

- (void)fetchRentProtocolList:(void (^)(NSArray *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"rent_protocols?me=%@&ownerId=%@", self.currentUserSession.assigned, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                NSArray *dics = response.data;
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:dics.count];
                for (NSDictionary *dic in dics) {
                    TCRentProtocol *item = [[TCRentProtocol alloc] initWithObjectDictionary:dic];
                    [temp addObject:item];
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock([temp copy], nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchCurrentRentProtocolBySourceID:(NSString *)sourceID result:(void (^)(TCRentProtocol *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"rent_protocols/actived?me=%@&sourceId=%@", self.currentUserSession.assigned, sourceID];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                TCRentProtocol *rentProtocol = nil;
                if (response.data && ![response.data isEqual:[NSNull null]]) {
                    rentProtocol = [[TCRentProtocol alloc] initWithObjectDictionary:response.data];
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(rentProtocol, nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)fetchRentPlanItemListByRentProtocolID:(NSString *)protocolID result:(void (^)(NSArray *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"rent_protocols/%@/plan_items?me=%@&fetchAll=true", protocolID, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.error) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            } else {
                NSArray *dics = response.data;
                NSMutableArray *temp = [NSMutableArray arrayWithCapacity:dics.count];
                for (NSDictionary *dic in dics) {
                    TCRentPlanItem *item = [[TCRentPlanItem alloc] initWithObjectDictionary:dic];
                    [temp addObject:item];
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock([temp copy], nil));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)modifyRentProtocolWithholdByRentProtocolID:(NSString *)protocolID withholdInfo:(TCRentProtocolWithholdInfo *)withholdInfo result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"rent_protocols/%@/withhold?me=%@", protocolID, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPut apiName:apiName];
        request.token = self.currentUserSession.token;
        NSDictionary *dic = [withholdInfo toObjectDictionary];
        for (NSString *key in dic.allKeys) {
            [request setValue:dic[key] forParam:key];
        }
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)fetchRentProtocolWithholdInfoByRentProtocolID:(NSString *)protocolID result:(void (^)(TCRentProtocolWithholdInfo *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"rent_protocols/%@/withhold?me=%@", protocolID, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 200) {
                TCRentProtocolWithholdInfo *info = nil;
                if (response.data && ![response.data isEqual:[NSNull null]]) {
                    info = [[TCRentProtocolWithholdInfo alloc] initWithObjectDictionary:response.data];
                }
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(info, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

- (void)deleteRentProtocolWithholdByRentProtocolID:(NSString *)protocolID result:(void (^)(BOOL, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"rent_protocols/%@/withhold?me=%@", protocolID, self.currentUserSession.assigned];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodDelete apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.statusCode == 204) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)createSmartLockPasswordWithSN:(NSString *)sn sourceId:(NSString *)sourceId password:(NSString *)password result:(void (^)(BOOL, NSError *))resultBlock{
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"smart_locks/password?me=%@&sourceId=%@", self.currentUserSession.assigned,sourceId];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodPost apiName:apiName];
        request.token = self.currentUserSession.token;
        [request setValue:sn forParam:@"sn"];
        [request setValue:password forKey:@"password"];
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 201) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(YES, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(NO, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(NO, sessionError));
        }
    }
}

- (void)checkSmartLockTemporaryPasswordWithSN:(NSString *)sn sourceId:(NSString *)sourceId result:(void (^)(NSString *, NSError *))resultBlock {
    if ([self isUserSessionValid]) {
        NSString *apiName = [NSString stringWithFormat:@"smart_locks/apply_temporary_password?me=%@&sourceId=%@&sn=%@", self.currentUserSession.assigned,sourceId, sn];
        TCClientRequest *request = [TCClientRequest requestWithHTTPMethod:TCClientHTTPMethodGet apiName:apiName];
        request.token = self.currentUserSession.token;
        [[TCClient client] send:request finish:^(TCClientResponse *response) {
            if (response.codeInResponse == 200) {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(response.data, nil));
                }
            } else {
                if (resultBlock) {
                    TC_CALL_ASYNC_MQ(resultBlock(nil, response.error));
                }
            }
        }];
    } else {
        TCClientRequestError *sessionError = [TCClientRequestError errorWithCode:TCClientRequestErrorUserSessionInvalid andDescription:nil];
        if (resultBlock) {
            TC_CALL_ASYNC_MQ(resultBlock(nil, sessionError));
        }
    }
}

@end
