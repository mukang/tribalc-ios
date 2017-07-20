//
//  TCStorePayViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStorePayViewController.h"
#import "TCPaymentViewController.h"

#import "TCStorePayInputViewCell.h"
#import "TCStorePayPrivilegeViewCell.h"
#import "TCStorePayRealAmountViewCell.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/TCCommonButton.h>
#import <TCCommonLibs/UIImage+Category.h>

@interface TCStorePayViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, TCPaymentViewControllerDelegate>

@property (copy, nonatomic) NSArray *privilegeList;
@property (nonatomic) double amount;
@property (nonatomic) double realAmount;

/** 输入框里是否含有小数点 */
@property (nonatomic, getter=isHavePoint) BOOL havePoint;

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCCommonButton *confirmButton;

@end

@implementation TCStorePayViewController {
    __weak TCStorePayViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
    [self loadNetData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"优惠说明"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleClickInstructionItem:)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{
                                                                     NSFontAttributeName: [UIFont systemFontOfSize:14]
                                                                     }
                                                          forState:UIControlStateNormal];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(239, 244, 245);
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCStorePayInputViewCell class] forCellReuseIdentifier:@"TCStorePayInputViewCell"];
    [tableView registerClass:[TCStorePayPrivilegeViewCell class] forCellReuseIdentifier:@"TCStorePayPrivilegeViewCell"];
    [tableView registerClass:[TCStorePayRealAmountViewCell class] forCellReuseIdentifier:@"TCStorePayRealAmountViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

- (void)loadNetData {
    [MBProgressHUD showHUD:YES];
//    [[TCBuluoApi api] fetchStorePrivilegeByStoreID:self.storeID isValid:YES result:^(TCListStore *storeInfo, NSError *error) {
//        if (storeInfo) {
//            [MBProgressHUD hideHUD:YES];
//            weakSelf.navigationItem.title = storeInfo.storeName;
//            weakSelf.privilegeList = [weakSelf filterPrivilege:storeInfo.privileges];
//            [weakSelf.tableView reloadData];
//        } else {
//            NSString *reason = error.localizedDescription ?: @"请退出该页面重试";
//            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
//        }
//    }];
    
    [[TCBuluoApi api] fetchStorePrivilegeListByStoreID:self.storeID isValid:YES result:^(NSArray *privilegeList, NSError *error) {
        if (privilegeList) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.privilegeList = [weakSelf filterPrivilege:privilegeList];
            [weakSelf.tableView reloadData];
        } else {
            NSString *reason = error.localizedDescription ?: @"请退出该页面重试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取数据失败，%@", reason]];
        }
    }];
}

- (NSArray *)filterPrivilege:(NSArray *)privilegeList {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond
                                         fromDate:[NSDate date]];
    int64_t currentSecond = comp.hour * 60 * 60 + comp.minute * 60 + comp.second;
    
    int64_t startSecond = 0, endSecond = 0;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:privilegeList.count];
    for (TCPrivilege *privilege in privilegeList) {
        startSecond = [[privilege.activityTime firstObject] longLongValue];
        endSecond = [[privilege.activityTime lastObject] longLongValue];
        if (startSecond < endSecond) {
            if (startSecond <= currentSecond <= endSecond) {
                [temp addObject:privilege];
            }
        } else {
            if (currentSecond >= startSecond || currentSecond <= endSecond) {
                [temp addObject:privilege];
            }
        }
    }
    
    return [temp copy];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.privilegeList.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    switch (indexPath.section) {
        case 0:
        {
            TCStorePayInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStorePayInputViewCell" forIndexPath:indexPath];
            cell.textField.delegate = self;
            currentCell = cell;
        }
            break;
        case 1:
        {
            TCStorePayPrivilegeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStorePayPrivilegeViewCell" forIndexPath:indexPath];
            cell.privilege = self.privilegeList[indexPath.row];
            currentCell = cell;
        }
            break;
        case 2:
        {
            TCStorePayRealAmountViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCStorePayRealAmountViewCell" forIndexPath:indexPath];
            cell.realAmount = self.realAmount;
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
    if (indexPath.section == 1) {
        return 40;
    } else {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 100;
    } else {
        return CGFLOAT_MIN;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section; {
    if (section == 2) {
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, 100)];
        containerView.backgroundColor = [UIColor clearColor];
        
        TCCommonButton *confirmButton = [TCCommonButton buttonWithTitle:@"确认买单"
                                                                  color:TCCommonButtonColorPurple
                                                                 target:self
                                                                 action:@selector(handleClickConfirmButton:)];
        [confirmButton setImage:[UIImage imageWithColor:TCRGBColor(217, 217, 217)] forState:UIControlStateDisabled];
        confirmButton.enabled = NO;
        [containerView addSubview:confirmButton];
        self.confirmButton = confirmButton;
        
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(TCRealValue(315), 40));
            make.top.equalTo(containerView).offset(26.5);
            make.centerX.equalTo(containerView);
        }];
        
        return containerView;
    }
    return nil;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    /*
     * 不能输入.0-9以外的字符
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.havePoint = YES;
    } else {
        self.havePoint = NO;
    }
    
    if (string.length > 0) {
        // 当前输入的字符
        unichar character = [string characterAtIndex:0];
        TCLog(@"single = %c",character);
        
        // 不能输入.0-9以外的字符
        if (((character < '0') || (character > '9')) && (character != '.')) {
            return NO;
        }
        
        // 只能有一个小数点
        if (self.isHavePoint && character == '.') {
            return NO;
        }
        
        // 如果第一位是.则前面加上0
        if (textField.text.length == 0 && character == '.') {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondCharacter = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondCharacter isEqualToString:@"."]) {
                    return NO;
                }
            } else {
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (self.isHavePoint) {
            NSRange pointRange = [textField.text rangeOfString:@"."];
            if (range.location > pointRange.location) {
                if ([textField.text pathExtension].length > 1) {
                    return NO;
                }
            }
        }
    }
    return YES;
}

#pragma mark - TCPaymentViewControllerDelegate

- (void)paymentViewController:(TCPaymentViewController *)controller didFinishedPaymentWithPayment:(TCUserPayment *)payment {
    NSLog(@"支付成功");
//    TCPaySuccessViewController *paySuccessVC = [[TCPaySuccessViewController alloc] init];
//    paySuccessVC.totalAmount = payment.totalAmount;
//    paySuccessVC.storeName = self.storeDetailInfo.name;
//    paySuccessVC.fromController = self.fromController;
//    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    TCNumberTextField *textField = (TCNumberTextField *)notification.object;
    double value = [textField.text doubleValue];
    self.amount = value;
    
    TCPrivilege *privilege = nil;
    for (TCPrivilege *temp in self.privilegeList) {
        temp.selected = NO;
        if (value >= temp.condition) {
            privilege = temp;
        }
    }
    
    self.realAmount = value;
    if (privilege) {
        privilege.selected = YES;
        if (privilege.privilegeType == TCPrivilegeTypeReduce) {
            privilege.deductibleValue = privilege.value;
            self.realAmount = value - privilege.deductibleValue;
        } else if (privilege.privilegeType == TCPrivilegeTypeAliquot) {
            int multiplier = value / privilege.condition;
            privilege.deductibleValue = privilege.value * multiplier;
            self.realAmount = value - privilege.deductibleValue;
        } else {
            self.realAmount = value * privilege.value;
        }
    }
    
    if (value) {
        self.confirmButton.enabled = YES;
    } else {
        self.confirmButton.enabled = NO;
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, 2)] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)handleClickInstructionItem:(id)sender {
    
}

- (void)handleClickConfirmButton:(id)sender {
    TCPaymentViewController *vc = [[TCPaymentViewController alloc] initWithTotalFee:self.amount
                                                                         payPurpose:TCPayPurposeFace2Face
                                                                     fromController:self];
    vc.delegate = self;
    vc.targetID = self.storeID;
    [vc show:YES];
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
