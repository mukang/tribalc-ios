//
//  TCRestaurantViewController.h
//  individual
//
//  Created by chen on 16/11/3.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCRestaurantTableViewCell.h"
#import "TCRestaurantInfoViewController.h"
#import "TCGetNavigationItem.h"
#import "TCRestaurantSortView.h"
#import "TCRestaurantSelectButton.h"
#import "TCRestaurantFilterView.h"


@interface TCRestaurantViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mResaurantTableView;
}
@end
