//
//  TCApartmentRentPayDetailView.h
//  individual
//
//  Created by 穆康 on 2017/6/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCRentProtocol;

@protocol TCApartmentRentPayDetailViewDelegate;
/**
 付款详情
 */
@interface TCApartmentRentPayDetailView : UIView

@property (strong, nonatomic) TCRentProtocol *rentProtocol;
@property (weak, nonatomic) id<TCApartmentRentPayDetailViewDelegate> delegate;

@end

@protocol TCApartmentRentPayDetailViewDelegate <NSObject>

@optional
- (void)didClickPayButtonInApartmentRentPayDetailView:(TCApartmentRentPayDetailView *)view;

@end
