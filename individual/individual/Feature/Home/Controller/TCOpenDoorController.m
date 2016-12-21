//
//  TCOpenDoorController.m
//  individual
//
//  Created by 王帅锋 on 16/12/20.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCOpenDoorController.h"
#import "Masonry.h"
#import "TCBuluoApi.h"

@interface TCOpenDoorController ()
@property (nonatomic, strong) UIImageView *imageV1;

@property (nonatomic, strong) UIButton *openBtn;

@property (nonatomic, strong) CAShapeLayer *pulseLayer;

@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;

@property (nonatomic, strong) CABasicAnimation *opacityAnima;

@property (nonatomic, strong) CABasicAnimation *scaleAnima;

@property (nonatomic, strong) CAAnimationGroup *groupAnima;
@end

@implementation TCOpenDoorController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];

    [self setUpUI];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(go)];
//    [self.view addGestureRecognizer:tap];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [self updateUI];
//}

//- (void)go {
//    [_pulseLayer removeAllAnimations];
//}

- (void)viewDidAppear:(BOOL)animated {
    [self updateUI];
}

- (void)updateUI {
    UIImage *image = [self imageFromView:[UIApplication sharedApplication].keyWindow atFrame:self.view.bounds];
    
    _imageV1.image = [TCOpenDoorController coreBlurImage:image withBlurNumber:0.5];
}

- (void)setUpUI {
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"openDoorBg"]];
    [self.view addSubview:imageV];
//    imageV.userInteractionEnabled = YES;
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    _imageV1 = [[UIImageView alloc] init];
//    _imageV1.userInteractionEnabled = YES;
    [self.view addSubview:_imageV1];
    [_imageV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(imageV);
    }];
    
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [openBtn setBackgroundColor:[UIColor whiteColor]];
    [openBtn setTitle:@"开锁" forState:UIControlStateNormal];
    [openBtn setTitleColor:TCRGBColor(88, 191, 200) forState:UIControlStateNormal];
    openBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    CGFloat scale = self.view.bounds.size.width/375.0;
    [self.view addSubview:openBtn];
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-115*scale);
        make.width.height.equalTo(@94);
//        make.center.equalTo(self.view);
    }];
    openBtn.layer.cornerRadius = 47.0;
    openBtn.layer.borderWidth = 5.0;
    openBtn.layer.borderColor = [UIColor colorWithRed:124/255.0 green:211/255.0 blue:211/255.0 alpha:0.8].CGColor;
//    openBtn.clipsToBounds = YES;
    _openBtn = openBtn;
    [openBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20*scale);
        make.width.equalTo(@50);
        make.height.equalTo(@30);
    }];
    [backBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click {
    if (_pulseLayer == nil) {
        CAShapeLayer *pulseLayer = [CAShapeLayer layer];
        pulseLayer.frame = _openBtn.layer.bounds;
        pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds].CGPath;
        pulseLayer.fillColor = [UIColor clearColor].CGColor;//填充色
        pulseLayer.strokeColor = [UIColor whiteColor].CGColor;
        pulseLayer.lineWidth = 0.5;
        pulseLayer.opacity = 0; // 层的透明度
        _pulseLayer = pulseLayer;
    }
    
    
    // 图层复制类
    if (_replicatorLayer == nil) {
        CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
        replicatorLayer.frame = _openBtn.layer.bounds;
        replicatorLayer.instanceCount = 8;//创建副本的数量,包括源对象。
        replicatorLayer.instanceDelay = 0.5;//复制副本之间的延迟
        [replicatorLayer addSublayer:_pulseLayer];
        [_openBtn.layer addSublayer:replicatorLayer];
        _replicatorLayer = replicatorLayer;
    }
    
    if (_opacityAnima == nil) {
        CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnima.fromValue = @(0.5);
        opacityAnima.toValue = @(0.0);
        _opacityAnima = opacityAnima;
    }
    
    if (_scaleAnima == nil) {
        CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
        scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 5, 5, 0.0)];
        _scaleAnima = scaleAnima;
    }
    
    
    if (_groupAnima == nil) {
        CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
        groupAnima.animations = @[_opacityAnima, _scaleAnima];
        groupAnima.duration = 4.0;
        groupAnima.autoreverses = NO;
        groupAnima.repeatCount = HUGE;
        _groupAnima = groupAnima;
    }
    
    [_pulseLayer addAnimation:_groupAnima forKey:@"groupAnimation"];
    
    [self openDoor];
}


- (void)openDoor {
    [[TCBuluoApi api] openDoorWithResult:^(BOOL isSuccessed, NSError *err) {
        if (isSuccessed) {
            
            [_openBtn setBackgroundImage:[UIImage imageNamed:@"opened"] forState:UIControlStateNormal];
        }else {
            [_openBtn setTitle:@"开锁失败" forState:UIControlStateNormal];
            _openBtn.titleLabel.font = [UIFont systemFontOfSize:18];

        }
        [_pulseLayer removeAllAnimations];
    }];
}


+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
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

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
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
