//
//  TCApartmentWithholdConfirmViewCell.h
//  individual
//
//  Created by 穆康 on 2017/7/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCApartmentWithholdConfirmViewCellDelegate;
@interface TCApartmentWithholdConfirmViewCell : UITableViewCell

@property (nonatomic) BOOL isEdit;
@property (weak, nonatomic) id<TCApartmentWithholdConfirmViewCellDelegate> delegate;

@end

@protocol TCApartmentWithholdConfirmViewCellDelegate <NSObject>

@optional
- (void)didClickConfirmButtonInApartmentWithholdConfirmViewCell:(TCApartmentWithholdConfirmViewCell *)cell;

@end
