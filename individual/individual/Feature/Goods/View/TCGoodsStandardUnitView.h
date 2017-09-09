//
//  TCGoodsStandardUnitView.h
//  individual
//
//  Created by 穆康 on 2017/9/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCGoodsStandardUnitViewType) {
    TCGoodsStandardUnitViewTypeNormal = 0,
    TCGoodsStandardUnitViewTypeSelected,
    TCGoodsStandardUnitViewTypeDisabled
};

@interface TCGoodsStandardUnitView : UIView

@property (copy, nonatomic) NSString *title;

@property (nonatomic) TCGoodsStandardUnitViewType type;

- (CGFloat)realWidth;

@end
