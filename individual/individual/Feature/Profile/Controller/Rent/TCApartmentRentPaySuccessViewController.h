//
//  TCApartmentRentPaySuccessViewController.h
//  individual
//
//  Created by 穆康 on 2017/6/30.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
@class TCRentProtocol;

typedef NS_ENUM(NSInteger, TCRentPaySuccessType) {
    TCRentPaySuccessTypeIndividual = 0,
    TCRentPaySuccessTypeCompany
};

typedef void(^TCApartmentRentPaySuccess)();

@interface TCApartmentRentPaySuccessViewController : TCBaseViewController

/** 公共 */
@property (nonatomic) NSInteger itemNum;
@property (copy, nonatomic) TCApartmentRentPaySuccess paySuccess;
@property (nonatomic, readonly) TCRentPaySuccessType type;

/** 个人需传 */
@property (strong, nonatomic) TCRentProtocol *rentProtocol;

/** 企业需传 */
@property (copy, nonatomic) NSString *companyID;
@property (copy, nonatomic) NSString *companyName;
@property (copy, nonatomic) NSString *rentProtocolID;


- (instancetype)initWithRentPaySuccessType:(TCRentPaySuccessType)type;

@end
