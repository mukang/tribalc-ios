//
//  TCUserOrderTableViewCell.h
//  individual
//
//  Created by WYH on 16/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCComponent.h"

@interface TCUserOrderTableViewCell : UITableViewCell

@property UIImageView *leftImgView;

- (instancetype)initOrderDetailCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setTitleLabWithText:(NSString *)text;
- (void)setNumberLabel:(float)number;
- (void)setPriceLabel:(float)price;
- (void)setSelectedStandardWithDic:(NSDictionary *)standard;
- (void)setBoldPriceLabel:(float)price ;
@end
