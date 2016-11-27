//
//  TCUserOrderDetailViewController.m
//  individual
//
//  Created by WYH on 16/11/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUserOrderDetailViewController.h"

@interface TCUserOrderDetailViewController () {
    NSDictionary *orderDetail;
    UITableView *orderDetailTableView;
}

@end

@implementation TCUserOrderDetailViewController

- (instancetype)initWithData {
    self = [super init];
    if (self) {
        [self forgeData];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    
    [self forgeData];
    
    NSArray *addressArr = [orderDetail[@"address"] componentsSeparatedByString:@"|"];
    UIView *userAddressView = [[TCOrderAddressView alloc] initWithOrigin:CGPointMake(0, 0) WithName:addressArr[0] AndPhone:addressArr[1] AndAddress:addressArr[2]];
    [self.view addSubview:userAddressView];
    
    NSArray *orderList = orderDetail[@"itemList"];
    orderDetailTableView = [self getOrderDetailTableViewWithFrame:CGRectMake(0, userAddressView.y + userAddressView.height, self.view.width, 40 * 3 + 56 + 41 + orderList.count * 96.5)];
    [self.view addSubview:orderDetailTableView];

}

- (void)initNavigationBar {
    UIButton *backbtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:@"back"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    [backbtn addTarget:self action:@selector(touchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.titleView = [TCGetNavigationItem getTitleItemWithText:@"订单详情"];
}

- (UITableView *)getOrderDetailTableViewWithFrame:(CGRect)frame {
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    return tableView;
}

- (UIView *)getOrderInfoViewWithTitle:(NSString *)title AndText:(NSString *)text {
    UIView *orderInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(20, 0, 55, orderInfoView.height) AndFontSize:12 AndTitle:title AndTextColor:[UIColor blackColor]];
    UILabel *textLab = [TCComponent createLabelWithFrame:CGRectMake(titleLab.x + titleLab.width, 0, self.view.width - titleLab.x - titleLab.width - 20, orderInfoView.height) AndFontSize:12 AndTitle:text AndTextColor:[UIColor blackColor]];
    textLab.textAlignment = NSTextAlignmentRight;
    
    [orderInfoView addSubview:titleLab];
    [orderInfoView addSubview:textLab];
    
    return orderInfoView;
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *orderList = orderDetail[@"itemList"];
    return orderList.count + 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 41;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *orderList = orderDetail[@"itemList"];
    if (indexPath.row >= orderList.count) {
        return 40;
    }
    else {
        return 96.5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 41)];
    NSDictionary *storeDic = orderDetail[@"store"];
    UIImageView *storeLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, headerView.height / 2 - 17 / 2, 17, 17)];
    NSURL *logoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, storeDic[@"logo"]]];
    [storeLogoImgView sd_setImageWithURL:logoUrl placeholderImage:[UIImage imageNamed:@"map_bar"]];
    
    UILabel *storeLabel = [TCComponent createLabelWithFrame:CGRectMake(storeLogoImgView.x + storeLogoImgView.width + 5, 0, self.view.width - storeLogoImgView.x - storeLogoImgView.width - 5, headerView.height) AndFontSize:12 AndTitle:storeDic[@"name"] AndTextColor:[UIColor blackColor]];
    storeLabel.font = [UIFont fontWithName:BOLD_FONT size:12];
    
    [headerView addSubview:storeLogoImgView];
    [headerView addSubview:storeLabel];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 56)];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 7.5, self.view.width - 40, 31.5)];
    backView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    UITextField *supplementField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, backView.width - 7, backView.height)];
    supplementField.placeholder = @"订单补充说明:";
    supplementField.font = [UIFont systemFontOfSize:11];
    supplementField.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    
    [backView addSubview:supplementField];
    
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, self.view.width - 40, 0.5)];
    [footerView addSubview:topLineView];
    
    [footerView addSubview:backView];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *orderList = orderDetail[@"itemList"];
    if (indexPath.row >= orderList.count) {
        return [self getOrderInfoTableViewCellWithIndexPath:indexPath];
    } else {
        NSString *identifier = [NSString stringWithFormat:@"%li", (long)indexPath.row];
        TCUserOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TCUserOrderTableViewCell alloc] initOrderDetailCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSArray *orderList = orderDetail[@"itemList"];
        NSDictionary *orderContentDic = orderList[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.leftImgView.image = [UIImage imageNamed:@"good_placeholder"];
        [cell setTitleLabWithText:orderContentDic[@"title"]];
        [cell setBoldPriceLabel:39.00];
        [cell setSelectedStandardWithDic:orderContentDic[@"standard"]];
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (UITableViewCell *)getOrderInfoTableViewCellWithIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%li", (long)indexPath.row];
    UITableViewCell *cell = [orderDetailTableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *orderInfoView;
    NSArray *orderList = orderDetail[@"itemList"];
    if (indexPath.row == orderList.count) {
        orderInfoView = [self getOrderInfoViewWithTitle:@"配送方式:" AndText:@"全国包邮"];
    } else if (indexPath.row == orderList.count + 1) {
        orderInfoView = [self getOrderInfoViewWithTitle:@"快递运费:" AndText:@"￥0.00"];
    } else {
        orderInfoView = [self getOrderInfoViewWithTitle:@"价格合计:" AndText:@"￥309.00"];
    }
    [cell.contentView addSubview:orderInfoView];
    
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, self.view.width - 40, 0.5)];
    UIView *downLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 40 - 0.5, self.view.width - 40, 0.5)];
    [cell.contentView addSubview:topLineView];
    [cell.contentView addSubview:downLineView];
    
    return cell;
}

#pragma mark - click
- (void)touchBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)forgeData {
    orderDetail = @{
                    @"id":@"69aec39b8d6a4b5693f39be1",
                    @"orderNum":@"2016112101000000",
                    @"ownerId":@"56dfg39b8d6a4b5693f39be2",
                    @"address":@"王丹|18633601521|北京朝阳区北苑茉莉园",
                    @"expressType":@"NOT_PAYPOSTAGE",
                    @"expressFee":@7.0,
                    @"totalFee":@106.5,
                    @"note":@"采用圆通快递",
                    @"payChannel":@"AliPay",
                    @"status":@"NO_SETTLE",
                    @"createTime":@1478513563773,
                    @"settleTime":@1478683563998,
                    @"deliveryTime":@1478683563998,
                    @"receivedTime":@1478713563773,
                    @"store":@{ @"name":@"五欢喜的衣橱", @"logo":@"" },
                    @"itemList":@[@{
                                      @"thumbnail":@"",
                                      @"title":@"长大一：秋冬加厚外套甜美手机锁哈哈哈哈哈哈哈哈哈哈",
                                      @"standard":@{
                                              @"primary":@{
                                                      @"label":@"颜色", @"types":@"浅蓝"
                                                      },
                                              @"secondary":@{
                                                      @"label":@"尺码", @"types":@"M"
                                                      }
                                              },
                                      @"price":@309,
                                      @"count":@3
                                    },
                                    @{
                                      @"thumbnail":@"",
                                      @"title":@"长大一：秋冬加厚外套甜美手机锁哈哈哈哈哈哈哈哈哈哈",
                                      @"standard":@{
                                              @"primary":@{
                                                      @"label":@"颜色", @"types":@"浅蓝"
                                                      },
                                              @"secondary":@{
                                                      @"label":@"尺码", @"types":@"M"
                                                      }
                                              },
                                      @"price":@309,
                                      @"count":@3
                                      }
                                  ]
                    };
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
