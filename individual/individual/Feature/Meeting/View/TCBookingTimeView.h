//
//  TCBookingTimeView.h
//  individual
//
//  Created by 穆康 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBookingTime.h"

@protocol TCBookingTimeViewDelegate;
@interface TCBookingTimeView : UIScrollView

@property (weak, nonatomic) id<TCBookingTimeViewDelegate> bookingTimedelegate;

- (void)reloadDataWithBookingTimeArray:(NSArray *)bookingTimeArray;

@end

@protocol TCBookingTimeViewDelegate <NSObject>

- (void)bookingTimeView:(TCBookingTimeView *)view didTapBookingTimeCellWithBookingTime:(TCBookingTime *)bookingTime;

@end
