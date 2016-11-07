//
//  TCProfileHeaderView.h
//  individual
//
//  Created by 穆康 on 2016/11/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCProfileHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIView *avatarBgView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *loginButton;
@property (weak, nonatomic) IBOutlet UIView *nickBgView;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIButton *wantGradeButton;
@property (weak, nonatomic) IBOutlet UIButton *photographButton;

@end
