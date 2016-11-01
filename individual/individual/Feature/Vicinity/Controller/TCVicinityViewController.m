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

@end

@implementation TCVicinityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    CGSize size = CGSizeMake(50, 50);
    CGPoint center = CGPointMake(TCScreenWidth * 0.5, TCScreenHeight + 10);
    self.originCenter = center;
    
    UIButton *peopleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    peopleButton.backgroundColor = [UIColor redColor];
    peopleButton.size = size;
    peopleButton.center = center;
    peopleButton.layer.cornerRadius = 25;
    peopleButton.layer.masksToBounds = YES;
    [self.view addSubview:peopleButton];
    self.peopleButton = peopleButton;
    
    UIButton *diningButton = [UIButton buttonWithType:UIButtonTypeCustom];
    diningButton.backgroundColor = [UIColor blueColor];
    diningButton.size = size;
    diningButton.center = center;
    diningButton.layer.cornerRadius = 25;
    diningButton.layer.masksToBounds = YES;
    [self.view addSubview:diningButton];
    self.diningButton = diningButton;
    
    UIButton *entertainmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    entertainmentButton.backgroundColor = [UIColor yellowColor];
    entertainmentButton.size = size;
    entertainmentButton.center = center;
    entertainmentButton.layer.cornerRadius = 25;
    entertainmentButton.layer.masksToBounds = YES;
    [self.view addSubview:entertainmentButton];
    self.entertainmentButton = entertainmentButton;
    
    self.buttons = @[peopleButton, diningButton, entertainmentButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.backgroundView.alpha = 0.8;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGFloat angle;
    CGFloat radius = 150;
    CGPoint center;
    
    for (int i=0; i<self.buttons.count; i++) {
        UIButton *button = self.buttons[i];
        angle = 55 + 35 * (self.buttons.count - i - 1);
        center = [self calcCircleCoordinateWithCenter:self.originCenter angle:angle radius:radius];
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
//        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        animation.duration = 0.2;
        animation.springBounciness = 8;
//        animation.beginTime = CACurrentMediaTime() + i * 0.1;
        animation.toValue = [NSValue valueWithCGPoint:center];
        [button pop_addAnimation:animation forKey:[NSString stringWithFormat:@"TCButton%d", i]];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.backgroundView.alpha = 0.0;
    
    for (UIButton *button in self.buttons) {
        button.center = self.originCenter;
    }
}

- (CGPoint)calcCircleCoordinateWithCenter:(CGPoint)center angle:(CGFloat)angle radius:(CGFloat)radius {
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
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
