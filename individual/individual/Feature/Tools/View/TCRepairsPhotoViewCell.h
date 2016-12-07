//
//  TCRepairsPhotoViewCell.h
//  individual
//
//  Created by 穆康 on 2016/12/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCRepairsPhotoViewCell;

@protocol TCRepairsPhotoViewCellDelegate <NSObject>

@optional
- (void)didClickAddButtonInRepairsPhotoViewCell:(TCRepairsPhotoViewCell *)cell;
- (void)didClickDeleteButtonInRepairsPhotoViewCell:(TCRepairsPhotoViewCell *)cell;

@end

@interface TCRepairsPhotoViewCell : UICollectionViewCell

@property (weak, nonatomic) id<TCRepairsPhotoViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) BOOL hideAddButton;

@end
