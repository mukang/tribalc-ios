//
//  TCCalloutDetailAnnotationView.h
//  individual
//
//  Created by WYH on 16/11/17.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "TCCalloutAnnotation.h"


@interface TCCalloutDetailAnnotationView : MKAnnotationView

@property (nonatomic, strong)TCCalloutAnnotation *calloutAnnotation;

+(instancetype)calloutViewWithMapView:(MKMapView *)mapView;

@end
