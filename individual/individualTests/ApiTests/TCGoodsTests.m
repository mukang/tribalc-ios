//
//  TCGoodsTests.m
//  individual
//
//  Created by 穆康 on 2016/11/16.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TCBuluoApi.h"

@interface TCGoodsTests : XCTestCase

@property (strong, nonatomic) XCTestExpectation *expectation;
@property (strong, nonatomic) TCBuluoApi *buluoApi;

@end

@implementation TCGoodsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.buluoApi = [TCBuluoApi api];
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

- (void)testFetchGoodsWrapper {
    self.expectation = [self expectationWithDescription:@"Expect Fetch Goods Wrapper"];
    
    [self.buluoApi fetchGoodsWrapper:20 sortSkip:nil result:^(TCGoodsWrapper *goodsWrapper, NSError *error) {
        XCTAssertNotNil(goodsWrapper, @"Fetch goods wrapper failed with error: %@", error);
        [self.expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"Expection failed with error: %@", error);
        }
    }];
}

@end
