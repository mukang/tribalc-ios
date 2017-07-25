//
//  TCCreditBill.h
//  individual
//
//  Created by 王帅锋 on 2017/7/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCCreditBill : NSObject

@property (copy, nonatomic) NSString *ID;

@property (copy, nonatomic) NSString *ownerId;

@property (assign, nonatomic) CGFloat amount;

@property (assign, nonatomic) CGFloat paidAmount;

@property (assign, nonatomic) int64_t zeroDate;

@property (assign, nonatomic) int64_t billDate;

@property (assign, nonatomic) int64_t repayDate;

@property (copy, nonatomic) NSString *status;

@end
