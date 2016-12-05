//
//  TCIDAuthViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/2.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCIDAuthViewController.h"

#import "TCCommonInputViewCell.h"

#import "TCCommonButton.h"
#import "TCDatePickerView.h"

typedef NS_ENUM(NSInteger, TCInputCellType) {
    TCInputCellTypeName = 0,
    TCInputCellTypeBirthdate,
    TCInputCellTypeGender,
    TCInputCellTypeIDNumber
};

@interface TCIDAuthViewController () <UITableViewDataSource, UITableViewDelegate, TCCommonInputViewCellDelegate, TCDatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TCCommonButton *commitButton;

@property (copy, nonatomic) NSArray *titleArray;
@property (copy, nonatomic) NSArray *placeholderArray;

@end

@implementation TCIDAuthViewController {
    __weak TCIDAuthViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)setupNavBar {
    self.navigationItem.title = @"身份认证";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    
    TCCommonButton *commitButton = [TCCommonButton buttonWithTitle:@"认证" target:self action:@selector(handleClickCommitButton:)];
    commitButton.centerX = self.tableView.width * 0.5;
    commitButton.y = self.tableView.height - commitButton.height - TCRealValue(70) - 64;
    [self.tableView addSubview:commitButton];
    self.commitButton = commitButton;
    
    UINib *nib = [UINib nibWithNibName:@"TCCommonInputViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCCommonInputViewCell"];
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
    TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    cell.placeholder = self.placeholderArray[indexPath.row];
    cell.inputCellType = indexPath.row;
    cell.delegate = self;
    if (indexPath.row == TCInputCellTypeBirthdate || indexPath.row == TCInputCellTypeGender) {
        cell.inputEnabled = NO;
    } else {
        cell.inputEnabled = YES;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == TCInputCellTypeName) {
        return 60;
    } else {
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark - TCCommonInputViewCellDelegate

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    
}

- (void)didTapContainerViewIncommonInputViewCell:(TCCommonInputViewCell *)cell {
    if (cell.inputCellType == TCInputCellTypeBirthdate) {
        TCDatePickerView *datePickerView = [[TCDatePickerView alloc] initWithDatePickerMode:UIDatePickerModeDate fromController:self];
        datePickerView.delegate = self;
        [datePickerView show];
    }
}

#pragma mark - TCDatePickerViewDelegate

- (void)datePickerView:(TCDatePickerView *)view didClickConfirmButtonWithDate:(NSDate *)date {
    TCLog(@"--%@", date);
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleClickCommitButton:(TCCommonButton *)sender {
    
}

#pragma mark - Override Methods

- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = @[@"真实姓名", @"出生日期", @"性别", @"身份证号"];
    }
    return _titleArray;
}

- (NSArray *)placeholderArray {
    if (_placeholderArray == nil) {
        _placeholderArray = @[@"请输入真实姓名", @"请选择出生日期", @"请选择性别", @"请输入身份证号码"];
    }
    return _placeholderArray;
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
