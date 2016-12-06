//
//  TCRepairsDescViewCell.h
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCRepairsDescViewCell;

@protocol TCRepairsDescViewCellDelegate <NSObject>

@optional
- (BOOL)textViewShouldBeginEditingInRepairsDescViewCell:(TCRepairsDescViewCell *)cell;
- (BOOL)repairsDescViewCell:(TCRepairsDescViewCell *)cell textViewShouldReturn:(UITextView *)textView;

@end

@interface TCRepairsDescViewCell : UITableViewCell

@property (weak, nonatomic) id<TCRepairsDescViewCellDelegate> delegate;

@end
