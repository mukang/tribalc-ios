//
//  TCMeetingRoomAddContactsViewController.h
//  individual
//
//  Created by 穆康 on 2017/11/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

@protocol TCMeetingRoomAddContactsViewControllerDelegate;
@interface TCMeetingRoomAddContactsViewController : TCBaseViewController

@property (weak, nonatomic) id<TCMeetingRoomAddContactsViewControllerDelegate> delegate;

@end


@protocol TCMeetingRoomAddContactsViewControllerDelegate <NSObject>

@optional
- (void)meetingRoomAddContactsViewController:(TCMeetingRoomAddContactsViewController *)vc didClickSaveButtonWithParticipantArray:(NSArray *)participantArray;

@end
