//
//  TCRechargeMethodViewCell.h
//  individual
//
//  Created by 穆康 on 2017/4/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCRechargeMethodViewCellDelegate;
@interface TCRechargeMethodViewCell : UITableViewCell

@property (weak, nonatomic) UIImageView *logoImageView;
@property (weak, nonatomic) UILabel *titleLabel;

@property (nonatomic) BOOL hideMarkIcon; // default is NO
@property (nonatomic) BOOL showRechargeButton; // default is NO

@property (weak, nonatomic) id<TCRechargeMethodViewCellDelegate> delegate;

@end

@protocol TCRechargeMethodViewCellDelegate <NSObject>

@optional
- (void)didClickRechargeButtonInRechargeMethodViewCell:(TCRechargeMethodViewCell *)cell;

@end
