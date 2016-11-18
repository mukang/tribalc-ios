//
//  TCCalloutDetailAnnotationView.m
//  individual
//
//  Created by WYH on 16/11/17.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCalloutDetailAnnotationView.h"

@implementation TCCalloutDetailAnnotationView {
    UIImageView *backImgView;
    UILabel *titleLab;
    UILabel *addressLab;
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
    titleLab = [[UILabel alloc] init];
    addressLab = [[UILabel alloc] init];
    backImgView = [[UIImageView alloc] init];
    
    [self addSubview:backImgView];
    [self addSubview:titleLab];
    [self addSubview:addressLab];
}

- (void)setAnnotation:(TCCalloutAnnotation *)annotation {
    UIImage *backImg = [UIImage imageNamed:@"map_background"];
    backImgView.frame = CGRectMake(5, 5, 100, 100);
//    backImgView.image = backImg;
    backImgView.backgroundColor = [UIColor redColor];
    
    titleLab.text = annotation.titleStr;
    titleLab.font = [UIFont fontWithName:@"" size:16];
    titleLab.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    titleLab.frame = CGRectMake(0, 10, backImgView.width, 16);
    titleLab.textAlignment = NSTextAlignmentCenter;
    
    addressLab.text = annotation.addressStr;
    addressLab.font = [UIFont systemFontOfSize:11];
    addressLab.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    addressLab.frame = CGRectMake(0, titleLab.y + titleLab.height + 4, titleLab.width, 11);
    addressLab.textAlignment = NSTextAlignmentCenter;
    
}


+(instancetype)calloutViewWithMapView:(MKMapView *)mapView {
    static NSString *calloutKey = @"calloutKey";
    TCCalloutDetailAnnotationView *calloutView = (TCCalloutDetailAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:calloutKey];
    if (!calloutView) {
        calloutView = [[TCCalloutDetailAnnotationView alloc] init];
    }
    
    return calloutView;
}



@end
