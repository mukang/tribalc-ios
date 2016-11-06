//
//  TCRecommendGoodCell.h
//  individual
//
//  Created by WYH on 16/11/4.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCRecommendListViewController.h"


@interface TCRecommendGoodCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *goodImageView;

@property (strong, nonatomic) UILabel *typeAndNameLab;

@property (strong, nonatomic) UILabel *shopNameLab;

@property (strong, nonatomic) UILabel *priceLab;

@property UIImageView *collectionImgView;

@property UIButton *collectionBtn;

@end
