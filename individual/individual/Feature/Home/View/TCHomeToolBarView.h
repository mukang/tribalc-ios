//
//  TCHomeToolBarView.h
//  individual
//
//  Created by 穆康 on 2017/7/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCHomeToolBarViewDelegate;
@interface TCHomeToolBarView : UIView

@property (weak, nonatomic) id<TCHomeToolBarViewDelegate> delegate;

@end


@protocol TCHomeToolBarViewDelegate <NSObject>

@optional
- (void)didClickScanButtonInHomeToolBarView:(TCHomeToolBarView *)view;
- (void)didClickUnlockButtonInHomeToolBarView:(TCHomeToolBarView *)view;
- (void)didClickMaintainButtonInHomeToolBarView:(TCHomeToolBarView *)view;
- (void)didClickSearchButtonInHomeToolBarView:(TCHomeToolBarView *)view;

@end
