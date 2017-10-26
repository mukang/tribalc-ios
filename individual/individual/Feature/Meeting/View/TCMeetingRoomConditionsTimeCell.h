//
//  TCMeetingRoomConditionsTimeCell.h
//  individual
//
//  Created by 王帅锋 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCMeetingRoomConditionsTimeCellDelegate <NSObject>

- (void)timeCellDidEndEditingWithTextField:(UITextField *)textfield;

@end
@interface TCMeetingRoomConditionsTimeCell : UITableViewCell

@property (weak, nonatomic) id<TCMeetingRoomConditionsTimeCellDelegate> delegate;

@end
