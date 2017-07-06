//
//  TCApartmentAddWithholdViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCApartmentAddWithholdViewController.h"
#import "TCBankCardViewController.h"
#import "TCBankPickerViewController.h"

#import "TCCommonInputViewCell.h"
#import "TCApartmentWithholdAddNameViewCell.h"
#import "TCApartmentWithholdConfirmViewCell.h"

#import "TCBuluoApi.h"

@interface TCApartmentAddWithholdViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
TCApartmentWithholdAddNameViewCellDelegate,
TCApartmentWithholdConfirmViewCellDelegate,
TCCommonInputViewCellDelegate,
TCBankPickerViewControllerDelegate>

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCApartmentAddWithholdViewController {
    __weak TCApartmentAddWithholdViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.navigationItem.title = self.isEdit ? @"修改代扣信息" : @"添加代扣信息";
    if (!self.withholdInfo) {
        self.withholdInfo = [[TCRentProtocolWithholdInfo alloc] init];
    }
    [self setupSubviews];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCApartmentWithholdConfirmViewCell class] forCellReuseIdentifier:@"TCApartmentWithholdConfirmViewCell"];
    [tableView registerClass:[TCApartmentWithholdAddNameViewCell class] forCellReuseIdentifier:@"TCApartmentWithholdAddNameViewCell"];
    [tableView registerNib:[UINib nibWithNibName:@"TCCommonInputViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TCCommonInputViewCell"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell = nil;
    if (indexPath.row == 0) {
        TCApartmentWithholdAddNameViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCApartmentWithholdAddNameViewCell" forIndexPath:indexPath];
        cell.textField.text = self.withholdInfo.userName;
        cell.textField.delegate = self;
        cell.delegate = self;
        currentCell = cell;
    } else if (indexPath.row == 5) {
        TCApartmentWithholdConfirmViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCApartmentWithholdConfirmViewCell" forIndexPath:indexPath];
        cell.isEdit = self.isEdit;
        cell.delegate = self;
        currentCell = cell;
    } else {
        TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
        cell.titleLabel.font = [UIFont systemFontOfSize:14];
        cell.delegate = self;
        switch (indexPath.row) {
            case 1:
                cell.inputEnabled = NO;
                cell.title = @"银行名称";
                cell.placeholder = @"请选择银行名";
                cell.content = self.withholdInfo.bankName;
                break;
            case 2:
                cell.inputEnabled = YES;
                cell.title = @"银行卡号";
                cell.placeholder = @"请填写银行卡号";
                cell.content = self.withholdInfo.bankCardNum;
                cell.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 3:
                cell.inputEnabled = YES;
                cell.title = @"身份证号";
                cell.placeholder = @"请填写身份证号";
                cell.content = self.withholdInfo.idNo;
                cell.keyboardType = UIKeyboardTypeASCIICapable;
                break;
            case 4:
                cell.inputEnabled = YES;
                cell.title = @"银行预留手机号";
                cell.placeholder = @"请填写银行预留手机号";
                cell.content = self.withholdInfo.phone;
                cell.keyboardType = UIKeyboardTypeNumberPad;
                break;
                
            default:
                break;
        }
        currentCell = cell;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        return 90;
    } else {
        return 41;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma makr - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.withholdInfo.userName = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - TCApartmentWithholdAddNameViewCellDelegate

- (void)didClickBankCardButtonInApartmentWithholdAddNameViewCell:(TCApartmentWithholdAddNameViewCell *)cell {
    TCBankCardViewController *vc = [[TCBankCardViewController alloc] initWithNibName:@"TCBankCardViewController" bundle:[NSBundle mainBundle]];
    vc.isForWithdraw = YES;
    vc.selectedCompletion = ^(TCBankCard *bankCard) {
        weakSelf.withholdInfo.bankName = bankCard.bankName;
        weakSelf.withholdInfo.bankCardNum = bankCard.bankCardNum;
        weakSelf.withholdInfo.bankCode = bankCard.bankCode;
        weakSelf.withholdInfo.userName = bankCard.userName;
        weakSelf.withholdInfo.phone = bankCard.phone;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - TCApartmentWithholdConfirmViewCellDelegate

- (void)didClickConfirmButtonInApartmentWithholdConfirmViewCell:(TCApartmentWithholdConfirmViewCell *)cell {
    if (self.withholdInfo.userName.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请您填写开户名！"];
        return;
    }
    if (self.withholdInfo.bankName.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请您选择银行名！"];
        return;
    }
    if (self.withholdInfo.bankCardNum.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请您填写银行卡号！"];
        return;
    }
    if (self.withholdInfo.idNo.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请您填写身份证号！"];
        return;
    }
    if (self.withholdInfo.phone.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请您填写银行预留手机号！"];
        return;
    }
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] modifyRentProtocolWithholdByRentProtocolID:self.withholdInfo.ID withholdInfo:self.withholdInfo result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            if (weakSelf.addWithholdSuccess) {
                weakSelf.addWithholdSuccess();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *question = self.isEdit ? @"修改代扣信息失败" : @"添加代扣信息失败";
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"%@，%@", question, reason]];
        }
    }];
}

#pragma mark - TCCommonInputViewCellDelegate

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch (indexPath.row) {
        case 2:
            self.withholdInfo.bankCardNum = textField.text;
            break;
        case 3:
            self.withholdInfo.idNo = textField.text;
            break;
        case 4:
            self.withholdInfo.phone = textField.text;
            break;
            
        default:
            break;
    }
}

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didTapContainerViewInCommonInputViewCell:(TCCommonInputViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.row == 1) {
        [self.tableView endEditing:YES];
        
        TCBankPickerViewController *vc = [[TCBankPickerViewController alloc] initWithBankPickerType:TCBankPickerTypeAddWithhold fromController:self];
        vc.banks = self.banks;
        vc.delegate = self;
        [vc show:YES];
    }
}

#pragma mark - TCBankPickerViewControllerDelegate

- (void)bankPickerViewController:(TCBankPickerViewController *)controller didClickConfirmButtonWithBankCard:(TCBankCard *)bankCard {
    self.withholdInfo.bankName = bankCard.bankName;
    self.withholdInfo.bankCode = bankCard.bankCode;
    [self.tableView reloadData];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView endEditing:YES];
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
