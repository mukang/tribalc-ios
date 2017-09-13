//
//  TCGoodsStoreInfoViewCell.h
//  individual
//
//  Created by 穆康 on 2017/9/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCGoodsDetail;
@class TCMarkStore;

@interface TCGoodsStoreInfoViewCell : UITableViewCell

@property (strong, nonatomic) TCMarkStore *storeInfo;
@property (strong, nonatomic) TCGoodsDetail *goodsDetail;

@end
