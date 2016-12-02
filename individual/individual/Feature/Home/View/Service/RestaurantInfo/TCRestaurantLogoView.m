//
//  TCRestaurantLogoView.m
//  individual
//
//  Created by WYH on 16/11/11.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantLogoView.h"

@implementation TCRestaurantLogoView {
    UIImageView *logoImageView;
}

- (instancetype)initWithFrame:(CGRect)frame AndUrlStr:(NSString *)urlStr {
    self = [super initWithFrame:frame];
    if (self) {
//        titleStr = title;
//        
        self.layer.cornerRadius = frame.size.height / 2;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;

        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        NSURL *url = [NSURL URLWithString:urlStr];
        [logoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"good_placeholder"]];
        [self addSubview:logoImageView];
        
        
    }
    
    return self;
}

- (void)setNewFrame:(CGRect)frame {
    
    [self setFrame:frame];
    self.layer.cornerRadius = frame.size.height / 2;
    [logoImageView setSize:CGSizeMake(self.width, self.height)];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
