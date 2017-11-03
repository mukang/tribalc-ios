//
//  TCMeetingRoomReservationCancelView.h
//  individual
//
//  Created by 王帅锋 on 2017/11/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCMeetingRoomReservationCancelViewDelegate <NSObject>

- (void)cancelViewDidClickCancelBtn;

@end

@interface TCMeetingRoomReservationCancelView : UIView

@property (weak, nonatomic) id<TCMeetingRoomReservationCancelViewDelegate> delegate;

@end
