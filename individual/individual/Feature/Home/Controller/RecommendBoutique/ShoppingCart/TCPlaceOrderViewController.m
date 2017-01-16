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
#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"
//#import "TCBalancePayView.h"
#import "TCUserOrderTabBarController.h"
#import "TCUserOrderDetailViewController.h"
#import "TCShippingAddressViewController.h"

#import "TCPaymentView.h"

@interface TCPlaceOrderViewController () <TCPaymentViewDelegate> {
    UIScrollView *mScrollView;
    NSMutableArray *orderDetailList;
    NSMutableArray *supplementFieldArr;
//    TCBalancePayView *payView;
    TCOrderAddressView *userAddressView;
    CGFloat cursorHeight;
    
}

@end

@implementation TCPlaceOrderViewController {
    __weak TCPlaceOrderViewController *weakSelf;
}

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
    
    weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self initNavigationBar];
    
    supplementFieldArr = [[NSMutableArray alloc] init];
    
    mScrollView = [self getScrollViewWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - TCRealValue(49))];
    
    TCUserSession *userSession = [[TCBuluoApi api] currentUserSession];
    TCUserShippingAddress *shippingAddress = userSession.userInfo.shippingAddress;
    userAddressView = [[TCOrderAddressView alloc] initWithOrigin:CGPointMake(0, 0) WithShippingAddress:shippingAddress];
    UITapGestureRecognizer *selectAddressRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAddressSelect:)];
    [userAddressView addGestureRecognizer:selectAddressRecognizer];
    [mScrollView addSubview:userAddressView];
    
    UITableView *orderDetailTableView = [self getOrderDetailTableViewWithFrame:CGRectMake(0, userAddressView.y + userAddressView.height, self.view.width, [self getTableViewHeight])];
    [mScrollView addSubview:orderDetailTableView];
    
    mScrollView.contentSize = CGSizeMake(self.view.width, orderDetailTableView.y + orderDetailTableView.height);
 
    UIView *bottomView = [self getNotSettleBottomView];
    [self.view addSubview:bottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenAddressChange:) name:@"addressSelect" object:nil];

    
    [self initKeyboardRecovery];
}

- (void)initKeyboardRecovery {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchKeyBoardRecovery)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)touchKeyBoardRecovery {
    
    for (int i = 0; i < supplementFieldArr.count; i++) {
        UITextField *textField = supplementFieldArr[i];
        [textField resignFirstResponder];
    }
}



- (CGFloat)getTableViewHeight {
    CGFloat height = 0;
    for(int i = 0; i < orderDetailList.count; i++) {
        TCOrder *order = orderDetailList[i];
        height += TCRealValue(40) * 3 + TCRealValue(56) + TCRealValue(41) + order.itemList.count * TCRealValue(96.5);
    }
    
    return height;
}


- (void)initNavigationBar {
    self.navigationItem.title = @"确认下单";
}

- (UIView *)getNotSettleBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - TCRealValue(49), self.view.width, TCRealValue(49))];
    UILabel *payMoneyLab = [TCComponent createLabelWithFrame:CGRectMake(TCRealValue(20), 0, TCRealValue(35), bottomView.height) AndFontSize:TCRealValue(14) AndTitle:@"合计:"];
    [bottomView addSubview:payMoneyLab];
    UIButton *confirmPayBtn = [TCComponent createButtonWithFrame:CGRectMake(bottomView.width - TCScreenWidth / 2, 0, TCScreenWidth / 2, bottomView.height) AndTitle:@"去付款" AndFontSize:TCRealValue(16) AndBackColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] AndTextColor:[UIColor whiteColor]];
    [confirmPayBtn addTarget:self action:@selector(touchOrderPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmPayBtn];
    UILabel *priceLab = [TCComponent createLabelWithFrame:CGRectMake(payMoneyLab.x + payMoneyLab.width, 0, confirmPayBtn.x - payMoneyLab.x - payMoneyLab.width, bottomView.height) AndFontSize:TCRealValue(14) AndTitle:[self getAllTotalFeeStr] AndTextColor:confirmPayBtn.backgroundColor];
    [bottomView addSubview:priceLab];
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, bottomView.width, TCRealValue(0.5))];
    [bottomView addSubview:lineView];

    return bottomView;
}



//- (UIView *)getNotSettleBottomView {
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - TCRealValue(49), self.view.width, TCRealValue(49))];
//    
//    UIButton *payBtn = [TCComponent createButtonWithFrame:CGRectMake(bottomView.width / 2, 0, bottomView.width / 2, bottomView.height) AndTitle:@"去付款" AndFontSize:TCRealValue(16) AndBackColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] AndTextColor:[UIColor whiteColor]];
//    [payBtn addTarget:self action:@selector(touchOrderPayBtn:) forControlEvents:UIControlEventTouchUpInside];
//    UIButton *cancelBtn = [TCComponent createButtonWithFrame:CGRectMake(0, 0, bottomView.width / 2, bottomView.height) AndTitle:@"取消订单" AndFontSize:TCRealValue(16) AndBackColor:[UIColor whiteColor] AndTextColor:[UIColor blackColor]];
//    [cancelBtn addTarget:self action:@selector(touchOrderCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:cancelBtn];
//    [bottomView addSubview:payBtn];
//    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, bottomView.width, TCRealValue(0.5))];
//    [bottomView addSubview:lineView];
//    
//    return bottomView;
//}

- (NSString *)getAllTotalFeeStr {
    
    CGFloat totalFee;
    for (int i = 0; i < orderDetailList.count; i++) {
        TCOrder *order = orderDetailList[i];
        totalFee += order.totalFee;
    }
    NSString *totalStr = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", totalFee].floatValue)];
    return totalStr;
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
    TCUserShippingAddress *shippingAddress = userSession.userInfo.shippingAddress;
    order.ownerId = userSession.userInfo.ID;
    order.address = [NSString stringWithFormat:@"%@|%@|%@%@%@%@", shippingAddress.name, shippingAddress.phone, shippingAddress.province, shippingAddress.city, shippingAddress.district, shippingAddress.address];
    order.addressId = userSession.userInfo.addressID;
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
    return TCRealValue(41);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return TCRealValue(56);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCOrder *order = orderDetailList[indexPath.section];
    NSArray *orderList = order.itemList;
    if (indexPath.row >= orderList.count) {
        return TCRealValue(40);
    }
    else {
        return TCRealValue(96.5);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TCRealValue(41))];
    TCOrder *orderDetail = orderDetailList[section];
    TCMarkStore *markStore = orderDetail.store;
    UIImageView *storeLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(TCRealValue(20), headerView.height / 2 - TCRealValue(17) / 2, TCRealValue(17), TCRealValue(17))];
    NSURL *logoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, markStore.logo]];
    UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(TCRealValue(17), TCRealValue(17))];
    [storeLogoImgView sd_setImageWithURL:logoUrl placeholderImage:placeholderImage options:SDWebImageRetryFailed];
    
    UILabel *storeLabel = [TCComponent createLabelWithFrame:CGRectMake(storeLogoImgView.x + storeLogoImgView.width + TCRealValue(5), 0, self.view.width - storeLogoImgView.x - storeLogoImgView.width - TCRealValue(5), headerView.height) AndFontSize:TCRealValue(13) AndTitle:markStore.name AndTextColor:[UIColor blackColor]];
    storeLabel.font = [UIFont fontWithName:BOLD_FONT size:TCRealValue(13)];
    
    [headerView addSubview:storeLogoImgView];
    [headerView addSubview:storeLabel];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TCRealValue(60))];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(TCRealValue(20), TCRealValue(7.5), self.view.width - TCRealValue(40), TCRealValue(31.5))];
    backView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    TCOrder *orderDetail = orderDetailList[section];
    
    UITextField *supplementField = [[UITextField alloc] initWithFrame:CGRectMake(TCRealValue(5), 0, backView.width - TCRealValue(7), backView.height)];
    supplementField.placeholder = @"订单补充说明:";
    supplementField.font = [UIFont systemFontOfSize:TCRealValue(11)];
    supplementField.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    supplementField.text = orderDetail.note;
    supplementField.delegate = self;
    [supplementFieldArr addObject:supplementField];
    
    [backView addSubview:supplementField];
    
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), 0, self.view.width - TCRealValue(40), TCRealValue(0.5))];
    [footerView addSubview:topLineView];
    
    UIView *downLineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, footerView.height - TCRealValue(4), self.view.width, TCRealValue(4))];
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
        TCUserOrderTableViewCell *cell = [TCUserOrderTableViewCell cellWithTableView:tableView];
        TCOrderItem *orderItem = orderList[indexPath.row];
        [cell setOrderDetailOrderItem:orderItem];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}

#pragma mark - UITextFieldDelegate 
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect rect = [textField convertRect:textField.bounds toView:self.view];
    cursorHeight = rect.origin.y + rect.size.height;
    mScrollView.scrollEnabled = NO;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyBoardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat keyBoardHeight = keyBoardSize.height;
    CGFloat beyondHeight = keyBoardHeight - (TCScreenHeight - cursorHeight - 64);
    if (beyondHeight > 0) {
        [UIView animateWithDuration:0.15 animations:^(void) {
            self.view.frame = CGRectMake(0, -beyondHeight + TCRealValue(64) - TCRealValue(10) , TCScreenWidth, TCScreenHeight);
        }completion:nil];
    }
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.15 animations:^(void) {
        self.view.frame = CGRectMake(0, 64, TCScreenWidth, TCScreenHeight);
    }completion:nil];
    mScrollView.scrollEnabled = YES;
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
    
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), 0, self.view.width - TCRealValue(40), TCRealValue(0.5))];
    UIView *downLineView = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), TCRealValue(40 - 0.5), self.view.width - TCRealValue(40), TCRealValue(0.5))];
    [cell.contentView addSubview:topLineView];
    [cell.contentView addSubview:downLineView];
    
    return cell;
}

- (UIView *)getOrderInfoViewWithTitle:(NSString *)title AndText:(NSString *)text {
    UIView *orderInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TCRealValue(40))];
    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(TCRealValue(20), 0, TCRealValue(15 * 5), orderInfoView.height) AndFontSize:TCRealValue(13) AndTitle:title AndTextColor:[UIColor blackColor]];
    UILabel *textLab = [TCComponent createLabelWithFrame:CGRectMake(titleLab.x + titleLab.width, 0, self.view.width - titleLab.x - titleLab.width - TCRealValue(20), orderInfoView.height) AndFontSize:TCRealValue(13) AndTitle:text AndTextColor:[UIColor blackColor]];
    textLab.textAlignment = NSTextAlignmentRight;
    
    [orderInfoView addSubview:titleLab];
    [orderInfoView addSubview:textLab];
    
    return orderInfoView;
}

- (NSString *)getAllOrderTotalPrice {
    CGFloat totalPrice;
    for (int i = 0; i < orderDetailList.count; i++) {
        TCOrder *order = orderDetailList[i];
        totalPrice += order.totalFee;
    }
    NSString *totalPriceStr = [NSString stringWithFormat:@"%@", @([NSString stringWithFormat:@"%f", totalPrice].floatValue)];
    return totalPriceStr;
}

#pragma mark - TCPaymentViewDelegate

- (void)paymentView:(TCPaymentView *)view didFinishedPaymentWithStatus:(NSString *)status {
    // 跳转至“全部”订单列表
    TCUserOrderTabBarController *orderViewController = [[TCUserOrderTabBarController alloc] initWithTitle:@"全部"];
    [self.navigationController pushViewController:orderViewController animated:YES];
}

- (void)didClickCloseButtonInPaymentView:(TCPaymentView *)view {
    // 跳转至“待付款”订单列表
    TCUserOrderTabBarController *orderViewController = [[TCUserOrderTabBarController alloc] initWithTitle:@"待付款"];
    [self.navigationController pushViewController:orderViewController animated:YES];
}

#pragma mark - Action

- (void)touchOrderPayBtn:(UIButton *)button {
    if (userAddressView.shippingAddress == nil) {
        [MBProgressHUD showHUDWithMessage:@"请选择地址"];
        return;
    }
//    [self filterPayMethod];
    [self createOrder];
}
/*
- (void)jumpToOrderDetailViewController {
    UIViewController *orderViewController = [[TCUserOrderTabBarController alloc] initWithTitle:@"全部"];
    [payView removeFromSuperview];
    [self.navigationController pushViewController:orderViewController animated:YES];
}

- (void)touchClosePayMoneyBtn:(id)sender {
    
    UIViewController *orderViewController;
    if (!(payView.orderArr.count == 1)) {
        orderViewController = [[TCUserOrderTabBarController alloc] initWithTitle:@"待付款"];
    } else {
        orderViewController = [[TCUserOrderDetailViewController alloc] initWithOrder:payView.orderArr[0]];
    }
    [payView removeFromSuperview];
    [self.navigationController pushViewController:orderViewController animated:YES];
    

}
  */

- (void)touchOrderCancelBtn:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchAddressSelect:(id)sender {
    TCShippingAddressViewController *shippingAddressViewController = [[TCShippingAddressViewController alloc] initPlaceOrderAddressSelect];
    [self.navigationController pushViewController:shippingAddressViewController animated:YES];
}

- (void)listenAddressChange:(NSNotification *)notification {
    TCUserShippingAddress *shippingAddress = [notification object];
    [userAddressView setAddress:shippingAddress];
}

- (NSDictionary *)getItemListWithAmount:(NSInteger)amount AndGoosId:(NSString *)goodsId {
    return @{
             @"amount":[NSNumber numberWithInteger:amount],
             @"goodsId":goodsId
             };
}

/**
 创建订单
 */
- (void)createOrder {
    NSMutableArray *itemList = [[NSMutableArray alloc] init];
    for (int i = 0; i< orderDetailList.count; i++) {
        TCOrder *order = orderDetailList[i];
        for (int j = 0; j < order.itemList.count; j++) {
            TCOrderItem *orderItem = order.itemList[j];
            [itemList addObject:@{ @"amount":[NSNumber numberWithInteger:orderItem.amount], @"goodsId":orderItem.goods.ID, @"shoppingCartGoodsId":orderItem.ID }];

        }
    }
    NSString *addressId = userAddressView.shippingAddress.ID;
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] createOrderWithItemList:itemList AddressId:addressId result:^(NSArray *orderList, NSError *error) {
        if (orderList) {
//            payView = [[TCBalancePayView alloc] initWithPayPrice:[weakSelf getAllOrderTotalPrice] AndPayAction:@selector(touchPayMoneyBtn:) AndCloseAction:@selector(touchClosePayMoneyBtn:) AndTarget:self ] ;
//            payView.orderArr = orderList;
//            [payView showPayView];
            [MBProgressHUD hideHUD:YES];
            [weakSelf handleShowPaymentViewWithOrderList:orderList];
            
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"提交信息失败，%@", reason]];
        }
    }];
}

/**
 弹出paymentView
 */
- (void)handleShowPaymentViewWithOrderList:(NSArray *)orderList {
    NSMutableArray *orderIDs = [NSMutableArray array];
    CGFloat paymentAmount = 0;
    for (TCOrder *order in orderList) {
        paymentAmount += order.totalFee;
        [orderIDs addObject:order.ID];
    }
    
    TCPaymentView *paymentView = [[TCPaymentView alloc] initWithAmount:paymentAmount fromController:self];
    paymentView.orderIDs = orderIDs;
    paymentView.payPurpose = TCPayPurposeOrder;
    paymentView.delegate = self;
    [paymentView show:YES];
}

#pragma mark - Status Bar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
