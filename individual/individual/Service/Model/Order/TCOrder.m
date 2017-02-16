//
//  TCOrder.m
//  individual
//
//  Created by WYH on 16/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCOrder.h"
#import "TCOrderItem.h"

@implementation TCOrder

+ (NSDictionary *)objectClassInArray {
    return @{@"itemList": [TCOrderItem class]};
}

+ (NSDictionary *)objectClassInDictionary {
    return @{@"store": [TCMarkStore class]};
}

- (void)setStatus:(NSString *)status {
    _status = status;
    if ([status isEqualToString:@"CANCEL"]) {
        self.orderStatus = TCOrderCancel;
    } else if ([status isEqualToString:@"NO_SETTLE"]) {
        self.orderStatus = TCOrderNoSettle;
    } else if ([status isEqualToString:@"SETTLE"]) {
        self.orderStatus = TCOrderSettle;
    } else if ([status isEqualToString:@"DELIVERY"]) {
        self.orderStatus = TCOrderDelivery;
    } else if ([status isEqualToString:@"RECEIVED"]){
        self.orderStatus = TCOrderReceived;
    } else {
        self.orderStatus = TCOrderNoCreate;
    }
}

- (void)setPayChannel:(NSString *)payChannel {
    _payChannel = payChannel;
    if ([payChannel isEqualToString:@"BALANCE"]) {
        self.orderBalance = TCPayBalance;
    } else if ([payChannel isEqualToString:@"ALIPAY"]) {
        self.orderBalance = TCPayAlipay;
    } else if ([payChannel isEqualToString:@"WEICHAT"]) {
        self.orderBalance = TCPayWeichat;
    } else {
        self.orderBalance = TCPayBankcard;
    }
}

- (void)setExpressType:(NSString *)expressType {
    _expressType = expressType;
    if ([expressType isEqualToString:@"NOT_PAYPOSTAGE"]) {
        self.express = TCExpressTypeNotPayPostage;
    } else {
        self.express = TCExpressTypePayPostage;
    }
}


@end

