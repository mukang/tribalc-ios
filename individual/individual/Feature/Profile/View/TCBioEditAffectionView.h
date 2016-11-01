//
//  TCBioEditAffectionView.h
//  individual
//
//  Created by 穆康 on 2016/10/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCBioEditAffectionView;

@protocol TCBioEditAffectionViewDelegate <NSObject>

@optional
- (void)didClickCancelButtonInBioEditAffectionView:(TCBioEditAffectionView *)view;

@end

@interface TCBioEditAffectionView : UIView

@property (weak, nonatomic) id<TCBioEditAffectionViewDelegate> delegate;

@end
