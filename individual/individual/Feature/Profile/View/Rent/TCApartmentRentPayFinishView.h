//
//  TCApartmentRentPayFinishView.h
//  individual
//
//  Created by 穆康 on 2017/6/29.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCApartmentRentPayFinishViewDelegate;
/**
 全部房租缴纳完成
 */
@interface TCApartmentRentPayFinishView : UIView

@property (weak, nonatomic) id<TCApartmentRentPayFinishViewDelegate> delegate;

@end

@protocol TCApartmentRentPayFinishViewDelegate <NSObject>

@optional
- (void)didClickPayPlanInApartmentRentPayFinishView:(TCApartmentRentPayFinishView *)view;

@end
