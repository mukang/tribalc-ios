//
//  TCOrder.h
//  individual
//
//  Created by WYH on 16/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCMarkStore.h"

@interface TCOrder : NSObject

/** 订单ID */
@property (copy, nonatomic) NSString *ID;
/** 订单编号 */
@property (copy, nonatomic) NSString *orderNum;
/** 用户ID */
@property (copy, nonatomic) NSString *ownerId;
/** 收货地址 */
@property (copy, nonatomic) NSString *address;
/** 配送方式 */
@property (copy, nonatomic) NSString *expressType;
/** 邮递费 */
@property (nonatomic) NSInteger expressFee;
/** 价格合计 */
@property (nonatomic) CGFloat totalFee;
/** 订单补充说明 */
@property (nonatomic) NSString *note;
/** 支付方式 */
@property (copy, nonatomic) NSString *payChannel;
/** 订单状态 */
@property (copy, nonatomic) NSString *status;
/** 创建时间 */
@property (nonatomic) NSInteger createTime;
/** 结算时间 */
@property (nonatomic) NSInteger settleTime;
/** 发货时间 */
@property (nonatomic) NSInteger deliveryTime;
/** 收货时间 */
@property (nonatomic) NSInteger receivedTime;
/** 商铺简要信息 */
@property (nonatomic) TCMarkStore *store;
/** 关联商品信息 */
@property (nonatomic) NSArray *itemList;


@end


