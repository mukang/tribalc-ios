//
//  TCMeetingRoomConditionsDurationCell.h
//  individual
//
//  Created by 王帅锋 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCMeetingRoomConditionsDurationCellDelegate <NSObject>

- (void)durationCellshouldBeginEditingWithTextField:(UITextField *)textfield;

@end

@interface TCMeetingRoomConditionsDurationCell : UITableViewCell

@property (weak, nonatomic) id<TCMeetingRoomConditionsDurationCellDelegate> delegate;

@end
