//
//  TCRentPlanItemsViewController.h
//  individual
//
//  Created by 穆康 on 2017/7/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
@class TCRentProtocol;

typedef NS_ENUM(NSInteger, TCRentPlanItemsType) {
    TCRentPlanItemsTypeIndividual = 0,
    TCRentPlanItemsTypeCompany
};

/**
 缴租计划页面
 */
@interface TCRentPlanItemsViewController : TCBaseViewController

/** 公共 */
@property (nonatomic, readonly) TCRentPlanItemsType type;

/** 个人需传 */
@property (strong, nonatomic) TCRentProtocol *rentProtocol;

/** 企业需传 */
@property (copy, nonatomic) NSString *companyID;
@property (copy, nonatomic) NSString *companyName;
@property (copy, nonatomic) NSString *rentProtocolID;

- (instancetype)initWithRentPlanItemsType:(TCRentPlanItemsType)type;

@end
