//
//  TCMeetingRoomConditionsFloorCell.h
//  individual
//
//  Created by 王帅锋 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCMeetingRoomConditionsFloorCellDelegate <NSObject>

- (void)floorCellDidEndEditingWithTextField:(UITextField *)textfield;

@end

@interface TCMeetingRoomConditionsFloorCell : UITableViewCell

@property (weak, nonatomic) id<TCMeetingRoomConditionsFloorCellDelegate> delegate;

@end
