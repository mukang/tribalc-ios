//
//  TCCommonPaymentMethodView.h
//  individual
//
//  Created by 穆康 on 2017/9/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBankCard.h"

typedef NS_ENUM(NSInteger, TCCommonPaymentMethod) {
    TCCommonPaymentMethodBalance = 0,
    TCCommonPaymentMethodWechat,
    TCCommonPaymentMethodBankCard
};

@interface TCCommonPaymentMethodView : UIView

@property (nonatomic) TCCommonPaymentMethod method;

/** 当method==TCCommonPaymentMethodBalance时，必传 */
@property (nonatomic) double balance;
/** 当method==TCCommonPaymentMethodBankCard时，必传 */
@property (strong, nonatomic) TCBankCard *bankCard;

@end
