//
//  TCUserLocationAnnotationView.m
//  individual
//
//  Created by WYH on 16/11/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUserLocationAnnotationView.h"

@implementation TCUserLocationAnnotationView {

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
    
    self.image = [UIImage imageNamed:@"map_me"];
    
}

- (void)setAnnotation:(TCUserLocationAnnotation *)annotation {
    [super setAnnotation:annotation];
    
    UIImageView *headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 29, 29)];
    headImgView.layer.cornerRadius = 14.5;
    headImgView.layer.masksToBounds = YES;
    headImgView.image = annotation.userImage;
    [self addSubview:headImgView];
    
}

+(instancetype)calloutViewWithMapView:(MKMapView *)mapView {
    static NSString *calloutKey = @"calloutKey";
    TCUserLocationAnnotationView *calloutView = (TCUserLocationAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:calloutKey];
    if (!calloutView) {
        calloutView = [[TCUserLocationAnnotationView alloc] init];
    }
    
    return calloutView;
}



@end
