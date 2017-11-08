//
//  TCMeetingRoomDeleteContactsViewCell.h
//  individual
//
//  Created by 穆康 on 2017/11/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCMeetingParticipant.h"

@protocol TCMeetingRoomDeleteContactsViewCellDelegate;
@interface TCMeetingRoomDeleteContactsViewCell : UITableViewCell

@property (strong, nonatomic) TCMeetingParticipant *participant;
@property (weak, nonatomic) id<TCMeetingRoomDeleteContactsViewCellDelegate> delegate;

@end

@protocol TCMeetingRoomDeleteContactsViewCellDelegate <NSObject>

@optional
- (void)meetingRoomDeleteContactsViewCell:(TCMeetingRoomDeleteContactsViewCell *)cell didTapSelectedViewWithParticipant:(TCMeetingParticipant *)participant;

@end
