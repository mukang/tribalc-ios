//
//  TCUserTests.m
//  individual
//
//  Created by 穆康 on 2016/11/11.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TCBuluoApi.h"

@interface TCUserTests : XCTestCase

@property (strong, nonatomic) XCTestExpectation *expectation;
@property (strong, nonatomic) TCBuluoApi *buluoApi;

@end

@implementation TCUserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.buluoApi = [TCBuluoApi api];
    
    if ([self.buluoApi needLogin]) {
        TCUserLoginInfo *userLoginInfo = [[TCUserLoginInfo alloc] init];
        userLoginInfo.phone = @"18510509908";
        userLoginInfo.verificationCode = @"123456";
        
        self.expectation = [self expectationWithDescription:@"Expect User Login"];
        
        [[TCBuluoApi api] login:userLoginInfo result:^(TCUserSession *userSession, NSError *error) {
            XCTAssertNotNil(userSession, @"User login failed with error: %@", error);
            [self.expectation fulfill];
        }];
        
        [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
            if (error) {
                XCTFail(@"Expection failed with error: %@", error);
            }
        }];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testChangeUserNickName {
    self.expectation = [self expectationWithDescription:@"Expect Change User Nickname"];
    
    [self.buluoApi changeUserNickname:@"xiaoming" result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Change user nickname failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testUserAvatar {
    self.expectation = [self expectationWithDescription:@"Expect Change User Avatar"];
    
    [self.buluoApi changeUserAvatar:@"/avatar/xiaoming" result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Change user avatar failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testUserGender {
    self.expectation = [self expectationWithDescription:@"Expect Change User Gender"];
    
    [self.buluoApi changeUserGender:TCUserGenderMale result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Change user gender failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testUserBirthdate {
    self.expectation = [self expectationWithDescription:@"Expect Change User Birthdate"];
    
    [self.buluoApi changeUserBirthdate:[NSDate date] result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Change user birthdate failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testUserEmotionState {
    self.expectation = [self expectationWithDescription:@"Expect Change User Emotion State"];
    
    [self.buluoApi changeUserEmotionState:TCUserEmotionStateSingle result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Change user emotion state failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testUserAddress {
    self.expectation = [self expectationWithDescription:@"Expect Change User Address"];
    
    TCUserAddress *userAddress = [[TCUserAddress alloc] init];
    userAddress.province = @"北京";
    userAddress.city = @"北京市";
    userAddress.district = @"朝阳区";
    [self.buluoApi changeUserAddress:userAddress result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Change user address failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testUserCoordinate {
    self.expectation = [self expectationWithDescription:@"Expect Change User Coordinate"];
    
    NSArray *coordinate = @[@(116.8234023), @(39.11428542)];
    [self.buluoApi changeUserCoordinate:coordinate result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Change user coordinate failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

@end
