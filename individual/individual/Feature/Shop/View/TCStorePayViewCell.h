//
//  TCStorePayViewCell.h
//  individual
//
//  Created by 穆康 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCStorePayViewCellDelegate;
@interface TCStorePayViewCell : UITableViewCell

@property (weak, nonatomic) id<TCStorePayViewCellDelegate> delegate;

@end

@protocol TCStorePayViewCellDelegate <NSObject>

@optional
- (void)didClickPayButtonInStorePayViewCell:(TCStorePayViewCell *)cell;

@end
