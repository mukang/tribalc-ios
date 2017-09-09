//
//  TCGoodsStandardUnitsView.h
//  individual
//
//  Created by 穆康 on 2017/9/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGoodsStandard.h"

typedef NS_ENUM(NSInteger, TCGoodsStandardUnitsLevel) {
    TCGoodsStandardUnitsLevelPrimary = 0,
    TCGoodsStandardUnitsLevelSecondary
};

@protocol TCGoodsStandardUnitsViewDelegate;
@interface TCGoodsStandardUnitsView : UIView

@property (copy, nonatomic) NSString *currentKey;
@property (nonatomic, readonly) TCGoodsStandardUnitsLevel unitsLevel;

@property (weak, nonatomic) id<TCGoodsStandardUnitsViewDelegate> delegate;

- (instancetype)initWithUnitsLevel:(TCGoodsStandardUnitsLevel)level goodsStandard:(TCGoodsStandard *)goodsStandard;

- (void)reloadStandardDataWithAnotherKey:(NSString *)anotherKey;

@end


@protocol TCGoodsStandardUnitsViewDelegate <NSObject>

@optional
- (void)goodsStandardUnitsView:(TCGoodsStandardUnitsView *)view didSelectUnitWithKey:(NSString *)key;

@end
