//
//  TCRecommendFooter.m
//  individual
//
//  Created by WYH on 16/11/17.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRecommendFooter.h"

@implementation TCRecommendFooter

- (void)prepare {
    [super prepare];
    
    [self setTitle:@"刷新中" forState:MJRefreshStateRefreshing];
    [self setTitle:@"松手即刷新" forState:MJRefreshStatePulling];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
