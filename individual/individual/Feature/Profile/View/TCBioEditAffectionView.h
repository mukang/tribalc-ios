//
//  TCBioEditAffectionView.h
//  individual
//
//  Created by 穆康 on 2016/10/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCUserInfo.h"

@class TCBioEditAffectionView;

@protocol TCBioEditAffectionViewDelegate <NSObject>

@optional
- (void)bioEditAffectionView:(TCBioEditAffectionView *)view didClickCommitButtonWithEmotionState:(TCUserEmotionState)emotionState;
- (void)didClickCancelButtonInBioEditAffectionView:(TCBioEditAffectionView *)view;

@end


/**
 情感状况
 */
@interface TCBioEditAffectionView : UIView

@property (weak, nonatomic) id<TCBioEditAffectionViewDelegate> delegate;

@property (nonatomic) TCUserEmotionState emotionState;

@end
