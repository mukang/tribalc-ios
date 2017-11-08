//
//  TCMeetingRoomContactsViewController.h
//  individual
//
//  Created by 穆康 on 2017/11/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <TCCommonLibs/TCBaseViewController.h>

@protocol TCMeetingRoomContactsViewControllerDelegate;
@interface TCMeetingRoomContactsViewController : TCBaseViewController

@property (strong, nonatomic) NSMutableArray *participants;
@property (weak, nonatomic) id<TCMeetingRoomContactsViewControllerDelegate> delegate;

@end


@protocol TCMeetingRoomContactsViewControllerDelegate <NSObject>

@optional
- (void)didClickBackButtonInMeetingRoomContactsViewController:(TCMeetingRoomContactsViewController *)vc;

@end
