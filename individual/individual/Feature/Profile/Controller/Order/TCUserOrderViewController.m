//
//  TCOrderViewController.m
//  individual
//
//  Created by WYH on 16/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUserOrderViewController.h"

@interface TCUserOrderViewController ()

@end

@implementation TCUserOrderViewController


- (instancetype)initWithMyOrderInfo:(NSArray *)array {
    self = [super init];
    if (self) {
        myOrderInfoArr = array;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
//    [self initTableView];
    
    

    
}


- (void)initTableView {
    orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 40.5 + 15, self.view.width, self.view.height- 64 - 60.5 - 15)];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    [self.view addSubview:orderTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initData {
    NSDictionary *dic1 = @{
                           @"orderId":@"1350948", @"type":@"wait", @"price":@499.05,
                           @"content":@[
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套", @"price":@488, @"count":@3,
                                     @"type":@[
                                             @{@"typeName":@"颜色分类", @"typeSize":@"蓝色"},
                                             @{@"typeName":@"口味", @"typeSize":@"S"}
                                             ]
                                     },
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套", @"price":@488, @"count":@3,
                                     @"type":@[
                                             @{@"typeName":@"颜色分类", @"typeSize":@"蓝色"},
                                             @{@"typeName":@"口味", @"typeSize":@"S"}
                                             ]
                                     }
                                   ]
                           };
    NSDictionary *dic2 = @{
                           @"orderId":@"1350948", @"type":@"wait", @"price":@499.05,
                           @"content":@[
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套", @"price":@488, @"count":@3,
                                     @"type":@[
                                             @{@"typeName":@"颜色分类", @"typeSize":@"蓝色"},
                                             @{@"typeName":@"口味", @"typeSize":@"S"}
                                             ]
                                     },
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套", @"price":@488, @"count":@3,
                                     @"type":@[
                                             @{@"typeName":@"颜色分类", @"typeSize":@"蓝色"},
                                             @{@"typeName":@"口味", @"typeSize":@"S"}
                                             ]
                                     }
                                   ]
                           };
    NSDictionary *dic3 = @{
                           @"orderId":@"1350948", @"type":@"wait", @"price":@499.05,
                           @"content":@[
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套",@"price":@488, @"count":@3,
                                     @"type":@[
                                             @{@"typeName":@"颜色分类", @"typeSize":@"蓝色"},
                                             @{@"typeName":@"口味", @"typeSize":@"S"}
                                             ]
                                     },
                                   @{@"image": @"", @"name":@"New look时尚花朵刺绣牛仔外套", @"price":@488, @"count":@3,
                                     @"type":@[
                                             @{@"typeName":@"颜色分类", @"typeSize":@"蓝色"},
                                             @{@"typeName":@"口味", @"typeSize":@"S"}
                                             ]
                                     }
                                   ]
                           };
    
    myOrderInfoArr = [NSArray arrayWithObjects:dic1, dic2, dic3, nil];
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
