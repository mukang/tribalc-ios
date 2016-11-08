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

@interface TCBiographyViewController () <UITableViewDelegate, UITableViewDataSource, TCCityPickerViewDelegate>

@property (copy, nonatomic) NSArray *biographyTitles;
@property (copy, nonatomic) NSArray *bioDetailsTitles;

@property (weak, nonatomic) UIView *pickerBgView;
@property (weak, nonatomic) TCCityPickerView *cityPickerView;

@end

@implementation TCBiographyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)setupNavBar {
    
    self.navigationItem.title = @"个人信息";
    
}

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCRGBColor(243, 243, 243);
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    
    UINib *nib = [UINib nibWithNibName:@"TCBiographyViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"TCBiographyViewCell"];
    nib = [UINib nibWithNibName:@"TCBiographyAvatarViewCell" bundle:[NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:@"TCBiographyAvatarViewCell"];
    
    self.bioDetailsTitles = @[@[@"", @"瓜皮", @"女", @"1995年5月20日", @"单身"], @[@"15967897508", @"北京朝阳区", @"吉林省长春市九台区瓜皮小区"]];
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
            [self presentViewController:bioEditVC animated:NO completion:nil];
        }
    } else {
        if (indexPath.row == 0) {
            TCBioEditPhoneViewController *editPhoneVC = [[TCBioEditPhoneViewController alloc] initWithNibName:@"TCBioEditPhoneViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:editPhoneVC animated:YES];
        } else if (indexPath.row == 1) {
            [self showPickerView];
        } else {
            TCShippingAddressViewController *vc = [[TCShippingAddressViewController alloc] initWithNibName:@"TCShippingAddressViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - TCCityPickerViewDelegate

- (void)cityPickerView:(TCCityPickerView *)view didClickConfirmButtonWithCityInfo:(NSDictionary *)cityInfo {
    TCLog(@"%@", cityInfo);
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

#pragma mark - overwrite

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
