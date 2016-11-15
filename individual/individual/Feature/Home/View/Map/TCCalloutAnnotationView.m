//
//  TCCalloutAnnotationView.m
//  individual
//
//  Created by WYH on 16/11/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCalloutAnnotationView.h"

@implementation TCCalloutAnnotationView {
    UIView *backgroundView;
    UIImageView *iconView;
    UILabel *detailLabel;
    UIImageView *rateView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layoutUI];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutUI];
    }
    
    return self;
}

- (void)layoutUI {
    backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    iconView = [[UIImageView alloc] init];
    
    detailLabel = [[UILabel alloc] init];
    detailLabel.lineBreakMode = NSLineBreakByCharWrapping;
    detailLabel.font = [UIFont systemFontOfSize:12];
    
    rateView = [[UIImageView alloc] init];
    
    [self addSubview:backgroundView];
    [self addSubview:iconView];
    [self addSubview:detailLabel];
    [self addSubview:rateView];
}

- (void)setAnnotation:(TCCalloutAnnotation *)annotation {
    [super setAnnotation:annotation];
    
    iconView.image = annotation.icon;
    iconView.frame = CGRectMake(5, 5, annotation.icon.size.width, annotation.icon.size.height);
    
    detailLabel.text = annotation.detail;
    float detailWidth = 150.0;
    CGSize detailSize = [annotation.detail boundingRectWithSize:CGSizeMake(detailWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
    float detailX=CGRectGetMaxX(iconView.frame)+5;
    detailLabel.frame = CGRectMake(detailX, 5, detailSize.width, detailSize.height);
    rateView.image = annotation.rate;
    rateView.frame = CGRectMake(detailX, CGRectGetMaxY(detailLabel.frame)+5, annotation.rate.size.width, annotation.rate.size.height);
    float backgroundWidth=CGRectGetMaxX(detailLabel.frame)+5;
    float backgroundHeight=iconView.frame.size.height+2*5;
    backgroundView.frame=CGRectMake(0, 0, backgroundWidth, backgroundHeight);
    self.bounds=CGRectMake(0, 0, backgroundWidth, backgroundHeight+80);
    
    
}

+(instancetype)calloutViewWithMapView:(MKMapView *)mapView {
    static NSString *calloutKey = @"calloutKey";
    TCCalloutAnnotationView *calloutView = (TCCalloutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:calloutKey];
    if (!calloutView) {
        calloutView = [[TCCalloutAnnotationView alloc] init];
    }
    
    return calloutView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
