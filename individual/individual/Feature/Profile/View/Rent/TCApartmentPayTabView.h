//
//  TCApartmentPayTabView.h
//  individual
//
//  Created by 穆康 on 2017/6/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCApartmentPayType) {
    TCApartmentPayTypeRent,
    TCApartmentPayTypeLife
};

@protocol TCApartmentPayTabViewDelegate;
/**
 公寓付费切换标签
 */
@interface TCApartmentPayTabView : UIView

@property (weak, nonatomic) id<TCApartmentPayTabViewDelegate> delegate;

- (void)clickApartmentPayTabWithType:(TCApartmentPayType)type;

@end

@protocol TCApartmentPayTabViewDelegate <NSObject>

@optional
- (void)apartmentPayTabView:(TCApartmentPayTabView *)view didClickTabWithType:(TCApartmentPayType)type;

@end
