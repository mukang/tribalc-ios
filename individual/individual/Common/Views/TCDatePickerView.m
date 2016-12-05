//
//  TCDatePickerView.m
//  individual
//
//  Created by 穆康 on 2016/12/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCDatePickerView.h"

static CGFloat const duration = 0.25;

@interface TCDatePickerView ()

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIDatePicker *datePicker;

@end

@implementation TCDatePickerView {
    __weak TCDatePickerView *weakSelf;
    __weak UIViewController *sourceController;
}

- (instancetype)initWithDatePickerMode:(UIDatePickerMode)mode fromController:(UIViewController *)controller {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        weakSelf = self;
        sourceController = controller;
        _datePickerMode = mode;
        [self initPrivate];
    }
    return self;
}

- (void)show {
    if (!sourceController) return;
    
    UIView *superView;
    if (sourceController.navigationController) {
        superView = sourceController.navigationController.view;
    } else {
        superView = sourceController.view;
    }
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
    
    [UIView animateWithDuration:duration animations:^{
        weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
        weakSelf.containerView.y = TCScreenHeight - weakSelf.containerView.height;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:duration animations:^{
        weakSelf.backgroundColor = TCARGBColor(0, 0, 0, 0);
        weakSelf.containerView.y = TCScreenHeight;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - Private Methods

- (void)initPrivate {
    self.backgroundColor = TCARGBColor(0, 0, 0, 0);
    
    CGFloat containerViewH = 236;
    CGFloat buttonW = 60;
    CGFloat buttonH = 40;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, TCScreenHeight, TCScreenWidth, containerViewH)];
    containerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:containerView];
    self.containerView = containerView;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    NSAttributedString *attTitle = [[NSAttributedString alloc] initWithString:@"取消"
                                                                   attributes:@{
                                                                                NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                NSForegroundColorAttributeName: TCRGBColor(81, 199, 209)
                                                                                }];
    [cancelButton setAttributedTitle:attTitle forState:UIControlStateNormal];
    attTitle = [[NSAttributedString alloc] initWithString:@"取消"
                                               attributes:@{
                                                            NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                            NSForegroundColorAttributeName: TCRGBColor(10, 164, 177)
                                                            }];
    [cancelButton setAttributedTitle:attTitle forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(handleClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.frame = CGRectMake(20, 0, buttonW, buttonH);
    [containerView addSubview:cancelButton];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    attTitle = [[NSAttributedString alloc] initWithString:@"确定"
                                               attributes:@{
                                                            NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                            NSForegroundColorAttributeName: TCRGBColor(81, 199, 209)
                                                            }];
    [confirmButton setAttributedTitle:attTitle forState:UIControlStateNormal];
    attTitle = [[NSAttributedString alloc] initWithString:@"确定"
                                               attributes:@{
                                                            NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                            NSForegroundColorAttributeName: TCRGBColor(10, 164, 177)
                                                            }];
    [confirmButton setAttributedTitle:attTitle forState:UIControlStateHighlighted];
    [confirmButton addTarget:self action:@selector(handleClickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.frame = CGRectMake(containerView.width - 20 - buttonW, 0, buttonW, buttonH);
    [containerView addSubview:confirmButton];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.backgroundColor = TCRGBColor(242, 242, 242);
    datePicker.datePickerMode = _datePickerMode;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = 1990;
    components.month = 1;
    components.day = 1;
    datePicker.date = [[NSCalendar currentCalendar] dateFromComponents:components];
    components.year = 2016;
    components.month = 1;
    components.day = 1;
    datePicker.maximumDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    datePicker.frame = CGRectMake(0, 40, containerView.width, containerView.height - 40);
    [containerView addSubview:datePicker];
    self.datePicker = datePicker;
}

#pragma mark - Actions

- (void)handleClickCancelButton:(UIButton *)sender {
    [self dismiss];
}

- (void)handleClickConfirmButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(datePickerView:didClickConfirmButtonWithDate:)]) {
        [self.delegate datePickerView:self didClickConfirmButtonWithDate:self.datePicker.date];
    }
    [self dismiss];
}

@end
