//
//  TCUserOrderDetailViewController.m
//  individual
//
//  Created by WYH on 16/11/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUserOrderDetailViewController.h"
#import "TCUserOrderTabBarController.h"
#import "TCBuluoApi.h"

@interface TCUserOrderDetailViewController () {
    TCOrder *orderDetail;
    UITableView *orderDetailTableView;
}

@end

@implementation TCUserOrderDetailViewController



- (instancetype)initWithOrder:(TCOrder *)order {
    self = [super init];
    if (self) {
        orderDetail = order;
        
    }
    
    return self;
}

- (instancetype)initWithItemList:(NSArray *)itemList {
    self = [super init];
    if (self) {
        TCUserSession *userSession = [[TCBuluoApi api] currentUserSession];
        orderDetail = [[TCOrder alloc] init];
        orderDetail.itemList = itemList;
        orderDetail.ownerId = userSession.userInfo.ID;
        TCUserShippingAddress *shippingAddress = userSession.userSensitiveInfo.shippingAddress;
        orderDetail.address = [NSString stringWithFormat:@"%@|%@|%@%@%@%@", shippingAddress.name, shippingAddress.phone, shippingAddress.province, shippingAddress.city, shippingAddress.district, shippingAddress.address];
        TCMarkStore *store = [[TCMarkStore alloc] init];
        store.name = @"三只松鼠";
        store.logo = @"";
        orderDetail.store = store;
        orderDetail.addressId = userSession.userSensitiveInfo.addressID;
        orderDetail.expressType = @"NOT_PAYPOSTAGE";
        orderDetail.expressFee = 7.0;
        orderDetail.status = @"";
        orderDetail.totalFee = [self getConfirmOrderViewTotalPrice];
        
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavigationBar];
    

    UIScrollView *scrollView = [self getScrollViewWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - TCRealValue(49))];
    
    NSArray *addressArr = [self getAddressArr];
    UIView *userAddressView = [[TCOrderAddressView alloc] initWithOrigin:CGPointMake(0, 0) AndName:addressArr[0] AndPhone:addressArr[1] AndAddress:addressArr[2]];
    [scrollView addSubview:userAddressView];
    
    NSArray *orderList = orderDetail.itemList;
    orderDetailTableView = [self getOrderDetailTableViewWithFrame:CGRectMake(0, userAddressView.y + userAddressView.height, self.view.width, TCRealValue(40) * 3 + TCRealValue(56) + TCRealValue(41) + orderList.count * TCRealValue(96.5))];
    [scrollView addSubview:orderDetailTableView];
    
    UIView *expressView = [self getExpressInfoWithStatus:orderDetail.orderStatus AndFrame:CGRectMake(orderDetailTableView.x, orderDetailTableView.y + orderDetailTableView.height + TCRealValue(4), TCScreenWidth, TCRealValue(175))];
    [scrollView addSubview:expressView];
    
    scrollView.contentSize = CGSizeMake(self.view.width, expressView.y + expressView.height);
    
    [self initBottomViewWithStatus:orderDetail.orderStatus];

}

- (UIView *)getExpressInfoWithStatus:(TCOrderStatus)status AndFrame:(CGRect)frame{
    switch (status) {
        case TCOrderNoSettle:
            return [self getExpressNoPayInfoViewWithFrame:frame];
        case TCOrderDelivery:
            return [self getExpressDeliveredAndReceivedInfoViewWithFrame:frame AndStatus:TCOrderDelivery];
        case TCOrderReceived:
            return [self getExpressDeliveredAndReceivedInfoViewWithFrame:frame AndStatus:TCOrderReceived];
        default:
            break;
    }
    return nil;
}

- (UIView *)getExpressDeliveredAndReceivedInfoViewWithFrame:(CGRect)frame AndStatus:(TCOrderStatus)status{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *deliverIdLab = [self getExpressInfoLabWithFrame:CGRectMake(TCRealValue(20), TCRealValue(11), TCScreenWidth - TCRealValue(40), TCRealValue(11)) AndText:@"物流编号" AndTitle:@"98321321321321"];
    [view addSubview:deliverIdLab];
    UILabel *orderNumLab = [self getExpressInfoLabWithFrame:CGRectMake(TCRealValue(20), deliverIdLab.y + deliverIdLab.height + TCRealValue(8), TCScreenWidth - TCRealValue(40), TCRealValue(11)) AndText:@"订单编号" AndTitle:orderDetail.orderNum];
    [view addSubview:orderNumLab];
    UILabel *balanceIdLab = [self getExpressInfoLabWithFrame:CGRectMake(TCRealValue(20), orderNumLab.y + orderNumLab.height + TCRealValue(8), orderNumLab.width, TCRealValue(11)) AndText:@"余额交易号" AndTitle:@"421421421421421421412"];
    [view addSubview:balanceIdLab];
    UILabel *createTimeLab = [self getExpressInfoLabWithFrame:CGRectMake(TCRealValue(20), balanceIdLab.y + balanceIdLab.height + TCRealValue(8), balanceIdLab.width, TCRealValue(11)) AndText:@"创建时间" AndTitle:[self timeStampTransToString:orderDetail.createTime]];
    [view addSubview:createTimeLab];
    UILabel *payTimeLab = [self getExpressInfoLabWithFrame:CGRectMake(TCRealValue(20), createTimeLab.y + createTimeLab.height + TCRealValue(8), createTimeLab.width, TCRealValue(11)) AndText:@"付款时间" AndTitle:[self timeStampTransToString:orderDetail.settleTime]];
    [view addSubview:payTimeLab];
    UILabel *deliverTimeLab = [self getExpressInfoLabWithFrame:CGRectMake(TCRealValue(20), payTimeLab.y + payTimeLab.height + TCRealValue(8), payTimeLab.width, TCRealValue(11)) AndText:@"发货时间" AndTitle:[self timeStampTransToString:orderDetail.deliveryTime]];
    [view addSubview:deliverTimeLab];
    if (status == TCOrderReceived) {
        UILabel *receivedTimeLab = [self getExpressInfoLabWithFrame:CGRectMake(TCRealValue(20), deliverTimeLab.y + deliverTimeLab.height + TCRealValue(8), deliverTimeLab.width, TCRealValue(11)) AndText:@"收货时间" AndTitle:[self timeStampTransToString:orderDetail.receivedTime]];
        [view addSubview:receivedTimeLab];
    }
    
    return view;
}

- (UIView *)getExpressNoPayInfoViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *orderNumLab = [self getExpressInfoLabWithFrame:CGRectMake(TCRealValue(20), TCRealValue(11), TCScreenWidth - TCRealValue(40), TCRealValue(11)) AndText:orderDetail.orderNum AndTitle:@"订单编号"];
    [view addSubview:orderNumLab];
    
    UILabel *createTimeLab = [self getExpressInfoLabWithFrame:CGRectMake(TCRealValue(20), orderNumLab.y + orderNumLab.height + TCRealValue(8), orderNumLab.width, TCRealValue(11)) AndText:[self timeStampTransToString:orderDetail.createTime] AndTitle:@"创建时间"];
    [view addSubview:createTimeLab];
    
    return view;
}

- (UILabel *)getExpressInfoLabWithFrame:(CGRect)frame AndText:(NSString *)text AndTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:TCRealValue(11)];
    label.textColor = TCRGBColor(154, 154, 154);
    label.text = [NSString stringWithFormat:@"%@ : %@", text, title];
    return label;
}

- (NSString *)timeStampTransToString:(NSInteger)timeStamp {
    if (timeStamp) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp / 1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
        
        return [dateFormatter stringFromDate:date];
    }
    return @"";
}

- (NSArray *)getAddressArr {
    if ([orderDetail.address containsString:@"|"]) {
        return [orderDetail.address componentsSeparatedByString:@"|"];
    } else {
        return @[@"", @"", @""];
    }
}

- (CGFloat)getConfirmOrderViewTotalPrice {
    NSArray *itemList = orderDetail.itemList;
    CGFloat totalPrice = 0;
    for (int i = 0; i < itemList.count; i++) {
        TCOrderItem *orderItem = itemList[i];
        totalPrice += orderItem.amount * orderItem.goods.salePrice;
    }
    
    return  totalPrice;
}

- (UIScrollView *)getScrollViewWithFrame:(CGRect)frame {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [self.view addSubview:scrollView];
    return scrollView;
}

- (void)initNavigationBar {
    UIButton *backbtn = [TCGetNavigationItem getBarButtonWithFrame:CGRectMake(0, 10, 0, 17) AndImageName:@"back"];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backbtn];
    [backbtn addTarget:self action:@selector(touchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.navigationItem.titleView = [TCGetNavigationItem getTitleItemWithText:self.title];
}

- (void)initBottomViewWithStatus:(TCOrderStatus)status {
    UIView *bottomView;
    switch (status) {
        case TCOrderNoSettle:
            bottomView = [self getNoSettleBottomView];
            break;
        case TCOrderSettle:
            bottomView = [self getSettleBottomView];
            break;
        case TCOrderCannel:
            bottomView = [self getCannelBottomView];
            break;
        case TCOrderDelivery:
            bottomView = [self getDeliveryBottomView];
            break;
        case TCOrderReceived:
            break;
        default:
//            bottomView = [self getNotCreateBottomView];
            break;
    }
//    UIView *bottomView = [self getWaitPayOrderBottomView];

    if (status != TCOrderCannel) {
        bottomView.backgroundColor = [UIColor whiteColor];
    }
    [self.view addSubview:bottomView];
}

- (UIView *)getCannelBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - TCRealValue(49), self.view.width, TCRealValue(49))];
    bottomView.backgroundColor = TCRGBColor(242, 242, 242);
    return bottomView;
}

- (UIView *)getSettleBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - TCRealValue(49), self.view.width, TCRealValue(49))];
    UIButton *confirmPayBtn = [TCComponent createButtonWithFrame:CGRectMake(bottomView.width - TCRealValue(111), 0, TCRealValue(111), bottomView.height) AndTitle:@"提醒发货" AndFontSize:TCRealValue(16) AndBackColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] AndTextColor:[UIColor whiteColor]];
    [confirmPayBtn addTarget:self action:@selector(touchOrderRemindBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmPayBtn];
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, bottomView.width, 0.5)];
    [bottomView addSubview:lineView];
    
    return bottomView;

}

//- (UIView *)getNoSettleBottomView {
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - TCRealValue(49), self.view.width, TCRealValue(49))];
//    UIButton *waitTakeBtn = [TCComponent createButtonWithFrame:CGRectMake(bottomView.width - TCRealValue(111), 0, TCRealValue(111), bottomView.height) AndTitle:@"待付款" AndFontSize:TCRealValue(16) AndBackColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] AndTextColor:[UIColor whiteColor]];
//    [waitTakeBtn addTarget:self action:@selector(touchOrderConfrimTake:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:waitTakeBtn];
//    UIButton *cancelBtn = [TCComponent createButtonWithFrame:CGRectMake(waitTakeBtn.x - TCRealValue(101), bottomView.height / 2 - TCRealValue(27) / 2, TCRealValue(87), TCRealValue(27)) AndTitle:@"取消订单" AndFontSize:TCRealValue(16) AndBackColor:[UIColor whiteColor] AndTextColor:[UIColor blackColor]];
//    [cancelBtn addTarget:self action:@selector(touchOrderCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
//    cancelBtn.layer.borderWidth = 0.5;
//    cancelBtn.layer.borderColor = TCRGBColor(42, 42, 42).CGColor;
//    cancelBtn.layer.cornerRadius = 5;
//    [bottomView addSubview:cancelBtn];
//    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, bottomView.width, 0.5)];
//    [bottomView addSubview:lineView];
//    
//    return bottomView;
//}
- (UIView *)getNoSettleBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - TCRealValue(49), self.view.width, TCRealValue(49))];

    UIButton *payBtn = [TCComponent createButtonWithFrame:CGRectMake(bottomView.width / 2, 0, bottomView.width / 2, bottomView.height) AndTitle:@"待付款" AndFontSize:TCRealValue(16) AndBackColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] AndTextColor:[UIColor whiteColor]];
    [payBtn addTarget:self action:@selector(touchOrderPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *cancelBtn = [TCComponent createButtonWithFrame:CGRectMake(0, 0, bottomView.width / 2, bottomView.height) AndTitle:@"取消订单" AndFontSize:TCRealValue(16) AndBackColor:[UIColor whiteColor] AndTextColor:[UIColor blackColor]];
    [cancelBtn addTarget:self action:@selector(touchOrderCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:cancelBtn];
    [bottomView addSubview:payBtn];
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, bottomView.width, TCRealValue(0.5))];
    [bottomView addSubview:lineView];

    return bottomView;
}



//- (UIView *)getNotCreateBottomView {
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - 49, self.view.width, 49)];
//    UILabel *payMoneyLab = [TCComponent createLabelWithFrame:CGRectMake(20, 0, 35, bottomView.height) AndFontSize:14 AndTitle:@"合计:"];
//    [bottomView addSubview:payMoneyLab];
//    UIButton *confirmPayBtn = [TCComponent createButtonWithFrame:CGRectMake(bottomView.width - 111, 0, 111, bottomView.height) AndTitle:@"确认下单" AndFontSize:16 AndBackColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] AndTextColor:[UIColor whiteColor]];
//    [confirmPayBtn addTarget:self action:@selector(touchOrderCreateBtn:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:confirmPayBtn];
//    NSString *totalStr = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", orderDetail.totalFee].floatValue)];
//    UILabel *priceLab = [TCComponent createLabelWithFrame:CGRectMake(payMoneyLab.x + payMoneyLab.width, 0, confirmPayBtn.x - payMoneyLab.x - payMoneyLab.width, bottomView.height) AndFontSize:14 AndTitle:totalStr AndTextColor:confirmPayBtn.backgroundColor];
//    [bottomView addSubview:priceLab];
//    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, bottomView.width, 0.5)];
//    [bottomView addSubview:lineView];
//    
//    return bottomView;
//}


- (UIView *)getWaitPayOrderBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - TCRealValue(49), self.view.width, TCRealValue(49))];
    UILabel *payMoneyLab = [TCComponent createLabelWithFrame:CGRectMake(TCRealValue(20), 0, TCRealValue(68), bottomView.height) AndFontSize:TCRealValue(14) AndTitle:@"支付金额 :"];
    [bottomView addSubview:payMoneyLab];
    UIButton *waitPayBtn = [TCComponent createButtonWithFrame:CGRectMake(bottomView.width - TCRealValue(111), 0, TCRealValue(111), bottomView.height) AndTitle:@"待付款" AndFontSize:TCRealValue(16) AndBackColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] AndTextColor:[UIColor whiteColor]];
    [bottomView addSubview:waitPayBtn];
    NSString *totalStr = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", orderDetail.totalFee].floatValue)];
    UILabel *priceLab = [TCComponent createLabelWithFrame:CGRectMake(payMoneyLab.x + payMoneyLab.width, 0, waitPayBtn.x - payMoneyLab.x - payMoneyLab.width, bottomView.height) AndFontSize:TCRealValue(14) AndTitle:totalStr AndTextColor:waitPayBtn.backgroundColor];
    [bottomView addSubview:priceLab];
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, bottomView.width, 0.5)];
    [bottomView addSubview:lineView];

    
    return bottomView;
}

- (UIView *)getDeliveryBottomView {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 64 - TCRealValue(49), self.view.width, TCRealValue(49))];
    UIButton *waitTakeBtn = [TCComponent createButtonWithFrame:CGRectMake(bottomView.width - TCRealValue(111), 0, TCRealValue(111), bottomView.height) AndTitle:@"确认收货" AndFontSize:TCRealValue(16) AndBackColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] AndTextColor:[UIColor whiteColor]];
    [waitTakeBtn addTarget:self action:@selector(touchOrderConfrimTake:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:waitTakeBtn];
    UIButton *delayTakeBtn = [TCComponent createButtonWithFrame:CGRectMake(waitTakeBtn.x - TCRealValue(101), bottomView.height / 2 - TCRealValue(30) / 2, TCRealValue(87), TCRealValue(30)) AndTitle:@"延迟收货" AndFontSize:16 AndBackColor:[UIColor whiteColor] AndTextColor:[UIColor blackColor]];
    delayTakeBtn.layer.borderWidth = 0.5;
    delayTakeBtn.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1].CGColor;
    delayTakeBtn.layer.cornerRadius = TCRealValue(5);
    [bottomView addSubview:delayTakeBtn];
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

- (UIView *)getOrderInfoViewWithTitle:(NSString *)title AndText:(NSString *)text {
    UIView *orderInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TCRealValue(40))];
    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(TCRealValue(20), 0, TCRealValue(55), orderInfoView.height) AndFontSize:TCRealValue(12) AndTitle:title AndTextColor:[UIColor blackColor]];
    UILabel *textLab = [TCComponent createLabelWithFrame:CGRectMake(titleLab.x + titleLab.width, 0, self.view.width - titleLab.x - titleLab.width - TCRealValue(20), orderInfoView.height) AndFontSize:12 AndTitle:text AndTextColor:[UIColor blackColor]];
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
    NSArray *orderList = orderDetail.itemList;
    return orderList.count + 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return TCRealValue(41);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return TCRealValue(56);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *orderList = orderDetail.itemList;
    if (indexPath.row >= orderList.count) {
        return TCRealValue(40);
    }
    else {
        return TCRealValue(96.5);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TCRealValue(41))];
    TCMarkStore *markStore = orderDetail.store;
    UIImageView *storeLogoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(TCRealValue(20), headerView.height / 2 - TCRealValue(17) / 2, TCRealValue(17), TCRealValue(17))];
    NSURL *logoUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, markStore.logo]];
    [storeLogoImgView sd_setImageWithURL:logoUrl placeholderImage:[UIImage imageNamed:@"map_bar"]];
    
    UILabel *storeLabel = [TCComponent createLabelWithFrame:CGRectMake(storeLogoImgView.x + storeLogoImgView.width + TCRealValue(5), 0, self.view.width - storeLogoImgView.x - storeLogoImgView.width - TCRealValue(5), headerView.height) AndFontSize:12 AndTitle:markStore.name AndTextColor:[UIColor blackColor]];
    storeLabel.font = [UIFont fontWithName:BOLD_FONT size:TCRealValue(12)];
    
    [headerView addSubview:storeLogoImgView];
    [headerView addSubview:storeLabel];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, TCRealValue(56))];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(TCRealValue(20), TCRealValue(7.5), self.view.width - TCRealValue(40), TCRealValue(31.5))];
    backView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    UITextField *supplementField = [[UITextField alloc] initWithFrame:CGRectMake(TCRealValue(5), 0, backView.width - TCRealValue(7), backView.height)];
    supplementField.placeholder = @"订单补充说明:";
    supplementField.font = [UIFont systemFontOfSize:TCRealValue(11)];
    supplementField.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    supplementField.text = orderDetail.note;
    if ([self.title isEqualToString:@"确认下单"]) {
        supplementField.userInteractionEnabled = YES;
    } else {
        supplementField.userInteractionEnabled = NO;
    }
    
    [backView addSubview:supplementField];
    
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), 0, self.view.width - TCRealValue(40), 0.5)];
    [footerView addSubview:topLineView];
    
    [footerView addSubview:backView];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *orderList = orderDetail.itemList;
    if (indexPath.row >= orderList.count) {
        return [self getOrderInfoTableViewCellWithIndexPath:indexPath];
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


- (UITableViewCell *)getOrderInfoTableViewCellWithIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%li", (long)indexPath.row];
    UITableViewCell *cell = [orderDetailTableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *orderInfoView;
    NSArray *orderList = orderDetail.itemList;
    if (indexPath.row == orderList.count) {
        orderInfoView = [self getOrderInfoViewWithTitle:@"配送方式:" AndText:@"全国包邮"];
    } else if (indexPath.row == orderList.count + 1) {
        orderInfoView = [self getOrderInfoViewWithTitle:@"快递运费:" AndText:@"￥0.00"];
    } else {
        NSString *totalStr = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", orderDetail.totalFee].floatValue)];
        orderInfoView = [self getOrderInfoViewWithTitle:@"价格合计:" AndText:totalStr];
    }
    [cell.contentView addSubview:orderInfoView];
    
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), 0, self.view.width - TCRealValue(40), 0.5)];
    UIView *downLineView = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), TCRealValue(40) - 0.5, self.view.width - TCRealValue(40), 0.5)];
    [cell.contentView addSubview:topLineView];
    [cell.contentView addSubview:downLineView];
    
    return cell;
}

- (void)showHUDMessageWithResult:(BOOL)result AndTitle:(NSString *)title {
    if (result) {
        [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"%@成功", title]];
    } else {
        [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"%@失败", title]];
    }
}


#pragma mark - TCOrderDetailAlertView
- (void)alertView:(TCOrderDetailAlertView *)alertView didSelectOptionButtonWithTag:(NSInteger)tag
{
    if (tag == 0) {
        [alertView removeFromSuperview];
    } else {
        [[TCBuluoApi api] changeOrderStatus:@"CANNEL" OrderId:orderDetail.ID result:^(BOOL result, NSError *error) {
            [self showHUDMessageWithResult:result AndTitle:@"取消订单"];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView removeFromSuperview];

    }
    
}


#pragma mark - click
- (void)touchBackBtn {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)touchOrderCreateBtn:(UIButton *)btn {
//    NSMutableArray *itemList = [[NSMutableArray alloc] init];
//    NSArray *orderList = orderDetail.itemList;
//    for (int i = 0; i < orderList.count; i++) {
//        TCOrderItem *orderItem = orderList[i];
//        itemList[i] = @{ @"amount": [NSNumber numberWithInteger:orderItem.amount], @"goodsId":orderItem.goods.ID };
//    }
//    [[TCBuluoApi api] createOrderWithItemList:itemList AddressId:orderDetail.addressId result:^(BOOL result, NSError *error) {
//        [self showHUDMessageWithResult:result AndTitle:@"创建订单"];
//    }];
//    
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    
//}

- (void)touchOrderCancelBtn:(UIButton *)btn {
    TCOrderDetailAlertView *alertView = [[TCOrderDetailAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [alertView show];
    alertView.delegate = self;
    
}





- (void)touchOrderPayBtn:(UIButton *)btn {
    [[TCBuluoApi api] changeOrderStatus:@"SETTLE" OrderId:orderDetail.ID result:^(BOOL result, NSError *error) {
        [self showHUDMessageWithResult:result AndTitle:@"付款"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)touchOrderRemindBtn:(UIButton *)btn {
    [[TCBuluoApi api] changeOrderStatus:@"DELIVERY" OrderId:orderDetail.ID result:^(BOOL result, NSError *error) {
        [self showHUDMessageWithResult:result AndTitle:@"无权限，发货"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)touchOrderConfrimTake:(UIButton *)btn {
    [[TCBuluoApi api] changeOrderStatus:@"RECEIVED" OrderId:orderDetail.ID result:^(BOOL result, NSError *error) {
        [self showHUDMessageWithResult:result AndTitle:@"确认收货"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
