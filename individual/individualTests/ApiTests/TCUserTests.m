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
@property (strong, nonatomic) TCUserChippingAddress *chippingAddress;
@property (strong, nonatomic) NSMutableArray *chippingAddressList;

@end

@implementation TCUserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.buluoApi = [TCBuluoApi api];
    
    if ([self.buluoApi needLogin]) {
        TCUserPhoneInfo *phoneInfo = [[TCUserPhoneInfo alloc] init];
        phoneInfo.phone = @"18510509908";
        phoneInfo.verificationCode = @"123456";
        
        self.expectation = [self expectationWithDescription:@"Expect User Login"];
        
        [[TCBuluoApi api] login:phoneInfo result:^(TCUserSession *userSession, NSError *error) {
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

- (void)testUserPhone {
    self.expectation = [self expectationWithDescription:@"Expect Change User Phone"];
    
    TCUserPhoneInfo *phoneInfo = [[TCUserPhoneInfo alloc] init];
    phoneInfo.phone = @"13582438248";
    phoneInfo.verificationCode = @"123456";
    [self.buluoApi changeUserPhone:phoneInfo result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Change user phone failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testAddUserChippingAddress {
    self.expectation = [self expectationWithDescription:@"Expect Add User Chipping Address"];
    
    TCUserChippingAddress *address = [[TCUserChippingAddress alloc] init];
    address.province = @"北京";
    address.city = @"北京市";
    address.district = @"朝阳区";
    address.address = @"北苑路媒体村天畅园1号楼408室";
    address.name = @"小明";
    address.phone = @"18888888888";
    __weak typeof(self) weakSelf = self;
    [weakSelf.buluoApi addUserChippingAddress:address result:^(BOOL success, TCUserChippingAddress *chippingAddress, NSError *error) {
        XCTAssertTrue(success, @"Add user chipping address failed with error: %@", error);
        [weakSelf.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testFetchUserChippingAddressList {
    self.expectation = [self expectationWithDescription:@"Expect Fetch User Chipping Address List"];
    
    [self.buluoApi fetchUserChippingAddressList:^(NSArray *addressList, NSError *error) {
        NSLog(@"--->%zd", addressList.count);
        XCTAssertNotNil(addressList, @"Fetch user chipping address list failed with error: %@", error);
        self.chippingAddressList = [NSMutableArray arrayWithArray:addressList];
        if (addressList.count) {
            self.chippingAddress = addressList[0];
        }
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testFetchUserChippingAddress {
    [self testFetchUserChippingAddressList];
    
    self.expectation = [self expectationWithDescription:@"Expect Fetch User Chipping Address"];
    
    [self.buluoApi fetchUserChippingAddress:self.chippingAddress.ID result:^(TCUserChippingAddress *chippingAddress, NSError *error) {
        XCTAssertNotNil(chippingAddress, @"Fetch user chipping address failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testChangeUserChippingAddress {
    [self testFetchUserChippingAddressList];
    self.expectation = [self expectationWithDescription:@"Expect Change User Chipping Address"];
    
    TCUserChippingAddress *chippingAddress = self.chippingAddress;
    chippingAddress.name = @"小刚";
    [self.buluoApi changeUserChippingAddress:chippingAddress result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Change user chipping address failed with error: %@", error);
        if (success) {
            self.chippingAddress.name = @"小刚";
        }
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testDeleteUserChippingAddress {
    [self testFetchUserChippingAddressList];
    self.expectation = [self expectationWithDescription:@"Expect Delete User Chipping Address"];
    
    [self.buluoApi deleteUserChippingAddress:self.chippingAddress.ID result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Delete user chipping address failed with error: %@", error);
        if (success) {
            self.chippingAddress = nil;
            [self.chippingAddressList removeObjectAtIndex:0];
        }
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testChangeUserDefaultChippingAddress {
    self.expectation = [self expectationWithDescription:@"Expect Change User Default Chipping Address"];
    
    TCUserChippingAddress *chippingAddress = self.chippingAddress;
    [self.buluoApi changeUserDefaultChippingAddress:chippingAddress.ID result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Change user default chipping address failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

@end
