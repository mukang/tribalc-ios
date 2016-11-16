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
@property (strong, nonatomic) TCUserShippingAddress *shippingAddress;
@property (strong, nonatomic) NSMutableArray *shippingAddressList;

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
    
    [self.buluoApi changeUserEmotionState:TCUserEmotionStateLove result:^(BOOL success, NSError *error) {
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

- (void)testAddUserShippingAddress {
    self.expectation = [self expectationWithDescription:@"Expect Add User Shipping Address"];
    
    TCUserShippingAddress *address = [[TCUserShippingAddress alloc] init];
    address.province = @"北京";
    address.city = @"北京市";
    address.district = @"朝阳区";
    address.address = @"北苑路媒体村天畅园1号楼408室";
    address.name = @"小明";
    address.phone = @"18888888888";
    __weak typeof(self) weakSelf = self;
    [weakSelf.buluoApi addUserShippingAddress:address result:^(BOOL success, TCUserShippingAddress *shippingAddress, NSError *error) {
        XCTAssertTrue(success, @"Add user shipping address failed with error: %@", error);
        [weakSelf.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testFetchUserShippingAddressList {
    self.expectation = [self expectationWithDescription:@"Expect Fetch User Shipping Address List"];
    
    [self.buluoApi fetchUserShippingAddressList:^(NSArray *addressList, NSError *error) {
        NSLog(@"--->%zd", addressList.count);
        XCTAssertNotNil(addressList, @"Fetch user shipping address list failed with error: %@", error);
        self.shippingAddressList = [NSMutableArray arrayWithArray:addressList];
        if (addressList.count) {
            self.shippingAddress = addressList[0];
        }
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testFetchUserShippingAddress {
    [self testFetchUserShippingAddressList];
    
    self.expectation = [self expectationWithDescription:@"Expect Fetch User Shipping Address"];
    
    [self.buluoApi fetchUserShippingAddress:self.shippingAddress.ID result:^(TCUserShippingAddress *shippingAddress, NSError *error) {
        XCTAssertNotNil(shippingAddress, @"Fetch user shipping address failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testChangeUserShippingAddress {
    [self testFetchUserShippingAddressList];
    self.expectation = [self expectationWithDescription:@"Expect Change User Shipping Address"];
    
    TCUserShippingAddress *shippingAddress = self.shippingAddress;
    shippingAddress.name = @"小刚";
    [self.buluoApi changeUserShippingAddress:shippingAddress result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Change user shipping address failed with error: %@", error);
        if (success) {
            self.shippingAddress.name = @"小刚";
        }
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testDeleteUserShippingAddress {
    [self testFetchUserShippingAddressList];
    self.expectation = [self expectationWithDescription:@"Expect Delete User Shipping Address"];
    
    [self.buluoApi deleteUserShippingAddress:self.shippingAddress.ID result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Delete user shipping address failed with error: %@", error);
        if (success) {
            self.shippingAddress = nil;
            [self.shippingAddressList removeObjectAtIndex:0];
        }
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

- (void)testSetUserDefaultShippingAddress {
    self.expectation = [self expectationWithDescription:@"Expect Set User Default Shipping Address"];
    
    TCUserShippingAddress *shippingAddress = self.shippingAddress;
    __weak typeof(self) weakSelf = self;
    [weakSelf.buluoApi setUserDefaultShippingAddress:shippingAddress.ID result:^(BOOL success, NSError *error) {
        XCTAssertTrue(success, @"Set user default shipping address failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

@end
