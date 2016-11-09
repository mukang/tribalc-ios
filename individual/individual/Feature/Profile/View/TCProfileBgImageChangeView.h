//
//  TCProfileBgImageChangeView.h
//  individual
//
//  Created by 穆康 on 2016/11/9.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCProfileBgImageChangeView;

@protocol TCProfileBgImageChangeViewDelegate <NSObject>

@optional
- (void)didClickPhotographButtonInProfileBgImageChangeView:(TCProfileBgImageChangeView *)view;
- (void)didClickAlbumButtonInProfileBgImageChangeView:(TCProfileBgImageChangeView *)view;
- (void)didClickCancelButtonInProfileBgImageChangeView:(TCProfileBgImageChangeView *)view;

@end

@interface TCProfileBgImageChangeView : UIView

@property (weak, nonatomic) id<TCProfileBgImageChangeViewDelegate> delegate;

@end
