//
//  TCShoppingCartTableViewCell.h
//  individual
//
//  Created by WYH on 16/11/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCComponent.h"

@interface TCShoppingCartTableViewCell : UITableViewCell {
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@property UIButton *selectedBtn;
@property UIImageView *leftImgView;
@property UILabel *titleLab;

- (void)setStandard:(NSDictionary *)standard;
- (void)setCount:(NSInteger)count;
- (void)setPrice:(CGFloat)price;

@end
