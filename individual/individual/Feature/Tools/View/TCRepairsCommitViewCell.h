//
//  TCRepairsCommitViewCell.h
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCRepairsCommitViewCell;

@protocol TCRepairsCommitViewCellDelegate <NSObject>

@optional
- (void)didClickCommitButtonInRepairsCommitViewCell:(TCRepairsCommitViewCell *)cell;

@end

@interface TCRepairsCommitViewCell : UITableViewCell

@property (weak, nonatomic) id<TCRepairsCommitViewCellDelegate> delegate;

@end
