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
        UIImage *nullImage = [UIImage imageNamed:@"null"];
                
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 17 * 3 - 25)];
        _goodImageView.image = nullImage;
        [self.contentView addSubview:_goodImageView];
        
        _typeAndNameLab = [self initialWithFrame:CGRectMake(_goodImageView.frame.origin.x, _goodImageView.frame.origin.y + _goodImageView.frame.size.height + 8, _goodImageView.frame.size.width, 17)];
        [self.contentView addSubview:_typeAndNameLab];
        
        _shopNameLab = [self initialWithFrame:CGRectMake(_goodImageView.frame.origin.x , _typeAndNameLab.frame.origin.y + _typeAndNameLab.frame.size.height + 8, _goodImageView.frame.size.width, 17)];
        [self.contentView addSubview:_shopNameLab];
        
        _priceLab = [self initialWithFrame:CGRectMake(_goodImageView.frame.origin.x - 5, _shopNameLab.frame.origin.y + _shopNameLab.frame.size.height + 9, _goodImageView.frame.size.width, 17)];
        _priceLab.textColor = [UIColor colorWithRed:63/255.0 green:171/255.0 blue:198/255.0 alpha:1];
        [self.contentView addSubview:_priceLab];
        
        _collectionImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 33.5, 13.5, 20, 20)];
        UIImage *collectionImg = [UIImage imageNamed:@"28n"];
        _collectionImgView.image = collectionImg;
        [_goodImageView addSubview:_collectionImgView];
        
        _collectionBtn = [[UIButton alloc] initWithFrame:_collectionImgView.frame];
//        _collectionBtn.backgroundColor = [UIColor blackColor];
        [_collectionBtn addTarget:self action:@selector(touchCollectionBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_collectionBtn];
        
        
    }
    return self;
}



- (UILabel *)initialWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"Arial" size:17];
    label.textColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:96/255.0 alpha:1];
    
    return label;
}

- (void)touchCollectionBtn {
    UIImage *image = [UIImage imageNamed:@"28n"];
    UIImage *selectImg = [UIImage imageNamed:@"28"];
    if ([_collectionImgView.image isEqual:image]) {
        _collectionImgView.image = selectImg;
    } else {
        _collectionImgView.image = image;
    }
}


@end
