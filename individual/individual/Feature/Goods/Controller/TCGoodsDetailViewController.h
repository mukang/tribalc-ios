//
//  TCGoodsDetailViewController.h
//  individual
//
//  Created by 穆康 on 2017/9/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#import "TCGoodsDetail.h"

@interface TCGoodsDetailViewController : TCBaseViewController

@property (copy, nonatomic) NSString *goodsID;
@property (strong, nonatomic) TCGoodsDetail *goodsDetail;

@end
