//
//  TCPlaceOrderViewController.m
//  individual
//
//  Created by WYH on 16/12/11.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPlaceOrderViewController.h"
#import "TCBuluoApi.h"
#import "TCGetNavigationItem.h"
#import "TCOrderAddressView.h"
#import "TCClientConfig.h"
#import "TCUserOrderTableViewCell.h"
#import "TCPayMethodView.h"
#import "TCImageURLSynthesizer.h"

@interface TCPlaceOrderViewController () {
    NSMutableArray *orderDetailList;
}

@end

@implementation TCPlaceOrderViewController

- (instancetype)initWithListShoppingCartArr:(NSArray *)listShoppingCartArr {
    self = [super init];
    if (self) {
        orderDetailList = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < listShoppingCartArr.count; i++) {
            TCListShoppingCart *listShoppingCart = listShoppingCartArr[i];
            [orderDetailList addObject:[self getOrderBaseInfoWithListShoppingCart:listShoppingCart]];
        }
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    
    UIScrollView *scrollView = [self getScrollViewWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 49)];
    
    NSArray *addressArr = [self getDefaultAddressArr];
    UIView *userAddressView = [[TCOrderAddressView alloc] initWithOrigin:CGPointMake(0, 0) WithName:addressArr[0] AndPhone:addressArr[1] AndAddress:addressArr[2]];
    [scrollView addSubview:userAddressView];
    
    UITableView *orderDetailTableView = [self getOrderDetailTableViewWithFrame:CGRectMake(0, userAddressView.y + userAddressView.height, self.view.width, [self getTableViewHeight])];
    [scrollView addSubview:orderDetailTableView];
 
    TCPayMethodView *payMethodView = [[TCPayMethodView alloc] initWithFrame:CGRectMake(0, orderDetailTableView.y + orderDetailTableView.height + 4, TCScreenWidth, 170)];
    [scrollView addSubview:payMethodView];
    
    
    scrollView.contentSize = CGSizeMake(self.view.width, payMethodView.y + payMethodView.height);
 
    UIView *bottomView = [self getNotSettleBottomView];
    [self.view addSubview:bottomView];

}

- (NSArray *)getDefaultAddressArr {
    TCUserSession *userSession = [[TCBuluoApi api] currentUserSession];
    TCUserShippingAddress *shippingAddress = userSession.userSensitiveInfo.shippingAddress;
    NSArray *addressInfo = @[ shippingAddress.name, shippingAddress.phone, [NSString stringWithFormat:@"%@%@%@%@", shippingAddress.province, shippingAddress.city, shippingAddress.district, shippingAddress.address] ];
    return addressInfo;
}

- (CGFloat)getTableViewHeight {
    CGFloat height;
    for(int i = 0; i < orderDetailList.count; i++) {
        TCOrder *order = orderDetailList[i];
        height += 40 * 3 + 56 + 41 + order.itemList.count * 96.5 + 4;
    }
    
    return height;
}


- (void)initNavigationBar {
    UIButton *backbtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:@"back"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    [backbtn addTarget:self action:@selector(touchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.titleView = [TCGetNavigationItem getTitleItemWithText:@"确认下单"];
}



- (UIView *)getNotSettleBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - 49, self.view.width, 49)];
    
    UIButton *payBtn = [TCComponent createButtonWithFrame:CGRectMake(bottomView.width / 2, 0, bottomView.width / 2, bottomView.height) AndTitle:@"去付款" AndFontSize:16 AndBackColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] AndTextColor:[UIColor whiteColor]];
    [payBtn addTarget:self action:@selector(touchOrderPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancelBtn = [TCComponent createButtonWithFrame:CGRectMake(0, 0, bottomView.width / 2, bottomView.height) AndTitle:@"取消订单" AndFontSize:16 AndBackColor:[UIColor whiteColor] AndTextColor:[UIColor blackColor]];
    [cancelBtn addTarget:self action:@selector(touchOrderCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelBtn];
    [bottomView addSubview:payBtn];
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, bottomView.width, 0.5)];
    [bottomView addSubview:lineView];
    
    return bottomView;
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



- (UIScrollView *)getScrollViewWithFrame:(CGRect)frame {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.view addSubview:scrollView];
    return scrollView;
}



- (TCOrder *)getOrderBaseInfoWithListShoppingCart:(TCListShoppingCart *)listShoppingCart {
    TCOrder *order = [[TCOrder alloc] init];
    order.itemList = listShoppingCart.goodsList;
    
    TCUserSession *userSession = [[TCBuluoApi api] currentUserSession];
    TCUserShippingAddress *shippingAddress = userSession.userSensitiveInfo.shippingAddress;
    order.ownerId = userSession.userInfo.ID;
    order.address = [NSString stringWithFormat:@"%@|%@|%@%@%@%@", shippingAddress.name, shippingAddress.phone, shippingAddress.province, shippingAddress.city, shippingAddress.district, shippingAddress.address];
    order.addressId = userSession.userSensitiveInfo.addressID;
    order.expressType = @"NOT_PAYPOSTAGE";
    order.expressFee = 7.0;
    order.totalFee = [self getConfirmOrderViewTotalPriceWithItemList:order];
    
    
    order.store = listShoppingCart.store;
    
    return order;
}

- (CGFloat)getConfirmOrderViewTotalPriceWithItemList:(TCOrder *)orderDetail {
    NSArray *itemList = orderDetail.itemList;
    CGFloat totalPrice = 0;
    for (int i = 0; i < itemList.count; i++) {
        TCOrderItem *orderItem = itemList[i];
        totalPrice += orderItem.amount * orderItem.goods.salePrice;
    }
    
    return  totalPrice;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return orderDetailList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TCOrder *order = orderDetailList[section];
    return order.itemList.count + 3;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 41;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 56;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCOrder *order = orderDetailList[indexPath.section];
    NSArray *orderList = order.itemList;
    if (indexPath.row >= orderList.count) {
        return 40;
    }
    else {
        return 96.5;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 41)];
    TCOrder *orderDetail = orderDetailList[section];
    TCMarkStore *markStore = orderDetail.store;
    UIImageView *storeLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, headerView.height / 2 - 17 / 2, 17, 17)];
    NSURL *logoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, markStore.logo]];
    [storeLogoImgView sd_setImageWithURL:logoUrl placeholderImage:[UIImage imageNamed:@"map_bar"]];
    
    UILabel *storeLabel = [TCComponent createLabelWithFrame:CGRectMake(storeLogoImgView.x + storeLogoImgView.width + 5, 0, self.view.width - storeLogoImgView.x - storeLogoImgView.width - 5, headerView.height) AndFontSize:12 AndTitle:markStore.name AndTextColor:[UIColor blackColor]];
    storeLabel.font = [UIFont fontWithName:BOLD_FONT size:12];
    
    [headerView addSubview:storeLogoImgView];
    [headerView addSubview:storeLabel];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(20, 7.5, self.view.width - 40, 31.5)];
    backView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    TCOrder *orderDetail = orderDetailList[section];
    
    UITextField *supplementField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, backView.width - 7, backView.height)];
    supplementField.placeholder = @"订单补充说明:";
    supplementField.font = [UIFont systemFontOfSize:11];
    supplementField.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    supplementField.text = orderDetail.note;
    
    
    [backView addSubview:supplementField];
    
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, self.view.width - 40, 0.5)];
    [footerView addSubview:topLineView];
    
    UIView *downLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, footerView.height - 4, self.view.width, 4)];
    downLineView.backgroundColor = TCRGBColor(242, 242, 242);
    [footerView addSubview:downLineView];
    
    [footerView addSubview:backView];
    return footerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCOrder *order = orderDetailList[indexPath.section];
    NSArray *orderList = order.itemList;
    if (indexPath.row >= orderList.count) {
        return [self getOrderInfoTableViewCellWithIndexPath:indexPath AndTableView:(UITableView *)tableView];
    } else {
        NSString *identifier = [NSString stringWithFormat:@"%li", (long)indexPath.row];
        TCUserOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TCUserOrderTableViewCell alloc] initOrderDetailCellWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        TCOrderItem *orderItem = orderList[indexPath.row];
        TCGoods *good = orderItem.goods;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.leftImgView sd_setImageWithURL:[TCImageURLSynthesizer synthesizeImageURLWithPath:good.mainPicture] placeholderImage:[UIImage imageNamed:@"good_placeholder"]];
        [cell setTitleLabWithText:good.name];
        [cell setBoldPriceLabel:good.salePrice];
        [cell setBoldNumberLabel:orderItem.amount];
        [cell setSelectedStandard:good.standardSnapshot];
        return cell;
        
    }
}

- (UITableViewCell *)getOrderInfoTableViewCellWithIndexPath:(NSIndexPath *)indexPath AndTableView:(UITableView *)tableView{
    NSString *identifier = [NSString stringWithFormat:@"%li", (long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *orderInfoView;
    TCOrder *order = orderDetailList[indexPath.section];
    NSArray *orderList = order.itemList;
    if (indexPath.row == orderList.count) {
        orderInfoView = [self getOrderInfoViewWithTitle:@"配送方式:" AndText:@"全国包邮"];
    } else if (indexPath.row == orderList.count + 1) {
        orderInfoView = [self getOrderInfoViewWithTitle:@"快递运费:" AndText:@"￥0.00"];
    } else {
        NSString *totalStr = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", order.totalFee].floatValue)];
        orderInfoView = [self getOrderInfoViewWithTitle:@"价格合计:" AndText:totalStr];
    }
    [cell.contentView addSubview:orderInfoView];
    
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, self.view.width - 40, 0.5)];
    UIView *downLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 40 - 0.5, self.view.width - 40, 0.5)];
    [cell.contentView addSubview:topLineView];
    [cell.contentView addSubview:downLineView];
    
    return cell;
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


#pragma mark - Action
- (void)touchBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchOrderPayBtn:(UIButton *)button {

    
    NSMutableArray *itemList = [[NSMutableArray alloc] init];
    for (int i = 0; i< orderDetailList.count; i++) {
        TCOrder *order = orderDetailList[i];
        for (int j = 0; j < order.itemList.count; j++) {
            TCOrderItem *orderItem = order.itemList[j];
            [itemList addObject:@{ @"amount":[NSNumber numberWithInteger:orderItem.amount], @"goodsId":orderItem.goods.ID }];
        }
    }
    [self createOrderWithAddressId:@"" AndItemList:itemList];
    
}

- (void)touchOrderCancelBtn:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Status Bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSDictionary *)getItemListWithAmount:(NSInteger)amount AndGoosId:(NSString *)goodsId {
    return @{
             @"amount":[NSNumber numberWithInteger:amount],
             @"goodsId":goodsId
             };
}

- (void)createOrderWithAddressId:(NSString *)addressId AndItemList:(NSArray *)itemList {
    addressId = [[TCBuluoApi api] currentUserSession].userSensitiveInfo.addressID;
    [[TCBuluoApi api] createOrderWithItemList:itemList AddressId:addressId result:^(BOOL result, NSError *error) {
        if (result) {
            [MBProgressHUD showHUDWithMessage:@"创建订单成功"];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
