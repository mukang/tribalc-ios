//
//  TCCompanyRentPayDetailView.h
//  individual
//
//  Created by 穆康 on 2017/8/8.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCRentPlanItem;

@protocol TCCompanyRentPayDetailViewDelegate;
@interface TCCompanyRentPayDetailView : UIView

@property (copy, nonatomic) NSString *companyName;
@property (strong, nonatomic) TCRentPlanItem *planItem;
@property (weak, nonatomic) id<TCCompanyRentPayDetailViewDelegate> delegate;

@end

@protocol TCCompanyRentPayDetailViewDelegate <NSObject>

@optional
- (void)didClickPayButtonInCompanyRentPayDetailView:(TCCompanyRentPayDetailView *)view;

@end
