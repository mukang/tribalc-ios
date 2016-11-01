//
//  TCBioEditView.h
//  individual
//
//  Created by 穆康 on 2016/10/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCBioEditView;

@protocol TCBioEditViewDelegate <NSObject>

@optional
- (void)didClickCommitButtonInBioEditView:(TCBioEditView *)view;
- (void)didClickCancelButtonInBioEditView:(TCBioEditView *)view;

@end

@interface TCBioEditView : UIView

@property (weak, nonatomic) id<TCBioEditViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
