//
//  TCPaymentDetailView.h
//  individual
//
//  Created by 穆康 on 2016/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCPaymentDetailView;

@protocol TCPaymentDetailViewDelegate <NSObject>

@optional
- (void)didClickConfirmButtonInPaymentDetailView:(TCPaymentDetailView *)view;
- (void)didClickCloseButtonInPaymentDetailView:(TCPaymentDetailView *)view;
- (void)didClickQueryButtonInPaymentDetailView:(TCPaymentDetailView *)view;
- (void)didTapChangePaymentMethodViewInPaymentDetailView:(TCPaymentDetailView *)view;

@end

@interface TCPaymentDetailView : UIView

/** 需付金额 */
@property (nonatomic) double totalFee;
/** 付款方式 */
@property (weak, nonatomic) IBOutlet UILabel *methodLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;

@property (weak, nonatomic) id<TCPaymentDetailViewDelegate> delegate;

@end
