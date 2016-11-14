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
    
}

#pragma mark - delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"经度%f 纬度%f", userLocation.location.coordinate.longitude, userLocation.location.coordinate.latitude);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
