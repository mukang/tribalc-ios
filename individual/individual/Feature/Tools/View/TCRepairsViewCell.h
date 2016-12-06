//
//  TCRepairsViewCell.h
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCRepairsViewCell;

@protocol TCRepairsViewCellDelegate <NSObject>

@optional
- (void)didClickRepairsButtonInRepairsViewCell:(TCRepairsViewCell *)cell;

@end

@interface TCRepairsViewCell : UITableViewCell

@property (weak, nonatomic) id<TCRepairsViewCellDelegate> delegate;

@end
