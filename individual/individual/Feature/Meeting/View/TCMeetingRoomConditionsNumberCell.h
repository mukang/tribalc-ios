//
//  TCMeetingRoomConditionsNumberCell.h
//  individual
//
//  Created by 王帅锋 on 2017/10/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCMeetingRoomConditionsNumberCellDelegate <NSObject>

- (void)numberCelldidEndEditingWithTextField:(UITextField *)textfield;

@end

@interface TCMeetingRoomConditionsNumberCell : UITableViewCell

@property (weak, nonatomic) id<TCMeetingRoomConditionsNumberCellDelegate> delegate;

@end
