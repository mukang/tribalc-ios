//
//  TCReserveOnlineViewController.h
//  individual
//
//  Created by WYH on 16/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCReserveRadioBtnView.h"
#import <TCCommonLibs/TCBaseViewController.h>

@interface TCReserveOnlineViewController : TCBaseViewController <UIPickerViewDelegate, UIPickerViewDataSource>

- (instancetype)initWithStoreSetMealId:(NSString *)storeSetMeal;


@end
