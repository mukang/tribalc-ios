//
//  TCRecommendListViewController.h
//  individual
//
//  Created by WYH on 16/11/4.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCRecommendGoodCell.h"
#import "TCShoppingCartViewController.h"
#import "TCGetNavigationItem.h"
#import "TCRecommendInfoViewController.h"
#import "TCBuluoApi.h"
#import "TCGoodsWrapper.h"
#import "TCGoods.h"
#import "TCClientConfig.h"
#import "MJRefresh.h"
#import "TCRecommendHeader.h"
#import "UIImageView+WebCache.h"
#import "TCRecommendFooter.h"

@interface TCRecommendListViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SDWebImageManagerDelegate>

@end
