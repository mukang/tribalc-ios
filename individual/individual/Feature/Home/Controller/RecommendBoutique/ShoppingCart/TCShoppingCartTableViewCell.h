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
#import "TCShoppingCartBaseInfoView.h"
#import "UIImageView+WebCache.h"

@interface TCShoppingCartTableViewCell : UITableViewCell <SDWebImageManagerDelegate> {
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndSelectTag:(NSString *)selectTag AndGoodsId:(NSString *)goodsId;

- (instancetype)initEditCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndSelectTag:(NSString *)selectTag AndGoodsId:(NSString *)goodsId;
@property (retain, nonatomic) UIButton *selectedBtn;
@property (retain, nonatomic) UIImageView *leftImgView;
@property (retain, nonatomic) TCShoppingCartBaseInfoView *baseInfoView;


- (void)setCount:(NSInteger)count;
- (void)setPrice:(CGFloat)price;

@end
