//
//  TCRentPlanItemViewCell.h
//  individual
//
//  Created by 穆康 on 2017/7/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCRentPlanItem;

@protocol TCRentPlanItemViewCellDelegate;
@interface TCRentPlanItemViewCell : UITableViewCell

@property (strong, nonatomic) TCRentPlanItem *planItem;
@property (weak, nonatomic) id<TCRentPlanItemViewCellDelegate> delegate;

@end

@protocol TCRentPlanItemViewCellDelegate <NSObject>

@optional
- (void)rentPlanItemViewCell:(TCRentPlanItemViewCell *)cell didClickPayButtonWithPlanItem:(TCRentPlanItem *)planItem;

@end
