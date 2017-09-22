//
//  TCPaymentMethodModel.h
//  individual
//
//  Created by 穆康 on 2017/9/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCPaymentEnum.h"
#import "TCBankCard.h"

@interface TCPaymentMethodModel : NSObject

/** 付款方式 */
@property (nonatomic) TCPaymentMethod paymentMethod;
/** 银行卡，当付款方式为TCPaymentMethodBankCard时，有值 */
@property (strong, nonatomic) TCBankCard *bankCard;
/** 是否不可用 */
@property (nonatomic, getter=isInvalid) BOOL invalid;
/** 提示 */
@property (copy, nonatomic) NSString *prompt;

@property (nonatomic, getter=isSelected) BOOL selected;
/** 是否单行 */
@property (nonatomic, getter=isSingleRow) BOOL singleRow;

@end
