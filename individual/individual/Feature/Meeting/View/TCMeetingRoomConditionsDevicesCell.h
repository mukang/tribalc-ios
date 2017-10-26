//
//  TCMeetingRoomConditionsDevicesCell.h
//  individual
//
//  Created by 王帅锋 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCMeetingRoomConditionsDevicesCellDelegate <NSObject>

- (void)devicesCellDidClickDeviceBtn:(NSString *)title isDelete:(BOOL)isDelete;

@end

@interface TCMeetingRoomConditionsDevicesCell : UITableViewCell

@property (strong, nonatomic) NSArray *devices;

@property (weak, nonatomic) id<TCMeetingRoomConditionsDevicesCellDelegate> delegate;

@end
