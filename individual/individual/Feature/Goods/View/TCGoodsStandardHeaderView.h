//
//  TCGoodsStandardHeaderView.h
//  individual
//
//  Created by 穆康 on 2017/9/5.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCCommonLibs/TCExtendButton.h>
#import "TCGoodsDetail.h"

@interface TCGoodsStandardHeaderView : UIView

@property (weak, nonatomic) TCExtendButton *closeButton;

@property (strong, nonatomic) TCGoodsDetail *goodsDetail;
@property (copy, nonatomic) NSString *standardStr;

@end
