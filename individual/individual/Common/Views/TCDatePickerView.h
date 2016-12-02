//
//  TCDatePickerView.h
//  individual
//
//  Created by 穆康 on 2016/12/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCDatePickerView;

@protocol TCDatePickerViewDelegate <NSObject>

@optional
- (void)datePickerView:(TCDatePickerView *)view didClickConfirmButtonWithDate:(NSDate *)date;

@end

@interface TCDatePickerView : UIView

@property (nonatomic, readonly) UIDatePickerMode datePickerMode;
@property (weak, nonatomic) id<TCDatePickerViewDelegate> delegate;

- (instancetype)initWithDatePickerMode:(UIDatePickerMode)mode fromController:(UIViewController *)controller;
- (void)show;

@end
