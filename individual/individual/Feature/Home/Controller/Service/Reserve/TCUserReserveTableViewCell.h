//
//  TCUserReserveTableViewCell.h
//  individual
//
//  Created by WYH on 16/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCUserReserveTableViewCell : UITableViewCell

@property (retain, nonatomic) UIImageView *storeImageView;

@property (retain, nonatomic) UILabel *timeLab;

@property (retain, nonatomic) UILabel *personNumberLab;

- (void)setPlaceLabText:(NSString *)text;

- (void)setBrandLabText:(NSString *)text;

- (void)setTitleLabText:(NSString *)text;

@end
