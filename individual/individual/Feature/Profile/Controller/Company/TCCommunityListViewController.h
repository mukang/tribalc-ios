//
//  TCCommunityListViewController.h
//  individual
//
//  Created by 穆康 on 2016/12/7.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCCompanyListViewController.h"

@interface TCCommunityListViewController : UIViewController

@property (copy, nonatomic) TCCompanyInfoBlock companyInfoBlock;
@property (weak, nonatomic) UIViewController *popToVC;

@end
