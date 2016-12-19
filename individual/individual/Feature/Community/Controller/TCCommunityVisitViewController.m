//
//  TCCommunityVisitViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunityVisitViewController.h"

#import "TCCommonInputViewCell.h"
#import "TCCommonButton.h"
#import "TCDatePickerView.h"

#import "TCCommunityDetailInfo.h"
#import "TCCommunityReservationInfo.h"

#import "UIImage+Category.h"
#import "TCBuluoApi.h"

#import <Masonry.h>

typedef NS_ENUM(NSInteger, TCInputCellType) {
    TCInputCellTypeCommunity = 0,
    TCInputCellTypeDate,
    TCInputCellTypeCompany,
    TCInputCellTypeName,
    TCInputCellTypePhone,
    TCInputCellTypeCount,
    TCInputCellTypeNotes
};

@interface TCCommunityVisitViewController ()
<UITableViewDataSource,
UITableViewDelegate,
TCCommonInputViewCellDelegate,
UIScrollViewDelegate,
TCDatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *titleArray;
@property (copy, nonatomic) NSArray *placeholderArray;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;
@property (strong, nonatomic) TCCommunityReservationInfo *reservationInfo;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TCCommunityVisitViewController {
    __weak TCCommunityVisitViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self removeNotifications];
}

- (void)dealloc {
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

#pragma mark - Private Method

- (void)setupNavBar {
    self.navigationItem.title = @"我要参观";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    self.tableView.tableFooterView = [UIView new];
    
    TCCommonButton *commitButton = [TCCommonButton buttonWithTitle:@"立即预约" target:self action:@selector(handleClickCommitButton:)];
    [self.view addSubview:commitButton];
    
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(30);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-30);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-45);
    }];
    
    UINib *nib = [UINib nibWithNibName:@"TCCommonInputViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCCommonInputViewCell"];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
    cell.title = self.titleArray[indexPath.row];
    cell.placeholder = self.placeholderArray[indexPath.row];
    cell.delegate = self;
    switch (indexPath.row) {
        case TCInputCellTypeCommunity:
            cell.content = [NSString stringWithFormat:@"%@ %@", self.communityDetailInfo.city, self.communityDetailInfo.name];
            cell.inputEnabled = NO;
            break;
        case TCInputCellTypeDate:
            if (self.reservationInfo.reservationDate) {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.reservationInfo.reservationDate / 1000];
                cell.content = [self.dateFormatter stringFromDate:date];
            } else {
                cell.content = nil;
            }
            cell.inputEnabled = NO;
            break;
        case TCInputCellTypeCompany:
            cell.content = self.reservationInfo.companyName;
            cell.inputEnabled = YES;
            cell.keyboardType = UIKeyboardTypeDefault;
            break;
        case TCInputCellTypeName:
            cell.content = self.reservationInfo.reservationPerson;
            cell.inputEnabled = YES;
            cell.keyboardType = UIKeyboardTypeDefault;
            break;
        case TCInputCellTypePhone:
            cell.content = self.reservationInfo.phone;
            cell.inputEnabled = YES;
            cell.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case TCInputCellTypeCount:
            if (self.reservationInfo.reservationPersonNum) {
                cell.content = [NSString stringWithFormat:@"%zd", self.reservationInfo.reservationPersonNum];
            } else {
                cell.content = nil;
            }
            cell.inputEnabled = YES;
            cell.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case TCInputCellTypeNotes:
            cell.content = self.reservationInfo.note;
            cell.inputEnabled = YES;
            cell.keyboardType = UIKeyboardTypeDefault;
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == TCInputCellTypeCommunity) {
        return 60;
    } else {
        return 45;
    }
}

#pragma mark - TCCommonInputViewCellDelegate

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldBeginEditing:(UITextField *)textField {
    self.currentIndexPath = [self.tableView indexPathForCell:cell];
    return YES;
}

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    switch (indexPath.row) {
        case TCInputCellTypeCompany:
            self.reservationInfo.companyName = textField.text;
            break;
        case TCInputCellTypeName:
            self.reservationInfo.reservationPerson = textField.text;
            break;
        case TCInputCellTypePhone:
            self.reservationInfo.phone = textField.text;
            break;
        case TCInputCellTypeCount:
            self.reservationInfo.reservationPersonNum = [textField.text integerValue];
            break;
        case TCInputCellTypeNotes:
            self.reservationInfo.note = textField.text;
            break;
            
        default:
            break;
    }
}

- (void)didTapContainerViewInCommonInputViewCell:(TCCommonInputViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == TCInputCellTypeDate) {
        TCDatePickerView *datePickerView = [[TCDatePickerView alloc] initWithController:self];
        datePickerView.datePicker.date = [NSDate date];
        datePickerView.datePicker.minimumDate = [NSDate date];
        datePickerView.delegate = self;
        [datePickerView show];
        
        [self.tableView endEditing:YES];
    }
}

#pragma mark - TCDatePickerViewDelegate

- (void)didClickConfirmButtonInDatePickerView:(TCDatePickerView *)view {
    NSTimeInterval timestamp = [view.datePicker.date timeIntervalSince1970];
    self.reservationInfo.reservationDate = (NSInteger)(timestamp * 1000);
    [self.tableView reloadData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView endEditing:YES];
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleClickCommitButton:(UIButton *)sender {
    if (!self.reservationInfo.reservationDate) {
        [MBProgressHUD showHUDWithMessage:@"请您输入预约日期"];
        return;
    }
    if (!self.reservationInfo.companyName.length) {
        [MBProgressHUD showHUDWithMessage:@"请您输入公司名称"];
        return;
    }
    if (!self.reservationInfo.reservationPerson.length) {
        [MBProgressHUD showHUDWithMessage:@"请您输入姓名"];
        return;
    }
    if (!self.reservationInfo.phone.length) {
        [MBProgressHUD showHUDWithMessage:@"请您输入联系电话"];
        return;
    }
    if (!self.reservationInfo.reservationPersonNum) {
        [MBProgressHUD showHUDWithMessage:@"请您输入参观人数"];
        return;
    }
    
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] reserveCommunity:self.reservationInfo result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD showHUDWithMessage:@"预约成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"预约失败，%@", reason]];
        }
    }];
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    
    NSDictionary *info = notification.userInfo;
    
    CGFloat height = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, height, 0);
    
    [UIView animateWithDuration:duration animations:^{
        [weakSelf.tableView scrollToRowAtIndexPath:weakSelf.currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark - Override Methods

- (NSArray *)titleArray {
    if (_titleArray == nil) {
        _titleArray = @[@"预约社区", @"预约日期", @"公司名称", @"预约人", @"联系电话", @"参观人数", @"备注说明"];
    }
    return _titleArray;
}

- (NSArray *)placeholderArray {
    if (_placeholderArray == nil) {
        _placeholderArray = @[@"", @"请选择预约日期", @"请输入公司名称", @"请输入预约人姓名", @"请输入手机号码", @"请输入参观人数", @"请输入备注说明"];
    }
    return _placeholderArray;
}

- (TCCommunityReservationInfo *)reservationInfo {
    if (_reservationInfo == nil) {
        _reservationInfo = [[TCCommunityReservationInfo alloc] init];
        _reservationInfo.communityId = self.communityDetailInfo.ID;
    }
    return _reservationInfo;
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _dateFormatter.dateStyle = kCFDateFormatterShortStyle;
        _dateFormatter.timeStyle = kCFDateFormatterShortStyle;
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
