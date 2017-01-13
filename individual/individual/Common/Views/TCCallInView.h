//
//  TCCallInView.h
//  individual
//
//  Created by 王帅锋 on 17/1/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MyBlock)();

@interface TCCallInView : UIImageView
- (instancetype)initWithController:(UIViewController *)controller endBlock:(MyBlock)b;
- (void)show;
@end
