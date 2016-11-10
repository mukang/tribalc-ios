//
//  TCRestaurantSortView.m
//  individual
//
//  Created by WYH on 16/11/10.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantSortView.h"

@implementation TCRestaurantSortView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *firstVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(24 + 118, (frame.size.height - 169) / 2, 0.5, 169)];
        firstVerticalLine.backgroundColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
        
        UIView *secondVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - 24 - 119, firstVerticalLine.y, firstVerticalLine.width, firstVerticalLine.height)];
        secondVerticalLine.backgroundColor = firstVerticalLine.backgroundColor;
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(24, frame.size.height / 2 - 0.5, frame.size.width - 48, 0.5)];
        horizontalLine.backgroundColor = secondVerticalLine.backgroundColor;
        [self addSubview:firstVerticalLine];
        [self addSubview:secondVerticalLine];
        [self addSubview:horizontalLine];
        
        
        
        _averageMinBtn = [[TCSelectSortButton alloc] initWithFrame:CGRectMake(24, 0, firstVerticalLine.x - 24, horizontalLine.y) AndImgName:@"average_min" AndText:@"人均最低"];
        [self addSubview:_averageMinBtn];

        _averageMaxBtn = [[TCSelectSortButton alloc] initWithFrame:CGRectMake(firstVerticalLine.x + firstVerticalLine.width, 0, secondVerticalLine.x - firstVerticalLine.x + firstVerticalLine.width, _averageMinBtn.height) AndImgName:@"average_max" AndText:@"人均最高"];
        [self addSubview:_averageMaxBtn];
        
        _popularityMaxBtn = [[TCSelectSortButton alloc] initWithFrame:CGRectMake(secondVerticalLine.x + 0.5, 0, frame.size.width - 24 - secondVerticalLine.x + 1, _averageMinBtn.height) AndImgName:@"popularity_max" AndText:@"人气最高"];
        [self addSubview:_popularityMaxBtn];
        
        _distanceMinBtn = [[TCSelectSortButton alloc] initWithFrame:CGRectMake(_averageMinBtn.x, frame.size.height / 2, _averageMinBtn.width, frame.size.height - _averageMinBtn.height + 0.5) AndImgName:@"near" AndText:@"离我最近"];
        [self addSubview:_distanceMinBtn];
        
        _evaluateMaxBtn = [[TCSelectSortButton alloc] initWithFrame:CGRectMake(_averageMaxBtn.x, _distanceMinBtn.y, _averageMaxBtn.width, _distanceMinBtn.height) AndImgName:@"evaluate" AndText:@"评价最高"];
        [self addSubview:_evaluateMaxBtn];
        
                
    }
    
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
