//
//  TCProfileHeaderView.h
//  individual
//
//  Created by 穆康 on 2017/8/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCProfileHeaderViewDelegate;
@interface TCProfileHeaderView : UIView

@property (weak, nonatomic) id<TCProfileHeaderViewDelegate> delegate;

- (void)reloadData;

@end

@protocol TCProfileHeaderViewDelegate <NSObject>

@optional
- (void)didClickAvatarViewInProfileHeaderView:(TCProfileHeaderView *)view;

@end
