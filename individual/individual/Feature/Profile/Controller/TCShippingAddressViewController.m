//
//  TCShippingAddressViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCShippingAddressViewController.h"
#import "TCShippingAddressEditViewController.h"

#import "TCShippingAddressViewCell.h"

#import "MBProgressHUD+Category.h"

#import "TCBuluoApi.h"

@interface TCShippingAddressViewController () <UITableViewDelegate, UITableViewDataSource, TCShippingAddressViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) TCUserShippingAddress *defaultShippingAddress;

@end

@implementation TCShippingAddressViewController {
    __weak TCShippingAddressViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    [self setupNavBar];
    [self setupSubviews];
    [self loadData];
}

- (void)setupNavBar {
    self.navigationItem.title = @"收货地址";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleCickBackButton:)];
}

- (void)setupSubviews {
    self.tableView.estimatedRowHeight = 115;
    UINib *nib = [UINib nibWithNibName:@"TCShippingAddressViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCShippingAddressViewCell"];
}

- (void)loadData {
    
    [[TCBuluoApi api] fetchUserShippingAddressList:^(NSArray *addressList, NSError *error) {
        if (addressList) {
            [weakSelf.dataList removeAllObjects];
            [weakSelf.dataList addObjectsFromArray:addressList];
            NSString *defaultAddressID = [[TCBuluoApi api] currentUserSession].userSensitiveInfo.addressID;
            for (TCUserShippingAddress *shippingAddress in weakSelf.dataList) {
                if ([shippingAddress.ID isEqualToString:defaultAddressID]) {
                    shippingAddress.defaultAddress = YES;
                    weakSelf.defaultShippingAddress = shippingAddress;
                    break;
                }
            }
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showHUDWithMessage:@"获取收货地址信息失败！"];
        }
    }];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCShippingAddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCShippingAddressViewCell" forIndexPath:indexPath];
    cell.shippingAddress = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

#pragma mark - TCShippingAddressViewCellDelegate

- (void)shippingAddressViewCell:(TCShippingAddressViewCell *)cell didClickDefaultAddressButtonWithShippingAddress:(TCUserShippingAddress *)shippingAddress {
    if (shippingAddress.isDefaultAddress) {
        return;
    }
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] setUserDefaultShippingAddress:shippingAddress.ID result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.defaultShippingAddress.defaultAddress = NO;
            shippingAddress.defaultAddress = YES;
            weakSelf.defaultShippingAddress = shippingAddress;
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showHUDWithMessage:@"设置默认地址失败！"];
        }
    }];
}

- (void)shippingAddressViewCell:(TCShippingAddressViewCell *)cell didClickEditAddressButtonWithShippingAddress:(TCUserShippingAddress *)shippingAddress {
    
}

- (void)shippingAddressViewCell:(TCShippingAddressViewCell *)cell didClickDeleteAddressButtonWithShippingAddress:(TCUserShippingAddress *)shippingAddress {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否要删除该条收货地址？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [weakSelf handleDeleteShippingAddress:shippingAddress];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)handleClickAddNewShippingAddressButton:(UIButton *)sender {
    TCShippingAddressEditViewController *vc = [[TCShippingAddressEditViewController alloc] initWithNibName:@"TCShippingAddressEditViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleCickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleDeleteShippingAddress:(TCUserShippingAddress *)shippingAddress {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] deleteUserShippingAddress:shippingAddress.ID result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            [weakSelf.dataList removeObject:shippingAddress];
            [weakSelf.tableView reloadData];
        } else {
            [MBProgressHUD showHUDWithMessage:@"删除收货地址失败！"];
        }
    }];
}

#pragma mark - Override Methods

- (NSMutableArray *)dataList {
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
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
