//
//  TCShippingAddressEditViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCShippingAddressEditViewController.h"

#import "TCShippingAddressEditViewCell.h"
#import "TCShippingAddressDetailViewCell.h"
#import "TCBiographyViewCell.h"
#import "TCCityPickerView.h"

@interface TCShippingAddressEditViewController () <UITableViewDataSource, UITableViewDelegate, TCCityPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) UIView *pickerBgView;
@property (weak, nonatomic) TCCityPickerView *cityPickerView;

@end

@implementation TCShippingAddressEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)setupNavBar {
    self.navigationItem.title = @"收货地址";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleCickBackButton:)];
}

- (void)setupSubviews {
    self.tableView.tableFooterView = [UIView new];
    
    UINib *nib = [UINib nibWithNibName:@"TCShippingAddressEditViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCShippingAddressEditViewCell"];
    nib = [UINib nibWithNibName:@"TCShippingAddressDetailViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCShippingAddressDetailViewCell"];
    nib = [UINib nibWithNibName:@"TCBiographyViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCBiographyViewCell"];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    if (indexPath.row == 2) {
        TCBiographyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCBiographyViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = @"所在地区";
        currentCell = cell;
    } else if (indexPath.row == 3) {
        TCShippingAddressDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCShippingAddressDetailViewCell" forIndexPath:indexPath];
        currentCell = cell;
    } else {
        TCShippingAddressEditViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCShippingAddressEditViewCell" forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"收货人";
        } else {
            cell.titleLabel.text = @"手机号码";
        }
        currentCell = cell;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return 67;
    } else {
        return 45;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        [self showPickerView];
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

#pragma mark - Picker View

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

#pragma mark - Actions

- (void)handleCickBackButton:(UIBarButtonItem *)sender {
    
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
