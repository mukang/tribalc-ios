//
//  TCComputeView.h
//  individual
//
//  Created by WYH on 16/11/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCComponent.h"

@interface TCComputeView : UIView

@property (retain, nonatomic) UIButton *addBtn;
@property (retain, nonatomic) UIButton *subBtn;

- (void)setCount:(NSInteger)count;

@end