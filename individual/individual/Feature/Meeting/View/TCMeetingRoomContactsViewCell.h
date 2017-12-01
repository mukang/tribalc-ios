//
//  TCMeetingRoomContactsViewCell.h
//  individual
//
//  Created by 穆康 on 2017/11/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "TCMeetingParticipant.h"

@interface TCMeetingRoomContactsViewCell : MGSwipeTableCell

@property (strong, nonatomic) TCMeetingParticipant *participant;

@end

