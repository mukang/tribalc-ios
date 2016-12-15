//
//  TCRestaurantFilterView.m
//  individual
//
//  Created by WYH on 16/11/10.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantFilterView.h"

@implementation TCRestaurantFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:251/255.0 green:251/255.0 blue:251/255.0 alpha:1];
        
        UIView *firstLine = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width / 3, TCRealValue(8), TCRealValue(0.5), frame.size.height - TCRealValue(8) * 2)];
        UIView *secondLine = [[UIView alloc] initWithFrame:CGRectMake(firstLine.x + firstLine.width + frame.size.width - firstLine.x * 2, firstLine.y, TCRealValue(0.5), firstLine.height)];
        firstLine.backgroundColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
        secondLine.backgroundColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
        [self addSubview:firstLine];
        [self addSubview:secondLine];
        
        _reserveBtn = [[TCSelectSortButton alloc] initWithFrame:CGRectMake(TCRealValue(12), 0, firstLine.x - TCRealValue(12), frame.size.height) AndImgName:@"res_reserve2" AndText:@"可预订"];
        [self addSubview:_reserveBtn];
        
        _deliverBtn = [[TCSelectSortButton alloc] initWithFrame:CGRectMake(firstLine.x + firstLine.width, 0, secondLine.x - firstLine.x + firstLine.width, frame.size.height) AndImgName:@"res_deliver" AndText:@"有包间"];
        [self addSubview:_deliverBtn];
        
//        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, [UIScreen mainScreen].bounds.size.height - self.height)];
//        backView.backgroundColor = [UIColor redColor];
//        [self addSubview:backView];
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
