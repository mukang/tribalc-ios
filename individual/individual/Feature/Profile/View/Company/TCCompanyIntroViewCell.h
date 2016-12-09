//
//  TCCompanyIntroViewCell.h
//  individual
//
//  Created by 穆康 on 2016/12/8.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TCCompanyInfo;
@class TCCompanyIntroViewCell;

@protocol TCCompanyIntroViewCellDelegate <NSObject>

@optional
- (void)companyIntroViewCell:(TCCompanyIntroViewCell *)cell didClickUnfoldButtonWithUnfold:(BOOL)unfold;

@end

@interface TCCompanyIntroViewCell : UITableViewCell

/** 是否展开，默认为折叠状态 */
@property (nonatomic, getter=isUnfold) BOOL unfold;
@property (strong, nonatomic) TCCompanyInfo *companyInfo;
@property (weak, nonatomic) id<TCCompanyIntroViewCellDelegate> delegate;

/**
 *  返回cell高度
 */
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withCompanyInfo:(TCCompanyInfo *)companyInfo unfold:(BOOL)unfold;

@end
