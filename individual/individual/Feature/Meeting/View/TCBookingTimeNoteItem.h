//
//  TCBookingTimeNoteItem.h
//  individual
//
//  Created by 穆康 on 2017/10/23.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TCBookingTimeNoteItemStyle) {
    TCBookingTimeNoteItemStyleNormal,
    TCBookingTimeNoteItemStyleSelected,
    TCBookingTimeNoteItemStyleDisabled
};

@interface TCBookingTimeNoteItem : UIView

@property (nonatomic, readonly) TCBookingTimeNoteItemStyle style;

- (instancetype)initWithStyle:(TCBookingTimeNoteItemStyle)style;

@end
