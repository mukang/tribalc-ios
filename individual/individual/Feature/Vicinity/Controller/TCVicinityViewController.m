//
//  TCVicinityViewController.m
//  individual
//
//  Created by 穆康 on 2016/10/31.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCVicinityViewController.h"
#import <POP.h>

@interface TCVicinityViewController ()

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) UIButton *peopleButton;
@property (weak, nonatomic) UIButton *diningButton;
@property (weak, nonatomic) UIButton *entertainmentButton;
@property (copy, nonatomic) NSArray *buttons;
@property (nonatomic) CGPoint originCenter;
@property (nonatomic) CGSize originSize;

@end

@implementation TCVicinityViewController {
    __weak TCVicinityViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    weakSelf = self;
    self.navigationController.navigationBarHidden = YES;
    
    CGSize size = CGSizeMake(20, 20);
    self.originSize = size;
    CGPoint center = CGPointMake(TCScreenWidth * 0.5, TCScreenHeight - 20);
    self.originCenter = center;
    
    UIButton *peopleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    peopleButton.backgroundColor = [UIColor redColor];
    peopleButton.size = size;
    peopleButton.center = center;
    peopleButton.layer.cornerRadius = size.width * 0.5;
    peopleButton.layer.masksToBounds = YES;
    peopleButton.alpha = 0;
    [self.view addSubview:peopleButton];
    self.peopleButton = peopleButton;
    
    UIButton *diningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    diningButton.backgroundColor = [UIColor blueColor];
    diningButton.size = size;
    diningButton.center = center;
    diningButton.layer.cornerRadius = size.width * 0.5;
    diningButton.layer.masksToBounds = YES;
    diningButton.alpha = 0;
    [self.view addSubview:diningButton];
    self.diningButton = diningButton;
    
    UIButton *entertainmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    entertainmentButton.backgroundColor = [UIColor yellowColor];
    entertainmentButton.size = size;
    entertainmentButton.center = center;
    entertainmentButton.layer.cornerRadius = size.width * 0.5;
    entertainmentButton.layer.masksToBounds = YES;
    entertainmentButton.alpha = 0;
    [self.view addSubview:entertainmentButton];
    self.entertainmentButton = entertainmentButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self startAnimating];
//    [UIView animateWithDuration:0.1 animations:^{
//        self.backgroundView.alpha = 0.8;
//    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    [self startAnimating];
    
//    CGFloat angle;
//    CGFloat radius = 150;
//    CGPoint center;
//    
//    for (int i=0; i<self.buttons.count; i++) {
//        UIButton *button = self.buttons[i];
//        angle = 55 + 35 * (self.buttons.count - i - 1);
//        center = [self calcCircleCoordinateWithCenter:self.originCenter angle:angle radius:radius];
//        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
////        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
////        animation.duration = 0.2;
//        animation.springBounciness = 8;
////        animation.beginTime = CACurrentMediaTime() + i * 0.1;
//        animation.toValue = [NSValue valueWithCGPoint:center];
//        [button pop_addAnimation:animation forKey:[NSString stringWithFormat:@"TCButton%d", i]];
//    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    self.backgroundView.alpha = 0.6;
//    
//    for (UIButton *button in self.buttons) {
//        button.center = self.originCenter;
//    }
    
}

- (void)startAnimating {
    
    CGPoint center;
    CGSize size;
    CGFloat radius = 120;
    NSTimeInterval beginTime = CACurrentMediaTime() + 0.3;
    NSTimeInterval animationDuration = 0.2;
    
    // diningButton
    POPSpringAnimation *diningCenterAnimation = [POPSpringAnimation animation];
    diningCenterAnimation.springBounciness = 15;
    center = [self calcCircleCoordinateWithCenter:self.originCenter angle:90 radius:radius];
    diningCenterAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewCenter];
    diningCenterAnimation.toValue = [NSValue valueWithCGPoint:center];
    [self.diningButton pop_addAnimation:diningCenterAnimation forKey:@"diningCenterAnimation"];
    
    POPSpringAnimation *diningSizeAnimation = [POPSpringAnimation animation];
    diningSizeAnimation.springBounciness = 12;
    size = CGSizeMake(50, 50);
    diningSizeAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewSize];
    diningSizeAnimation.toValue = [NSValue valueWithCGSize:size];
    [self.diningButton pop_addAnimation:diningSizeAnimation forKey:@"diningSizeAnimation"];
    
    POPSpringAnimation *diningCornerAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    diningCornerAnimation.springBounciness = 12;
    diningCornerAnimation.toValue = @(size.width * 0.5);
    [self.diningButton.layer pop_addAnimation:diningCornerAnimation forKey:@"diningCornerAnimation"];
    
    POPBasicAnimation *diningAlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    diningAlphaAnimation.duration = animationDuration;
    diningAlphaAnimation.toValue = @(1.0);
    [self.diningButton pop_addAnimation:diningAlphaAnimation forKey:@"diningAlphaAnimation"];
    
    // pepoleButton
    POPBasicAnimation *peopleCenterAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    center = [self calcCircleCoordinateWithCenter:self.originCenter angle:130 radius:radius];
    peopleCenterAnimation.beginTime = beginTime;
    peopleCenterAnimation.duration = animationDuration;
    peopleCenterAnimation.toValue = [NSValue valueWithCGPoint:center];
    [self.peopleButton pop_addAnimation:peopleCenterAnimation forKey:@"peopleCenterAnimation"];
    
    POPBasicAnimation *peopleSizeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
    peopleSizeAnimation.beginTime = beginTime;
    peopleSizeAnimation.duration = animationDuration;
    size = CGSizeMake(40, 40);
    peopleSizeAnimation.toValue = [NSValue valueWithCGSize:size];
    [self.peopleButton pop_addAnimation:peopleSizeAnimation forKey:@"peopleSizeAnimation"];
    
    POPBasicAnimation *peopleCornerAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    peopleCornerAnimation.beginTime = beginTime;
    peopleCornerAnimation.duration = animationDuration;
    peopleCornerAnimation.toValue = @(size.width * 0.5);
    [self.peopleButton.layer pop_addAnimation:peopleCornerAnimation forKey:@"peopleCornerAnimation"];
    
    POPBasicAnimation *peopleAlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    peopleAlphaAnimation.beginTime = beginTime;
    peopleAlphaAnimation.duration = animationDuration;
    peopleAlphaAnimation.toValue = @(1.0);
    [self.peopleButton pop_addAnimation:peopleAlphaAnimation forKey:@"peopleAlphaAnimation"];
    
    // entertainmentButton
    POPBasicAnimation *entertainmentCenterAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    center = [self calcCircleCoordinateWithCenter:self.originCenter angle:50 radius:radius];
    entertainmentCenterAnimation.beginTime = beginTime;
    entertainmentCenterAnimation.duration = animationDuration;
    entertainmentCenterAnimation.toValue = [NSValue valueWithCGPoint:center];
    [self.entertainmentButton pop_addAnimation:entertainmentCenterAnimation forKey:@"entertainmentCenterAnimation"];
    
    POPBasicAnimation *entertainmentSizeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
    entertainmentSizeAnimation.beginTime = beginTime;
    entertainmentSizeAnimation.duration = animationDuration;
    size = CGSizeMake(40, 40);
    entertainmentSizeAnimation.toValue = [NSValue valueWithCGSize:size];
    [self.entertainmentButton pop_addAnimation:entertainmentSizeAnimation forKey:@"entertainmentSizeAnimation"];
    
    POPBasicAnimation *entertainmentCornerAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    entertainmentCornerAnimation.beginTime = beginTime;
    entertainmentCornerAnimation.duration = animationDuration;
    entertainmentCornerAnimation.toValue = @(size.width * 0.5);
    [self.entertainmentButton.layer pop_addAnimation:entertainmentCornerAnimation forKey:@"entertainmentCornerAnimation"];
    
    POPBasicAnimation *entertainmentAlphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    entertainmentAlphaAnimation.beginTime = beginTime;
    entertainmentAlphaAnimation.duration = animationDuration;
    entertainmentAlphaAnimation.toValue = @(1.0);
    [self.entertainmentButton pop_addAnimation:entertainmentAlphaAnimation forKey:@"entertainmentAlphaAnimation"];
}


- (CGPoint)calcCircleCoordinateWithCenter:(CGPoint)center angle:(CGFloat)angle radius:(CGFloat)radius {
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
}

- (IBAction)dismiss:(UIButton *)sender {
    
    NSTimeInterval animationDuration = 0.2;
    NSTimeInterval beginTime = CACurrentMediaTime() + animationDuration;
    
    // pepoleButton and entertainmentButton
    POPBasicAnimation *centerAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    centerAnimation.duration = animationDuration;
    centerAnimation.toValue = [NSValue valueWithCGPoint:self.originCenter];
    [self.peopleButton pop_addAnimation:centerAnimation forKey:@"peopleCenterDismissAnimation"];
    [self.entertainmentButton pop_addAnimation:centerAnimation forKey:@"entertainmentCenterDismissAnimation"];
    
    POPBasicAnimation *sizeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
    sizeAnimation.duration = animationDuration;
    sizeAnimation.toValue = [NSValue valueWithCGSize:self.originSize];
    [self.peopleButton pop_addAnimation:sizeAnimation forKey:@"peopleSizeDismissAnimation"];
    [self.entertainmentButton pop_addAnimation:sizeAnimation forKey:@"entertainmentSizeDismissAnimation"];
    
    POPBasicAnimation *cornerAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    cornerAnimation.duration = animationDuration;
    cornerAnimation.toValue = @(self.originSize.width * 0.5);
    [self.peopleButton.layer pop_addAnimation:cornerAnimation forKey:@"peopleCornerDismissAnimation"];
    [self.entertainmentButton.layer pop_addAnimation:cornerAnimation forKey:@"entertainmentCornerDismissAnimation"];
    
    POPBasicAnimation *alphaAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    alphaAnimation.duration = 0.1;
    alphaAnimation.toValue = @(0.0);
    [self.peopleButton pop_addAnimation:alphaAnimation forKey:@"peopleAlphaDismissAnimation"];
    [self.entertainmentButton pop_addAnimation:alphaAnimation forKey:@"entertainmentAlphaDismissAnimation"];
    
    // diningButton
    POPBasicAnimation *diningCenterDismissAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    diningCenterDismissAnimation.beginTime = beginTime;
    diningCenterDismissAnimation.duration = animationDuration;
    diningCenterDismissAnimation.toValue = [NSValue valueWithCGPoint:self.originCenter];
    [self.diningButton pop_addAnimation:diningCenterDismissAnimation forKey:@"diningCenterDismissAnimation"];
    
    POPBasicAnimation *diningSizeDismissAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
    diningSizeDismissAnimation.beginTime = beginTime;
    diningSizeDismissAnimation.duration = animationDuration;
    diningSizeDismissAnimation.toValue = [NSValue valueWithCGSize:self.originSize];
    [self.diningButton pop_addAnimation:diningSizeDismissAnimation forKey:@"diningSizeDismissAnimation"];
    
    POPBasicAnimation *diningCornerDismissAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerCornerRadius];
    diningCornerDismissAnimation.beginTime = beginTime;
    diningCornerDismissAnimation.duration = animationDuration;
    diningCornerDismissAnimation.toValue = @(self.originSize.width * 0.5);
    [self.diningButton.layer pop_addAnimation:diningCornerDismissAnimation forKey:@"diningCornerDismissAnimation"];
    
    POPBasicAnimation *diningAlphaDismissAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    diningAlphaDismissAnimation.beginTime = beginTime;
    diningAlphaDismissAnimation.duration = 0.1;
    diningAlphaDismissAnimation.toValue = @(0.0);
    [self.diningButton pop_addAnimation:diningAlphaDismissAnimation forKey:@"diningAlphaDismissAnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    });
    
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
