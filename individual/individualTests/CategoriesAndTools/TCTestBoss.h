//
//  TCTestBoss.h
//  individual
//
//  Created by 穆康 on 2016/10/21.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TCTestStaff;
@class TCTestDog;

@interface TCTestBoss : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
/** 经理 */
@property (nonatomic, strong) TCTestStaff *manager;
/** 普通员工 */
@property (nonatomic, copy) NSArray *staffs;

@end



@interface TCTestStaff : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) TCTestDog *dog;
@property (nonatomic, copy) NSArray *littleDogs;

@end



@interface TCTestDog : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;

@end
