//
//  TCBiographyViewController.h
//  individual
//
//  Created by 穆康 on 2016/10/27.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TCCommonLibs/TCBaseViewController.h>

typedef void(^TCBioEditBlock)();

@interface TCBiographyViewController : TCBaseViewController

@property (copy, nonatomic) TCBioEditBlock bioEditBlock;

@end
