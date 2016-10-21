//
//  TCDicToModelTests.m
//  individual
//
//  Created by 穆康 on 2016/10/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSObject+TCModel.h"
#import "TCTestModel.h"
#import "TCTestBoss.h"

@interface TCDicToModelTests : XCTestCase

@property (nonatomic, copy) NSDictionary *dic01;
@property (nonatomic, copy) NSDictionary *dic02;
@property (nonatomic, strong) TCTestBoss *boss;

@end

@implementation TCDicToModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.dic01 = @{
                 @"id": @"001",
                 @"name": @"xiaoming",
                 @"age": @(20)
                 };
    
    self.dic02 = @{
                   @"id": @"01",
                   @"name": @"laoda",
                   @"manager": @{
                                 @"id": @"02",
                                 @"name": @"laoer",
                                 @"dog": @{
                                           @"id": @"11",
                                           @"name": @"xiaohua"
                                          },
                                 @"littleDogs": @[
                                                  @{
                                                    @"id": @"111",
                                                    @"name": @"xiaohua01"
                                                    },
                                                  @{
                                                    @"id": @"112",
                                                    @"name": @"xiaohua02"
                                                    }
                                                  ]
                                },
                   @"staffs": @[
                                @{
                                  @"id": @"03",
                                  @"name": @"zhangsan",
                                  @"dog": @{
                                            @"id": @"12",
                                            @"name": @"xiaohong"
                                            },
                                  @"littleDogs": @[
                                                   @{
                                                     @"id": @"121",
                                                     @"name": @"xiaohong01"
                                                     },
                                                   @{
                                                     @"id": @"122",
                                                     @"name": @"xiaohong02"
                                                     }
                                                  ]
                                  },
                                @{
                                  @"id": @"04",
                                  @"name": @"lisi",
                                  @"dog": @{
                                            @"id": @"13",
                                            @"name": @"xiaozi"
                                            },
                                  @"littleDogs": @[
                                            @{
                                                @"id": @"131",
                                                @"name": @"xiaozi01"
                                                },
                                            @{
                                                @"id": @"132",
                                                @"name": @"xiaozi02"
                                                }
                                            ]
                                  }
                                ]
                   };
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDicToModel01 {
    
    TCTestModel *testModel = [[TCTestModel alloc] initWithObjectDictionary:self.dic01];
    
    XCTAssertEqualObjects(testModel.ID, @"001", @"testModel的ID不为001");
    XCTAssertEqualObjects(testModel.name, @"xiaoming", @"testModel的name不为xiaoming");
    XCTAssertEqual(testModel.age, 20, @"testModel的age不为20");
}

- (void)testDicToModel02 {
    
    TCTestBoss *boss = [[TCTestBoss alloc] initWithObjectDictionary:self.dic02];
    
    XCTAssertEqualObjects(boss.name, @"laoda");
    XCTAssertEqualObjects(boss.manager.name, @"laoer");
    XCTAssertEqualObjects(boss.manager.dog.name, @"xiaohua");
    XCTAssertEqualObjects([boss.staffs[0] name], @"zhangsan");
    XCTAssertEqualObjects([boss.staffs[1] dog].ID, @"13");
}

- (void)testModelToDic01 {
    
    TCTestBoss *boss = [[TCTestBoss alloc] initWithObjectDictionary:self.dic02];
    NSDictionary *dict = [boss toObjectDictionary];
    
    XCTAssertTrue(dict.count);
}

- (void)testModelToDic02 {
    
    TCTestBoss *boss = [[TCTestBoss alloc] initWithObjectDictionary:self.dic02];
    NSDictionary *dict = [boss toObjectDictionary:YES];
    
    XCTAssertTrue(dict.count);
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

@end
