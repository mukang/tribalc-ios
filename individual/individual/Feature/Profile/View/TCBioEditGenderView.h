//
//  TCBioEditGenderView.h
//  individual
//
//  Created by 穆康 on 2016/10/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCUserInfo.h"

@class TCBioEditGenderView;

@protocol TCBioEditGenderViewDelegate <NSObject>

@optional
- (void)bioEditGenderView:(TCBioEditGenderView *)view didClickCommitButtonWithGender:(TCUserGender)gender;
- (void)didClickCancelButtonInBioEditGenderView:(TCBioEditGenderView *)view;

@end

@interface TCBioEditGenderView : UIView

@property (weak, nonatomic) id<TCBioEditGenderViewDelegate> delegate;

@property (nonatomic) TCUserGender gender;

@end
