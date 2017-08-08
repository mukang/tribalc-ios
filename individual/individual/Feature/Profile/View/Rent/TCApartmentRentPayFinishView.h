//
//  TCApartmentRentPayFinishView.h
//  individual
//
//  Created by 穆康 on 2017/6/29.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCRentPayFinishViewType) {
    TCRentPayFinishViewTypeIndividual = 0,
    TCRentPayFinishViewTypeCompany
};

@protocol TCApartmentRentPayFinishViewDelegate;
/**
 全部房租缴纳完成
 */
@interface TCApartmentRentPayFinishView : UIView

@property (nonatomic, readonly) TCRentPayFinishViewType type;
@property (weak, nonatomic) id<TCApartmentRentPayFinishViewDelegate> delegate;

- (instancetype)initWithType:(TCRentPayFinishViewType)type;

@end

@protocol TCApartmentRentPayFinishViewDelegate <NSObject>

@optional
- (void)didClickPayPlanInApartmentRentPayFinishView:(TCApartmentRentPayFinishView *)view;

@end
