//
//  TCBookingDateView.h
//  individual
//
//  Created by 穆康 on 2017/10/24.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCBookingDate.h"

@protocol TCBookingDateViewDelegate;
@interface TCBookingDateView : UIView

@property (weak, nonatomic) id<TCBookingDateViewDelegate> delegate;

- (instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate selectedDate:(NSDate *)selectedDate;

- (void)setNewSelectedDate:(NSDate *)date;

@end

@protocol TCBookingDateViewDelegate <NSObject>

@optional
- (void)bookingDateView:(TCBookingDateView *)view didScrollToNewBookingDate:(TCBookingDate *)newBookingDate;

@end



