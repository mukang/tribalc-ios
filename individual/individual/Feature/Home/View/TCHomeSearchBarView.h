//
//  TCHomeSearchBarView.h
//  individual
//
//  Created by 穆康 on 2017/7/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCHomeSearchBarViewDelegate;
@interface TCHomeSearchBarView : UIView

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) id<TCHomeSearchBarViewDelegate> delegate;

@end


@protocol TCHomeSearchBarViewDelegate <NSObject>

@optional
- (void)didClickSearchBarInHomeSearchBarView:(TCHomeSearchBarView *)view;

@end
