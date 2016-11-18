//
//  TCRecommendInfoViewController.h
//  individual
//
//  Created by WYH on 16/11/12.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCComponent.h"
#import "TCGetNavigationItem.h"
#import "TCStandardView.h"
#import "TCGoods.h"
#import "UIImageView+WebCache.h"
#import "TCClientConfig.h"


@interface TCRecommendInfoViewController : UIViewController <UIScrollViewDelegate, UIWebViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, SDWebImageManagerDelegate>


- (instancetype)initWithGoodInfo:(TCGoods *)good ;


@end
