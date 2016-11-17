//
//  TCLocationViewController.m
//  individual
//
//  Created by WYH on 16/11/13.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLocationViewController.h"

@interface TCLocationViewController ()

@end

@implementation TCLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mMapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    mMapView.delegate = self;
    [self.view addSubview:mMapView];
    
    mLocationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        [mLocationManager requestWhenInUseAuthorization];
    }
    
    mMapView.userTrackingMode = MKUserTrackingModeFollow;
    mMapView.mapType = MKMapTypeStandard;
    
    [self addAnnotation];
}

- (void)addAnnotation {
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(37.785834, -122.405417);
    TCAnnotation *annotation1 = [[TCAnnotation alloc] init];
    annotation1.title = @"title1";
    annotation1.subtitle = @"hahahahha";
    annotation1.titleImage = [UIImage imageNamed:@"美食"];
    annotation1.coordinate = location1;
    [mMapView addAnnotation:annotation1];
    
}

#pragma mark - delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"经度%f 纬度%f", userLocation.location.coordinate.longitude, userLocation.location.coordinate.latitude);
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    
    if ([annotation isKindOfClass:[TCAnnotation class]]) {
        TCCalloutAnnotationView *calloutAnnotationView = [TCCalloutAnnotationView calloutViewWithMapView:mapView];
        [calloutAnnotationView setAnnotation:annotation];
        return calloutAnnotationView;
    } else {
        return nil;
    }
    
}
//
//#pragma mark 选中大头针时触发
////点击一般的大头针KCAnnotation时添加一个大头针作为所点大头针的弹出详情视图
//-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
//    TCAnnotation *annotation=view.annotation;
//    if ([view.annotation isKindOfClass:[TCAnnotation class]]) {
//        //点击一个大头针时移除其他弹出详情视图
//        //        [self removeCustomAnnotation];
//        //添加详情大头针，渲染此大头针视图时将此模型对象赋值给自定义大头针视图完成自动布局
//        TCCalloutAnnotation *annotation1=[[TCCalloutAnnotation alloc]init];
//        annotation1.icon=annotation.icon;
//        annotation1.detail=annotation.detail;
//        annotation1.rate=annotation.rate;
//        annotation1.coordinate=view.annotation.coordinate;
//        [mapView addAnnotation:annotation1];
//    }
//}
//
//#pragma mark 取消选中时触发
//-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
//    [self removeCustomAnnotation];
//}
//
//#pragma mark 移除所用自定义大头针
//-(void)removeCustomAnnotation{
//    [mMapView.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isKindOfClass:[TCCalloutAnnotation class]]) {
//            [mMapView removeAnnotation:obj];
//        }
//    }];
//}

@end
