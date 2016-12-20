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
#import "TCGenderPickerView.h"

typedef NS_ENUM(NSInteger, TCInputCellType) {
    TCInputCellTypeName = 0,
    TCInputCellTypeBirthdate,
    TCInputCellTypeGender,
    TCInputCellTypeIDNumber
};

@interface TCIDAuthViewController ()
<UITableViewDataSource,
UITableViewDelegate,
TCCommonInputViewCellDelegate,
TCDatePickerViewDelegate,
TCGenderPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) TCCommonButton *commitButton;

@property (copy, nonatomic) NSArray *titleArray;
@property (copy, nonatomic) NSArray *placeholderArray;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

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
    commitButton.centerX = TCScreenWidth * 0.5;
    commitButton.y = TCScreenHeight - commitButton.height - TCRealValue(70) - 64;
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

- (void)didTapContainerViewInCommonInputViewCell:(TCCommonInputViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == TCInputCellTypeBirthdate) {
        TCDatePickerView *datePickerView = [[TCDatePickerView alloc] initWithController:self];
        datePickerView.datePicker.date = [self.dateFormatter dateFromString:@"1990年01月01日"];
        datePickerView.datePicker.maximumDate = [NSDate date];
        datePickerView.delegate = self;
        [datePickerView show];
    } else if (indexPath.row == TCInputCellTypeGender) {
        TCGenderPickerView *genderPickerView = [[TCGenderPickerView alloc] initWithController:self];
        genderPickerView.delegate = self;
        [genderPickerView show];
    }
}

#pragma mark - TCDatePickerViewDelegate

- (void)didClickConfirmButtonInDatePickerView:(TCDatePickerView *)view {
    TCLog(@"%@", view.datePicker.date);
}

#pragma mark - TCGenderPickerViewDelegate

- (void)genderPickerView:(TCGenderPickerView *)view didClickConfirmButtonWithGender:(NSString *)gender {
    
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

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy年MM月dd日";
    }
    return _dateFormatter;
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
