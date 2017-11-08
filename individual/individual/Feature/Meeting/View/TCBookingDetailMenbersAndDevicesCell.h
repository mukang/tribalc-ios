//
//  TCBookingDetailMenbersAndDevicesCell.h
//  individual
//
//  Created by 王帅锋 on 2017/10/27.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCMeetingRoomReservationDetail;

@protocol TCBookingDetailMenbersAndDevicesCellDelegate <NSObject>

- (void)didClickShowParticipants;

@end

@interface TCBookingDetailMenbersAndDevicesCell : UITableViewCell

@property (strong, nonatomic) TCMeetingRoomReservationDetail *meetingRoomReservationDetail;

@property (weak, nonatomic) id<TCBookingDetailMenbersAndDevicesCellDelegate> delegate;

@end
