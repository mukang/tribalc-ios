//
//  TCBiographyViewController.m
//  individual
//
//  Created by 穆康 on 2016/10/27.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBiographyViewController.h"
#import "TCBioEditViewController.h"
#import "TCBioEditPhoneViewController.h"
#import "TCShippingAddressViewController.h"
#import "TCBioEditAvatarViewController.h"

#import "TCBiographyViewCell.h"
#import "TCBiographyAvatarViewCell.h"
#import "TCCityPickerView.h"

#import "UIImage+Category.h"
#import "MBProgressHUD+Category.h"

#import "TCBuluoApi.h"

@interface TCBiographyViewController () <UITableViewDelegate, UITableViewDataSource, TCCityPickerViewDelegate>

@property (copy, nonatomic) NSArray *biographyTitles;
@property (copy, nonatomic) NSArray *bioDetailsTitles;

@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UIView *pickerBgView;
@property (weak, nonatomic) TCCityPickerView *cityPickerView;

@end

@implementation TCBiographyViewController {
    __weak TCBiographyViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
    [self fetchUserInfo];
    [self registerNotifications];
}

- (void)dealloc {
    self.tableView.delegate = nil;
    [self removeNotifications];
}

- (void)setupNavBar {
    self.navigationItem.title = @"个人信息";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleCickBackButton:)];
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(243, 243, 243);
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UINib *nib = [UINib nibWithNibName:@"TCBiographyViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"TCBiographyViewCell"];
    nib = [UINib nibWithNibName:@"TCBiographyAvatarViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"TCBiographyAvatarViewCell"];
}

- (void)fetchUserInfo {
    TCUserInfo *userInfo = [[TCBuluoApi api] currentUserSession].userInfo;
    TCUserSensitiveInfo *userSensitiveInfo = [[TCBuluoApi api] currentUserSession].userSensitiveInfo;
    // 昵称
    NSString *nickname = userInfo.nickname ?: @"";
    // 性别
    NSString *genderStr = @"";
    switch (userInfo.gender) {
        case TCUserGenderMale:
            genderStr = @"男";
            break;
        case TCUserGenderFemale:
            genderStr = @"女";
            break;
        default:
            break;
    }
    // 出生日期
    NSString *birthDateStr = @"";
    if (userInfo.birthday) {
        NSDate *birthDate = [NSDate dateWithTimeIntervalSince1970:(userInfo.birthday / 1000)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy年MM月dd日";
        birthDateStr = [dateFormatter stringFromDate:birthDate];
    }
    // 情感状况
    NSString *emotionStateStr = @"";
    switch (userInfo.emotionState) {
        case TCUserEmotionStateMarried:
            emotionStateStr = @"已婚";
            break;
        case TCUserEmotionStateSingle:
            emotionStateStr = @"单身";
            break;
        case TCUserEmotionStateLove:
            emotionStateStr = @"热恋";
            break;
        default:
            break;
    }
    // 电话号码
    NSString *phone = userSensitiveInfo.phone ?: @"";
    // 所在地
    NSString *province = userInfo.province ?: @"";
    NSString *city = userInfo.city ?: @"";
    NSString *district = userInfo.district ?: @"";
    NSString *address = [NSString stringWithFormat:@"%@%@%@", province, city, district];
    // 收货地址
    NSString *chippingAddress = @"";
    if (userSensitiveInfo.shippingAddress) {
        chippingAddress = [NSString stringWithFormat:@"%@%@%@%@", userSensitiveInfo.shippingAddress.province, userSensitiveInfo.shippingAddress.city, userSensitiveInfo.shippingAddress.district, userSensitiveInfo.shippingAddress.address];
    }
    
    self.bioDetailsTitles = @[@[@"", nickname, genderStr, birthDateStr, emotionStateStr], @[phone, address, chippingAddress]];
    [self.tableView reloadData];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell = nil;
    if (indexPath.section == 0 && indexPath.row == 0) {
        TCBiographyAvatarViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBiographyAvatarViewCell" forIndexPath:indexPath];
        cell.avatar = [[TCBuluoApi api] currentUserSession].userInfo.picture;
        currentCell = cell;
    } else {
        TCBiographyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBiographyViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = self.biographyTitles[indexPath.section][indexPath.row];
        cell.detailLabel.text = self.bioDetailsTitles[indexPath.section][indexPath.row];
        currentCell = cell;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 106.5;
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 11;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TCBioEditAvatarViewController *vc = [[TCBioEditAvatarViewController alloc] initWithNibName:@"TCBioEditAvatarViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            TCBioEditViewController *bioEditVC = [[TCBioEditViewController alloc] initWithNibName:@"TCBioEditViewController" bundle:[NSBundle mainBundle]];
            self.definesPresentationContext = YES;
            bioEditVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            bioEditVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            bioEditVC.bioEditType = indexPath.row - 1;
            bioEditVC.bioEditBlock = ^(BOOL isEdit, TCBioEditType bioEditType) {
                if (isEdit) {
                    [weakSelf fetchUserInfo];
                }
            };
            [self presentViewController:bioEditVC animated:NO completion:nil];
        }
    } else {
        if (indexPath.row == 0) {
            TCBioEditPhoneViewController *editPhoneVC = [[TCBioEditPhoneViewController alloc] initWithNibName:@"TCBioEditPhoneViewController" bundle:[NSBundle mainBundle]];
            editPhoneVC.editPhoneBlock = ^(BOOL isEdit) {
                if (isEdit) {
                    [weakSelf fetchUserInfo];
                }
            };
            [self.navigationController pushViewController:editPhoneVC animated:YES];
        } else if (indexPath.row == 1) {
            [self showPickerView];
        } else {
            TCShippingAddressViewController *vc = [[TCShippingAddressViewController alloc] initWithNibName:@"TCShippingAddressViewController" bundle:[NSBundle mainBundle]];
            vc.defaultShippingAddressChangeBlock = ^(BOOL isChange) {
                if (isChange) {
                    [weakSelf fetchUserInfo];
                }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - TCCityPickerViewDelegate

- (void)cityPickerView:(TCCityPickerView *)view didClickConfirmButtonWithCityInfo:(NSDictionary *)cityInfo {
    
    TCUserAddress *address = [[TCUserAddress alloc] init];
    address.province = cityInfo[TCCityPickierViewProvinceKey];
    address.city = cityInfo[TCCityPickierViewCityKey];
    address.district = cityInfo[TCCityPickierViewCountryKey];
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeUserAddress:address result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            [weakSelf fetchUserInfo];
        } else {
            [MBProgressHUD showHUDWithMessage:@"所在地修改失败！"];
        }
    }];
    
    [self dismissPickerView];
}

- (void)didClickCancelButtonInCityPickerView:(TCCityPickerView *)view {
    [self dismissPickerView];
}

#pragma mark - picker view

- (void)showPickerView {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIView *pickerBgView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    pickerBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    [keyWindow addSubview:pickerBgView];
    self.pickerBgView = pickerBgView;
    
    TCCityPickerView *cityPickerView = [[[NSBundle mainBundle] loadNibNamed:@"TCCityPickerView" owner:nil options:nil] firstObject];
    cityPickerView.delegate = self;
    cityPickerView.frame = CGRectMake(0, TCScreenHeight, TCScreenWidth, 240);
    [keyWindow addSubview:cityPickerView];
    self.cityPickerView = cityPickerView;
    
    [UIView animateWithDuration:0.25 animations:^{
        pickerBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.82];
        cityPickerView.y = TCScreenHeight - cityPickerView.height;
    }];
}

- (void)dismissPickerView {
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.cityPickerView.y = TCScreenHeight;
    } completion:^(BOOL finished) {
        [self.pickerBgView removeFromSuperview];
        [self.cityPickerView removeFromSuperview];
    }];
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUserInfoDidUpdate:) name:TCBuluoApiNotificationUserInfoDidUpdate object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)handleUserInfoDidUpdate:(id)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)handleCickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Override Methods

- (NSArray *)biographyTitles {
    if (_biographyTitles == nil) {
        _biographyTitles = @[@[@"头像", @"昵称", @"性别", @"出生日期", @"情感状态"], @[@"手机号", @"所在地", @"收货地址"]];
    }
    return _biographyTitles;
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
