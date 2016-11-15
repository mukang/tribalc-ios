//
//  TCCalloutAnnotationView.h
//  individual
//
//  Created by WYH on 16/11/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TCCalloutAnnotation.h"

@interface TCCalloutAnnotationView : MKAnnotationView

@property (nonatomic, strong) TCCalloutAnnotation *calloutAnnotation;

+(instancetype)calloutViewWithMapView:(MKMapView *)mapView;


@end
