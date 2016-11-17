//
//  TCCalloutDetailAnnotationView.m
//  individual
//
//  Created by WYH on 16/11/17.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCalloutDetailAnnotationView.h"

@implementation TCCalloutDetailAnnotationView



+(instancetype)calloutViewWithMapView:(MKMapView *)mapView {
    static NSString *calloutKey = @"calloutKey";
    TCCalloutDetailAnnotationView *calloutView = (TCCalloutDetailAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:calloutKey];
    if (!calloutView) {
        calloutView = [[TCCalloutDetailAnnotationView alloc] init];
    }
    
    return calloutView;
}



@end
