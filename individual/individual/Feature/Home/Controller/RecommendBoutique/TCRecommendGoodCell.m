//
//  TCRecommendGoodCell.m
//  individual
//
//  Created by WYH on 16/11/4.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRecommendGoodCell.h"

@implementation TCRecommendGoodCell {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        
        self.backgroundColor = [UIColor whiteColor];
        
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height * (1 - 0.26))];
        
        [self.contentView addSubview:_goodImageView];
        
        _typeAndNameLab = [self initialWithFrame:CGRectMake(_goodImageView.frame.origin.x + 8, _goodImageView.frame.origin.y + _goodImageView.frame.size.height + 14, _goodImageView.frame.size.width - 16, 15)];
        
        _typeAndNameLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [self.contentView addSubview:_typeAndNameLab];
        
        _shopNameLab = [self initialWithFrame:CGRectMake(_typeAndNameLab.frame.origin.x + 1, _typeAndNameLab.frame.origin.y + _typeAndNameLab.frame.size.height + 13, _goodImageView.frame.size.width, 13)];
        [self.contentView addSubview:_shopNameLab];
        
        _priceLab = [self initialWithFrame:CGRectMake(_shopNameLab.frame.origin.x - 1, self.height - 2 - 17, _goodImageView.frame.size.width, 15)];
        _priceLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [self.contentView addSubview:_priceLab];
        
        _collectionImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 8 - 20, self.height - 8 - 20, 20, 20)];
        UIImage *collectionImg = [UIImage imageNamed:@"good_collection_no"];
        _collectionImgView.image = collectionImg;
        [_goodImageView addSubview:_collectionImgView];
        
        _collectionBtn = [[UIButton alloc] initWithFrame:_collectionImgView.frame];
        [self.contentView addSubview:_collectionBtn];
        
        
    }
    return self;
}



- (UILabel *)initialWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"Arial" size:12];
    label.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    return label;
}


@end
