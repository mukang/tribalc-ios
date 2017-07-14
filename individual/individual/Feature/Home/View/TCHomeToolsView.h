//
//  TCHomeToolsView.h
//  individual
//
//  Created by 穆康 on 2017/7/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCHomeToolsViewDelegate;
@interface TCHomeToolsView : UIView

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) id<TCHomeToolsViewDelegate> delegate;

@end


@protocol TCHomeToolsViewDelegate <NSObject>

@optional
- (void)didClickScanButtonInHomeToolsView:(TCHomeToolsView *)view;
- (void)didClickUnlockButtonInHomeToolsView:(TCHomeToolsView *)view;
- (void)didClickMaintainButtonInHomeToolsView:(TCHomeToolsView *)view;
- (void)didClickMeetingButtonInHomeToolsView:(TCHomeToolsView *)view;

@end
