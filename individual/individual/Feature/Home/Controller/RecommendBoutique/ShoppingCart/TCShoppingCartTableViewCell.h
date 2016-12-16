//
//  TCShoppingCartTableViewCell.h
//  individual
//
//  Created by WYH on 16/11/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCComponent.h"
#import "TCComputeView.h"
#import "TCModelImport.h"
#import "TCShoppingCartBaseInfoView.h"
#import "UIImageView+WebCache.h"
#import <MGSwipeTableCell/MGSwipeTableCell.h>


@interface TCShoppingCartTableViewCell : MGSwipeTableCell <SDWebImageManagerDelegate> {
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndSelectTag:(NSString *)selectTag AndCartItem:(TCCartItem *)cartItem;

- (instancetype)initEditCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndSelectTag:(NSString *)selectTag AndCartItem:(TCCartItem *)cartItem;

@property (retain, nonatomic) UIButton *selectedBtn;
@property (retain, nonatomic) UIImageView *leftImgView;
@property (retain, nonatomic) TCShoppingCartBaseInfoView *baseInfoView;
@property (copy, nonatomic) NSString *selectTag;

- (void)setCount:(NSInteger)count;
- (void)setPrice:(CGFloat)price;

@end
