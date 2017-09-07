//
//  TCGoodsStandardView.h
//  individual
//
//  Created by 穆康 on 2017/9/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGoodsStandard.h"

@interface TCGoodsStandardView : UIScrollView

- (instancetype)initWithGoodsStandard:(TCGoodsStandard *)goodsStandard;

- (void)reloadStandarDataWithCurrentStandardKey:(NSString *)currentStandardKey;

@end
