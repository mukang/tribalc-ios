//
//  ViewController.m
//  individual
//
//  Created by 穆康 on 2016/10/18.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import "TCFunctions.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"\n%@\n%@\n%@\n%@\n%@\n%@\n%@", TCGetDeviceModel(), TCGetDeviceUUID(), TCGetAppIdentifier(), TCGetDeviceOSVersion(), TCGetAppVersion(), TCGetAppBuildVersion(), TCGetAppFullVersion());
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
