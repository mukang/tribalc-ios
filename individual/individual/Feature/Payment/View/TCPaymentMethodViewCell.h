//
//  TCPaymentMethodViewCell.h
//  individual
//
//  Created by 穆康 on 2017/1/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBankCard.h"

@interface TCPaymentMethodViewCell : UITableViewCell

@property (weak, nonatomic) UIImageView *logoImageView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *promptLabel;

@property (nonatomic) BOOL isBankCardMode;
@property (strong, nonatomic) TCBankCard *bankCard;

@end
