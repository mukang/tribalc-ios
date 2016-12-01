//
//  TCRestaurantTableViewCell.h
//  individual
//
//  Created by WYH on 16/11/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCRestaurantTableViewCell : UITableViewCell

@property (retain, nonatomic) UIImageView *resImgView;
@property (retain, nonatomic) UILabel *nameLab;
@property (retain, nonatomic) UILabel *rangeLab;


- (void)setLocation:(NSString *)location;

- (void)setType:(NSString *)type;


- (void)setPrice:(CGFloat)price;

- (void)isSupportRoom:(BOOL)b;

- (void)isSupportReserve:(BOOL)b;

@end
