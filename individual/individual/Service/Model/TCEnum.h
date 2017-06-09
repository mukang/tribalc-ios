//
//  TCEnum.h
//  individual
//
//  Created by 穆康 on 2017/6/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#ifndef TCEnum_h
#define TCEnum_h

typedef NS_ENUM(NSInteger, TCPayChannel) {
    TCPayChannelBalance = 0,  // 余额
    TCPayChannelAlipay,       // 支付宝
    TCPayChannelWechat,       // 微信
    TCPayChannelBankCard      // 银行卡
};

#endif /* TCEnum_h */
