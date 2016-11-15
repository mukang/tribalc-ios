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
    CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(37.785834, -122.606417);
    TCAnnotation *annotation1 = [[TCAnnotation alloc] init];
    annotation1.title = @"title1";
    annotation1.subtitle = @"hahahahha";
    annotation1.coordinate = location1;
//    annotation1.image = [UIImage imageNamed:@"restaurantInfoLogo"];
//    annotation1.icon = [UIImage imageNamed:@"res_phone"];
//    annotation1.detail = @"dwdwadwadwa";
//    annotation1.rate = [UIImage imageNamed:@"res_phone-1"];
    [mMapView addAnnotation:annotation1];
    
}

#pragma mark - delegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"经度%f 纬度%f", userLocation.location.coordinate.longitude, userLocation.location.coordinate.latitude);
}
//#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象
//-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//    //由于当前位置的标注也是一个大头针，所以此时需要判断，此代理方法返回nil使用默认大头针视图
//    if ([annotation isKindOfClass:[TCAnnotation class]]) {
//        static NSString *key1=@"AnnotationKey1";
//        MKAnnotationView *annotationView=[mMapView dequeueReusableAnnotationViewWithIdentifier:key1];
//        //如果缓存池中不存在则新建
//        if (!annotationView) {
//            annotationView=[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:key1];
//            //            annotationView.canShowCallout=true;//允许交互点击
//            annotationView.calloutOffset=CGPointMake(0, 1);//定义详情视图偏移量
//            annotationView.leftCalloutAccessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_classify_cafe.png"]];//定义详情左侧视图
//        }
//        
//        //修改大头针视图
//        //重新设置此类大头针视图的大头针模型(因为有可能是从缓存池中取出来的，位置是放到缓存池时的位置)
//        annotationView.annotation=annotation;
//        annotationView.image=((TCAnnotation *)annotation).image;//设置大头针视图的图片
//        
//        return annotationView;
//    }else if([annotation isKindOfClass:[TCCalloutAnnotation class]]){
//        //对于作为弹出详情视图的自定义大头针视图无弹出交互功能（canShowCallout=false，这是默认值），在其中可以自由添加其他视图（因为它本身继承于UIView）
//        TCCalloutAnnotationView *calloutView=[TCCalloutAnnotationView calloutViewWithMapView:mapView];
//        calloutView.annotation=annotation;
//        return calloutView;
//    } else {
//        return nil;
//    }
//}
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
