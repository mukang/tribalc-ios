//
//  TCRestaurantTableViewCell.h
//  individual
//
//  Created by WYH on 16/11/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCRestaurantTableViewCell : UITableViewCell

@property UIImageView *resImgView;
@property UILabel *nameLab;
@property UILabel *rangeLab;

@property UIButton *privateRoomBtn;
@property UIButton *reserveBtn;

- (void)setLocation:(NSString *)location;

- (void)setType:(NSString *)type;

- (void)showRestaurantButton;

- (void)setPrice:(NSString *)price;

@end
