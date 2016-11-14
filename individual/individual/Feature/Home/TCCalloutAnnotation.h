//
//  TCCalloutAnnotation.h
//  individual
//
//  Created by WYH on 16/11/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TCCalloutAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, strong) UIImage *rate;

@end
