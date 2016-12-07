//
//  TCRepairsPhotosViewCell.h
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCRepairsPhotosViewCell;

@protocol TCRepairsPhotosViewCellDelegate <NSObject>

@optional
- (void)didClickAddButtonInRepairsPhotosViewCell:(TCRepairsPhotosViewCell *)cell;
- (void)repairsPhotosViewCell:(TCRepairsPhotosViewCell *)cell didClickDeleteButtonWithPhotoIndex:(NSInteger)photoIndex;

@end

@interface TCRepairsPhotosViewCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray *selectedPhotos;
@property (weak, nonatomic) id<TCRepairsPhotosViewCellDelegate> delegate;

@end
