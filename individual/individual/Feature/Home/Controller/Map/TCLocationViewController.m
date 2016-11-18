//
//  TCLocationViewController.m
//  individual
//
//  Created by WYH on 16/11/13.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCLocationViewController.h"

@interface TCLocationViewController () {
    UIImageView *userLocationView;
}

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
    
    userLocationView = [self createUserImageViewWithImageName:@"map_me"];
    [self.view addSubview:userLocationView];
    
    [self addAnnotation];
}

- (UIImageView *)createUserImageViewWithImageName:(NSString *)imgName {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    UIImageView *headImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    
    headImgView.frame = CGRectMake(3, 3, imageView.width - 6, imageView.width - 6);
    headImgView.layer.cornerRadius = headImgView.width / 2;
    headImgView.layer.masksToBounds = YES;
    
    [imageView addSubview:headImgView];
    return imageView;
}


- (void)addAnnotation {
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(37.785834, -122.405417);
    TCAnnotation *annotation1 = [[TCAnnotation alloc] init];
    annotation1.image = [UIImage imageNamed:@"美食"];
    annotation1.name = @"麻辣烫";
    annotation1.coordinate = location1;
    [mMapView addAnnotation:annotation1];
    
}

#pragma mark - delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"经度%f 纬度%f", userLocation.location.coordinate.longitude, userLocation.location.coordinate.latitude);
    [userLocationView setOrigin:CGPointMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    
    if ([annotation isKindOfClass:[TCAnnotation class]]) {
        TCCalloutAnnotationView *calloutAnnotationView = [TCCalloutAnnotationView calloutViewWithMapView:mapView];
        calloutAnnotationView.image = ((TCAnnotation *)annotation).image;
        [calloutAnnotationView setAnnotation:annotation];
        return calloutAnnotationView;
    }else {
        return nil;
    }
    
}

#pragma mark 选中大头针时触发
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    

}

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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
