//
//  TCBioEditNickViewController.h
//  individual
//
//  Created by 穆康 on 2016/12/15.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TCBioEditNickBlock)(NSString *nickname);

@interface TCBioEditNickViewController : UIViewController

@property (copy, nonatomic) NSString *nickname;
@property (nonatomic) TCBioEditNickBlock editNickBlock;

@end
