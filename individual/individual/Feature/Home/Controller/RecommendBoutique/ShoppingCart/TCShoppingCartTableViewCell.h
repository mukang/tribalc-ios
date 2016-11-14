//
//  TCShoppingCartTableViewCell.h
//  individual
//
//  Created by WYH on 16/11/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCShoppingCartTableViewCell : UITableViewCell {
    
}

@property UIButton *select;
@property UIImageView *imgView;
@property UILabel *typeAndName;
@property UILabel *shopName;
@property UILabel *size;
@property UILabel *count;
@property UILabel *price;

@property UILabel *allSize;
@property UIButton *subBtn;
@property UIButton *addBtn;


- (instancetype)initWithCellHeight:(float)cellHeihgt;


@end
