//
//  TCBalancePayView.h
//  individual
//
//  Created by WYH on 16/12/12.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCBalancePayView : UIView

- (instancetype)initWithPayPrice:(NSString *)priceStr AndPayAction:(SEL)payAction AndTarget:(id)target;

- (void)showPayView;

@end
