//
//  TCMeetingRoomRemindViewController.h
//  individual
//
//  Created by 穆康 on 2017/11/2.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>
#import "TCMeetingRoomRemind.h"

@protocol TCMeetingRoomRemindViewControllerDelegate;
@interface TCMeetingRoomRemindViewController : TCBaseViewController

@property (strong, nonatomic) TCMeetingRoomRemind *currentRemind;

@property (weak, nonatomic) id<TCMeetingRoomRemindViewControllerDelegate> delegate;

@end

@protocol TCMeetingRoomRemindViewControllerDelegate <NSObject>

@optional
- (void)didClickConfirmButtonInMeetingRoomRemindViewController:(TCMeetingRoomRemindViewController *)vc;

@end
