//
//  TCCommonInputViewCell.h
//  individual
//
//  Created by 穆康 on 2016/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCCommonInputViewCell;

@protocol TCCommonInputViewCellDelegate <NSObject>

@optional
- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField;
- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField;
- (void)didTapContainerViewIncommonInputViewCell:(TCCommonInputViewCell *)cell;

@end

@interface TCCommonInputViewCell : UITableViewCell

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *placeholder;
@property (nonatomic, getter=isInputEnabled) BOOL inputEnabled;
@property (nonatomic) NSInteger inputCellType;
@property (weak, nonatomic) id<TCCommonInputViewCellDelegate> delegate;

@end
