//
//  TCCommunityIntroViewCell.h
//  individual
//
//  Created by 穆康 on 2016/11/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCCommunityDetailInfo;
@class TCCommunityIntroViewCell;

@protocol TCCommunityIntroViewCellDelegate <NSObject>

@optional
- (void)communityIntroViewCell:(TCCommunityIntroViewCell *)cell didClickVisitButtonWithCommunityDetailInfo:(TCCommunityDetailInfo *)info;

@end

@interface TCCommunityIntroViewCell : UITableViewCell

@property (strong, nonatomic) TCCommunityDetailInfo *communityDetailInfo;
@property (weak, nonatomic) id<TCCommunityIntroViewCellDelegate> delegate;

@end
