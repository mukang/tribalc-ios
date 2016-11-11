//
//  TCRestaurantLogoView.m
//  individual
//
//  Created by WYH on 16/11/11.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantLogoView.h"

@implementation TCRestaurantLogoView {
    UILabel *logoTitle;
}

- (instancetype)initWithFrame:(CGRect)frame AndTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.height / 2;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        
        logoTitle = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * 0.06, 0.58 * frame.size.height / 2, frame.size.width - (frame.size.width * 0.06 * 2), frame.size.height / 2 * 0.38)];
        logoTitle.font = [UIFont systemFontOfSize:frame.size.height / 2 * 0.38];
        logoTitle.text = title;
        logoTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:logoTitle];
        
    }
    
    return self;
}

- (void)setNewFrame:(CGRect)frame {
//    self.frame = frame;
    [self setFrame:frame];
    self.layer.cornerRadius = frame.size.height / 2;
    [logoTitle setFrame:CGRectMake(frame.size.width * 0.06, 0.58 * frame.size.height / 2, frame.size.width - (frame.size.width * 0.06 * 2), frame.size.height / 2 * 0.38)];
    logoTitle.font = [UIFont systemFontOfSize:logoTitle.height];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
