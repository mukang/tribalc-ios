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
        self.layer.borderColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:0.3].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;

        logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height / 2)];
        NSURL *url = [NSURL URLWithString:urlStr];
        [logoImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home_image_place"]];
        [self addSubview:logoImageView];
        
        
    }
    
    return self;
}

- (void)setNewFrame:(CGRect)frame {
    
    [self setFrame:frame];
    self.layer.cornerRadius = frame.size.height / 2;
    [logoImageView setSize:CGSizeMake(self.width, self.height / 2)];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
