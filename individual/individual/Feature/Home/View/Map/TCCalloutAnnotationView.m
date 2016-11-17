//
//  TCCalloutAnnotationView.m
//  individual
//
//  Created by WYH on 16/11/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCalloutAnnotationView.h"

@implementation TCCalloutAnnotationView {
    UIImageView *titleImgView;
    UILabel *titleLab;
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
    titleImgView = [[UIImageView alloc] init];
    titleLab = [[UILabel alloc] init];
    
    [self addSubview:titleImgView];
    [self addSubview:titleLab];
}

- (void)setAnnotation:(TCAnnotation *)annotation {
    [super setAnnotation:annotation];
    
    UIImage *image = annotation.titleImage;
    titleImgView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    titleImgView.image = image;
    
    titleLab.text = annotation.title;
    titleLab.font = [UIFont systemFontOfSize:image.size.height];
    [titleLab setOrigin:CGPointMake(titleImgView.x + titleImgView.width + 1, 0)];
    
    
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
