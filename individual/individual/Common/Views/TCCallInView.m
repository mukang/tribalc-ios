//
//  TCCallInView.m
//  individual
//
//  Created by 王帅锋 on 17/1/13.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCallInView.h"
#import "TCSipAPI.h"
#import "TCCallInViewController.h"

@interface TCCallInView ()

@property (nonatomic,weak) UIViewController *myConreoller;

@property (nonatomic, copy) MyBlock block;

@end

@implementation TCCallInView

- (instancetype)initWithController:(UIViewController *)controller endBlock:(MyBlock)b{
    
    if (self = [super init]) {
        if (_myConreoller != controller) {
            _myConreoller = controller;
            _block = [b copy];
            UIImage *img = [self imageFromView:controller.view atFrame:controller.view.bounds];
            UIImage *i = [self coreBlurImage:img withBlurNumber:0.9];
            self.image = i;
        }
    }
    
    return self;
}

- (void)show {
    if (!_myConreoller) return;
    
    if (![[TCSipAPI api] isLogin]) {
        [[TCSipAPI api] login];
    }
    
    UIView *superView;
    superView = _myConreoller.view;
    self.frame = [UIScreen mainScreen].bounds;
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
    
    TCCallInViewController *open = [[TCCallInViewController alloc] init];
//    open.modalPresentationStyle = UIModalPresentationOverCurrentContext | UIModalPresentationFullScreen;
    open.myBlock = ^{
        if (self) {
            [self removeFromSuperview];
            if (self.block) {
                self.block();
            }
        }
    };
    
    UINavigationController *navgition = [[UINavigationController alloc] initWithRootViewController:open];
    navgition.modalPresentationStyle = UIModalPresentationOverCurrentContext | UIModalPresentationFullScreen;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navgition animated:YES completion:^{
            navgition.view.backgroundColor = [UIColor clearColor];
        }];
        
    });
    
    
}


- (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

- (UIImage *)imageFromView: (UIView *) theView   atFrame:(CGRect)r
{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    UIRectClip(r);
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  theImage;//[self getImageAreaFromImage:theImage atFrame:r];
}

- (void)dealloc {
    TCLog(@"TCCallInView---dealloc");
}

@end
