//
//  TCApartmentWithholdInfoView.h
//  individual
//
//  Created by 穆康 on 2017/6/29.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCRentProtocolWithholdInfo;

@protocol TCApartmentWithholdInfoViewDelegate;
/**
 代扣信息
 */
@interface TCApartmentWithholdInfoView : UIView

@property (strong, nonatomic) TCRentProtocolWithholdInfo *withholdInfo;
@property (weak, nonatomic) id<TCApartmentWithholdInfoViewDelegate> delegate;

@end

@protocol TCApartmentWithholdInfoViewDelegate <NSObject>

@optional
- (void)didClickEditButtonInApartmentWithholdInfoView:(TCApartmentWithholdInfoView *)view;

@end
