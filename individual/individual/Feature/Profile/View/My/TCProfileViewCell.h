//
//  TCProfileViewCell.h
//  individual
//
//  Created by 穆康 on 2017/8/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCProfileViewCellDelegate;
@interface TCProfileViewCell : UITableViewCell

@property (copy, nonatomic) NSArray *materials;
@property (weak, nonatomic) id<TCProfileViewCellDelegate> delegate;

@end

@protocol TCProfileViewCellDelegate <NSObject>

@optional
- (void)profileViewCell:(TCProfileViewCell *)cell didClickFeatureButtonWithIndex:(NSInteger)index;

@end
