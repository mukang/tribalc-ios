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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self initData];
    
    [self initTableView];
    
    
}


- (void)initTableView {
    orderTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40.5, self.view.width, self.view.height- 40.5) style:UITableViewStyleGrouped];
    orderTableView.delegate = self;
    orderTableView.dataSource = self;
    orderTableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    orderTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    orderTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    [self.view addSubview:orderTableView];
}

- (UIView *)getTableViewFooterViewWithTotalprice:(NSString *)totalPrice {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 51)];
    UILabel *totalLab = [self getOrderTotalPriceLabelWithPrice:totalPrice];
    [view addSubview:totalLab];
    
    UILabel *totalMarkLab = [TCComponent createLabelWithFrame:CGRectMake(self.view.width - totalLab.width - 47, 2, 30, view.height - 3) AndFontSize:12 AndTitle:@"总计:" AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    [view addSubview:totalMarkLab];
    
    return view;
}

- (UILabel *)getOrderTotalPriceLabelWithPrice:(NSString *)totalPrice  {
    UILabel *totalLab = [TCComponent createLabelWithText:[NSString stringWithFormat:@"￥%@", totalPrice] AndFontSize:18];
    totalLab.font = [UIFont fontWithName:BOLD_FONT size:18];
    totalLab.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    [totalLab sizeToFit];
    totalLab.frame = CGRectMake(self.view.width - 20 - totalLab.width, 0, totalLab.width, 51);
    
    return totalLab;
}

- (UIView *)getTableViewHeightViewWithOrderId:(NSString *)orderIdStr AndStatus:(NSString *)statusStr{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40.5 + 15)];
    UIView *orderInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, self.view.width, view.frame.size.height - 15)];
    orderInfoView.backgroundColor = [UIColor whiteColor];
    UILabel *orderIdLab = [TCComponent createLabelWithFrame:CGRectMake(20, 0, self.view.width - 79, orderInfoView.height) AndFontSize:14 AndTitle:[NSString stringWithFormat:@"订单号:%@", orderIdStr] AndTextColor:[UIColor blackColor]];
    [orderInfoView addSubview:orderIdLab];
    
    UIView *statusView = [self getOrderStatusViewWithStatus:statusStr];
    [orderInfoView addSubview:statusView];
    
    [view addSubview:orderInfoView];
    
    return view;
}

- (UIView *)getOrderStatusViewWithStatus:(NSString *)statusStr {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.width - 79, 0, 79, 40.5)];
    if ([statusStr isEqualToString:@"已完成"]) {
        UIImage *completeImg = [UIImage imageNamed:@"order_complete"];
        UIImageView *statusImgView = [[UIImageView alloc] initWithImage:completeImg];
        statusImgView.frame = CGRectMake((view.width - completeImg.size.width) / 2, (view.height - completeImg.size.height) / 2, completeImg.size.width, completeImg.size.height);
        [view addSubview:statusImgView];
    } else {
        UILabel *statusLabel = [TCComponent createLabelWithFrame:CGRectMake(0, 0, view.width, view.height) AndFontSize:14 AndTitle:statusStr AndTextColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1]];
        [view addSubview:statusLabel];
    }
    
    return view;
}

#pragma mark - UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 77;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.5 + 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 51;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *heightView = [self getTableViewHeightViewWithOrderId:@"2312312" AndStatus:@"已完成"];
    heightView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    return heightView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [self getTableViewFooterViewWithTotalprice:@"33212"];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *orderContentArr = myOrderInfoArr[section][@"content"];
    return orderContentArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return myOrderInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%li,%li", (long)indexPath.section, (long)indexPath.row];
    TCUserOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TCUserOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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



@end
