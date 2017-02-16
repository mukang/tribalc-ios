//
//  TCGoodsOrderGoodsViewCell.h
//  store
//
//  Created by 穆康 on 2017/2/9.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCOrderItem;

@interface TCGoodsOrderGoodsViewCell : UITableViewCell

@property (strong, nonatomic) TCOrderItem *orderItem;
@property (weak, nonatomic) UIView *lineView;

@end
