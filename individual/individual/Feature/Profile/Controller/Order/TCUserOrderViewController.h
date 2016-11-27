//
//  TCOrderViewController.h
//  individual
//
//  Created by WYH on 16/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCUserOrderTableViewCell.h"
#import "TCComponent.h"

@interface TCUserOrderViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    UITableView *orderTableView;
    NSArray *myOrderInfoArr;
}
- (instancetype)initWithMyOrderInfo:(NSArray *)array;

@end
