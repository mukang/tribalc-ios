//
//  TCMeetingRoomSearchResultHeaderView.h
//  individual
//
//  Created by 王帅锋 on 2017/10/25.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCMeetingRoomConditions;

@protocol TCMeetingRoomSearchResultHeaderViewDelegate <NSObject>

- (void)headerViewDidClickModifyBtn;

@end

@interface TCMeetingRoomSearchResultHeaderView : UIView

@property (strong, nonatomic) TCMeetingRoomConditions *currentConditions;

@property (weak, nonatomic) id<TCMeetingRoomSearchResultHeaderViewDelegate> delegate;

@end
