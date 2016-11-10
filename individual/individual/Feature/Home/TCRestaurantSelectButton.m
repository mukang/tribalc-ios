//
//  TCRestaurantSelectButton.m
//  individual
//
//  Created by WYH on 16/11/10.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantSelectButton.h"

@implementation TCRestaurantSelectButton

- (instancetype)initWithFrame:(CGRect)frame AndText:(NSString *)text AndImgName:(NSString *)imgName{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.text = text;
        _titleLab.font = [UIFont fontWithName:@"Arial" size:14];
        _titleLab.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
        [_titleLab sizeToFit];
        
        
        _imgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
        [_imgeView sizeToFit];
        
        [_titleLab setOrigin:CGPointMake(frame.size.width / 2 - (_titleLab.size.width + _imgeView.size.width) / 2, (frame.size.height - _titleLab.height) / 2)];
        [_imgeView setOrigin:CGPointMake(_titleLab.x + _titleLab.width + 3, (frame.size.height - _imgeView.height) / 2)];
        
        [self addSubview:_titleLab];
        [self addSubview:_imgeView];
        
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
