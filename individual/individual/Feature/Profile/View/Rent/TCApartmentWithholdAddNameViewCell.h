//
//  TCApartmentWithholdAddNameViewCell.h
//  individual
//
//  Created by 穆康 on 2017/7/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TCApartmentWithholdAddNameViewCellDelegate;
@interface TCApartmentWithholdAddNameViewCell : UITableViewCell

@property (copy, nonatomic) UITextField *textField;
@property (weak, nonatomic) id<TCApartmentWithholdAddNameViewCellDelegate> delegate;

@end

@protocol TCApartmentWithholdAddNameViewCellDelegate <NSObject>

@optional
- (void)didClickBankCardButtonInApartmentWithholdAddNameViewCell:(TCApartmentWithholdAddNameViewCell *)cell;

@end
