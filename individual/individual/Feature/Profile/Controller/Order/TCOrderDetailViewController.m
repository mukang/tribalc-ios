//
//  TCOrderDetailViewController.m
//  individual
//
//  Created by 穆康 on 2017/2/15.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCOrderDetailViewController.h"

#import "TCCommonButton.h"
#import "TCGoodsOrderCountDownView.h"
#import "TCGoodsOrderAddressViewCell.h"
#import "TCGoodsOrderStoreViewCell.h"
#import "TCGoodsOrderGoodsViewCell.h"
#import "TCGoodsOrderPriceViewCell.h"
#import "TCGoodsOrderNoteViewCell.h"
#import "TCGoodsOrderStatusViewCell.h"

#import "TCBuluoApi.h"
#import "TCPaymentView.h"

#import "TCImageURLSynthesizer.h"
#import "UIImage+Category.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface TCOrderDetailViewController () <UITableViewDataSource, UITableViewDelegate, TCPaymentViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) UIView *bottomView;
@property (weak, nonatomic) UIButton *cancelButton;
@property (weak, nonatomic) UIButton *confirmButton;
@property (strong, nonatomic) TCGoodsOrderCountDownView *countDownView;

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSDate *deadlineDate;
@property (strong, nonatomic) NSCalendar *calendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TCOrderDetailViewController {
    __weak TCOrderDetailViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = @"订单详情";
    
    [self setupSubviews];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    if (self.timer) {
        [self removeTimer];
    }
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(242, 242, 242);
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCGoodsOrderAddressViewCell class] forCellReuseIdentifier:@"TCGoodsOrderAddressViewCell"];
    [tableView registerClass:[TCGoodsOrderStoreViewCell class] forCellReuseIdentifier:@"TCGoodsOrderStoreViewCell"];
    [tableView registerClass:[TCGoodsOrderGoodsViewCell class] forCellReuseIdentifier:@"TCGoodsOrderGoodsViewCell"];
    [tableView registerClass:[TCGoodsOrderPriceViewCell class] forCellReuseIdentifier:@"TCGoodsOrderPriceViewCell"];
    [tableView registerClass:[TCGoodsOrderNoteViewCell class] forCellReuseIdentifier:@"TCGoodsOrderNoteViewCell"];
    [tableView registerClass:[TCGoodsOrderStatusViewCell class] forCellReuseIdentifier:@"TCGoodsOrderStatusViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    CGFloat bottomMargin = 0;
    if ((![self.goodsOrder.status isEqualToString:@"CANCEL"]) && (![self.goodsOrder.status isEqualToString:@"RECEIVED"])) {
        bottomMargin = 49;
        UIView *bottomView = [[UIView alloc] init];
        [self.view addSubview:bottomView];
        self.bottomView = bottomView;
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(49);
            make.left.bottom.right.equalTo(weakSelf.view);
        }];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"取消订单"
                                                                         attributes:@{
                                                                                      NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                      NSForegroundColorAttributeName: TCRGBColor(42, 42, 42)
                                                                                      }]
                                forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]
                                forState:UIControlStateNormal];
        [cancelButton setBackgroundImage:[UIImage imageWithColor:TCRGBColor(217, 217, 217)]
                                forState:UIControlStateHighlighted];
        [cancelButton addTarget:self
                         action:@selector(handleClickCancelButton:)
               forControlEvents:UIControlEventTouchUpInside];
        cancelButton.layer.borderColor = TCRGBColor(221, 221, 221).CGColor;
        cancelButton.layer.borderWidth = 0.5;
        [bottomView addSubview:cancelButton];
        self.cancelButton = cancelButton;
        
        UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmButton setBackgroundImage:[UIImage imageWithColor:TCRGBColor(81, 199, 209)]
                                 forState:UIControlStateNormal];
        [confirmButton setBackgroundImage:[UIImage imageWithColor:TCRGBColor(10, 164, 177)]
                                 forState:UIControlStateHighlighted];
        [confirmButton addTarget:self
                          action:@selector(handleClickConfirmButton:)
                forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:confirmButton];
        self.confirmButton = confirmButton;
        
        if ([self.goodsOrder.status isEqualToString:@"NO_SETTLE"]) {
            TCGoodsOrderCountDownView *countDownView = [[TCGoodsOrderCountDownView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 19.5)];
            tableView.tableHeaderView = countDownView;
            self.countDownView = countDownView;
            self.deadlineDate = [NSDate dateWithTimeIntervalSince1970:(self.goodsOrder.createTime / 1000 + 86400)];
            [self updateHeaderView];
            [self addTimer];
            
            [confirmButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"去付款"
                                                                              attributes:@{
                                                                                           NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                           NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                           }]
                                     forState:UIControlStateNormal];
            
            [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.bottom.equalTo(bottomView);
                make.right.equalTo(confirmButton.mas_left);
                make.width.equalTo(confirmButton);
            }];
            [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.bottom.equalTo(bottomView);
            }];
        } else if ([self.goodsOrder.status isEqualToString:@"SETTLE"]) {
            [confirmButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"提醒发货"
                                                                              attributes:@{
                                                                                           NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                           NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                           }]
                                     forState:UIControlStateNormal];
            [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bottomView);
            }];
        } else {
            [confirmButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"确认收货"
                                                                              attributes:@{
                                                                                           NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                           NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                           }]
                                     forState:UIControlStateNormal];
            [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(bottomView);
            }];
        }
    }
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).with.offset(-bottomMargin);
    }];
}

- (void)updateHeaderView {
    NSDate *currentDate = [NSDate date];
    if ([currentDate compare:self.deadlineDate] == NSOrderedDescending) {
        self.countDownView.countDowntext = @"订单即将关闭，请尽快支付";
        [self removeTimer];
    } else {
        NSDateComponents *comps = [self.calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                                   fromDate:currentDate
                                                     toDate:self.deadlineDate
                                                    options:0];
        self.countDownView.countDowntext = [NSString stringWithFormat:@"剩余时间：%02zd小时%02zd分%02zd秒", comps.hour, comps.minute, comps.second];
    }
}

#pragma mark - Timer

- (void)addTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateHeaderView) userInfo:nil repeats:YES];
}

- (void)removeTimer {
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return self.goodsOrder.itemList.count;
            break;
        case 3:
            return 3;
            break;
        case 4:
            return 1;
            break;
        case 5:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    switch (indexPath.section) {
        case 0:
        {
            TCGoodsOrderAddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsOrderAddressViewCell" forIndexPath:indexPath];
            cell.address = self.goodsOrder.address;
            currentCell = cell;
        }
            break;
        case 1:
        {
            TCGoodsOrderStoreViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsOrderStoreViewCell" forIndexPath:indexPath];
            NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:self.goodsOrder.store.logo];
            UIImage *placeholderImage = [UIImage placeholderImageWithSize:CGSizeMake(20, 20)];
            [cell.iconView sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageRetryFailed];
            cell.nameLabel.text = self.goodsOrder.store.name;
            currentCell = cell;
        }
            break;
        case 2:
        {
            TCGoodsOrderGoodsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsOrderGoodsViewCell" forIndexPath:indexPath];
            cell.orderItem = self.goodsOrder.itemList[indexPath.row];
            currentCell = cell;
        }
            break;
        case 3:
        {
            TCGoodsOrderPriceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsOrderPriceViewCell" forIndexPath:indexPath];
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"配送方式：";
                cell.subtitleLabel.text = [self.goodsOrder.expressType isEqualToString:@"PAYPOSTAGE"] ? @"全国包邮" : @"不包邮";
            } else if (indexPath.row == 1) {
                cell.titleLabel.text = @"快递运费：";
                cell.subtitleLabel.text = [NSString stringWithFormat:@"¥ %0.2f", self.goodsOrder.expressFee];
            } else {
                cell.titleLabel.text = @"价格合计：";
                cell.subtitleLabel.text = [NSString stringWithFormat:@"¥ %0.2f", self.goodsOrder.totalFee];
            }
            currentCell = cell;
        }
            break;
        case 4:
        {
            TCGoodsOrderNoteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsOrderNoteViewCell" forIndexPath:indexPath];
            cell.noteLabel.text = self.goodsOrder.note ?: @"无";
            currentCell = cell;
        }
            break;
        case 5:
        {
            TCGoodsOrderStatusViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsOrderStatusViewCell" forIndexPath:indexPath];
            cell.infoArray = [self handleCreateInfoArrayWithStatus:self.goodsOrder.status];
            currentCell = cell;
        }
            break;
            
        default:
            break;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 107;
            break;
        case 1:
            return 41;
            break;
        case 2:
            return 96;
            break;
        case 3:
            return 40;
            break;
        case 4:
            return 56;
            break;
        case 5:
            return 150;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 5) {
        return 4;
    } else {
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - TCPaymentViewDelegate
- (void)paymentView:(TCPaymentView *)view didFinishedPaymentWithStatus:(NSString *)status {
    [self handleRemoveHederView];
    self.cancelButton.hidden = YES;
    [self.confirmButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"提醒发货"
                                                                           attributes:@{
                                                                                        NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                                        NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                                        }]
                                  forState:UIControlStateNormal];
    [self.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeZero);
        make.left.bottom.equalTo(weakSelf.bottomView);
    }];
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bottomView);
    }];
    [self.view layoutIfNeeded];
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchOrderDetailWithOrderID:self.goodsOrder.ID result:^(TCOrder *order, NSError *error) {
        [MBProgressHUD hideHUD:YES];
        if (order) {
            weakSelf.goodsOrder = order;
            [weakSelf.tableView reloadData];
            if (weakSelf.statusChangeBlock) {
                weakSelf.statusChangeBlock(order);
            }
        }
    }];
}

#pragma mark - Actions

/**
 点击了取消订单按钮
 */
- (void)handleClickCancelButton:(UIButton *)sender {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否要取消订单？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf handleCancelOrderAction];
    }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

/**
 确认取消订单
 */
- (void)handleCancelOrderAction {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeOrderStatus:@"CANCEL" orderID:self.goodsOrder.ID result:^(BOOL success, TCOrder *order, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.bottomView.hidden = YES;
            [weakSelf handleRemoveHederView];
            [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.view);
            }];
            [weakSelf.view layoutIfNeeded];
            [weakSelf.tableView reloadData];
            if (weakSelf.statusChangeBlock) {
                weakSelf.statusChangeBlock(order);
            }
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"取消订单失败，%@", reason]];
        }
    }];
}

/**
 点击了底部按钮
 */
- (void)handleClickConfirmButton:(UIButton *)sender {
    if ([self.goodsOrder.status isEqualToString:@"NO_SETTLE"]) {
        [self handlePaymentAction];
    } else if ([self.goodsOrder.status isEqualToString:@"SETTLE"]) {
        [self handleRemindTheDeliveryAction];
    } else {
        [self handleConfirmTheGoodsAction];
    }
}

/**
 去付款
 */
- (void)handlePaymentAction {
    TCPaymentView *paymentView = [[TCPaymentView alloc] initWithAmount:self.goodsOrder.totalFee fromController:self];
    paymentView.orderIDs = @[self.goodsOrder.ID];
    paymentView.payPurpose = TCPayPurposeOrder;
    paymentView.delegate = self;
    [paymentView show:YES];
}

/**
 提醒发货
 */
- (void)handleRemindTheDeliveryAction {
    [MBProgressHUD showHUDWithMessage:@"已提醒卖家发货"];
}

/**
 确认收货
 */
- (void)handleConfirmTheGoodsAction {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeOrderStatus:@"RECEIVED" orderID:self.goodsOrder.ID result:^(BOOL success, TCOrder *order, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.bottomView.hidden = YES;
            [weakSelf.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.view);
            }];
            [weakSelf.view layoutIfNeeded];
            [weakSelf.tableView reloadData];
            if (weakSelf.statusChangeBlock) {
                weakSelf.statusChangeBlock(order);
            }
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"确认收货失败，%@", reason]];
        }
    }];
}

/**
 移除倒计时控件
 */
- (void)handleRemoveHederView {
    if (self.timer) {
        [self removeTimer];
    }
    self.countDownView = nil;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, CGFLOAT_MIN)];
}

- (NSArray *)handleCreateInfoArrayWithStatus:(NSString *)status {
    NSString *expressNum = [NSString stringWithFormat:@"物流编号：%@", self.goodsOrder.logisticsNum];
    NSString *orderNum = [NSString stringWithFormat:@"订单编号：%@", self.goodsOrder.orderNum];
    NSString *createTime = [NSString stringWithFormat:@"创建时间：%@", [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.goodsOrder.createTime / 1000]]];
    NSString *settleTime = [NSString stringWithFormat:@"付款时间：%@", [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.goodsOrder.settleTime / 1000]]];
    NSString *deliveryTime = [NSString stringWithFormat:@"发货时间：%@", [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.goodsOrder.deliveryTime / 1000]]];
    NSString *receivedTime = [NSString stringWithFormat:@"收货时间：%@", [self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.goodsOrder.receivedTime / 1000]]];
    
    if ([status isEqualToString:@"NO_SETTLE"] || [status isEqualToString:@"CANCEL"]) {
        return @[orderNum, createTime];
    } else if ([status isEqualToString:@"SETTLE"]) {
        return @[orderNum, createTime, settleTime];
    } else if ([status isEqualToString:@"DELIVERY"]) {
        return @[expressNum, orderNum, createTime, settleTime, deliveryTime];
    } else {
        return @[expressNum, orderNum, createTime, settleTime, deliveryTime, receivedTime];
    }
}

#pragma mark - Override Methods

- (NSCalendar *)calendar {
    if (_calendar == nil) {
        _calendar = [NSCalendar currentCalendar];
        _calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    return _calendar;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
