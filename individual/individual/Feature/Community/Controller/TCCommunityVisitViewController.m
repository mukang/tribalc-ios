//
//  TCCommunityVisitViewController.m
//  individual
//
//  Created by 穆康 on 2016/11/30.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCommunityVisitViewController.h"

#import "TCCommonInputViewCell.h"

#import "TCCommunityDetailInfo.h"

typedef NS_ENUM(NSInteger, TCInputCellType) {
    TCInputCellTypeCommunity = 0,
    TCInputCellTypeDate,
    TCInputCellTypeCompany,
    TCInputCellTypeName,
    TCInputCellTypePhone,
    TCInputCellTypeCount,
    TCInputCellTypeNotes
};

@interface TCCommunityVisitViewController () <UITableViewDataSource, UITableViewDelegate, TCCommonInputViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) UIButton *commitButton;

@property (copy, nonatomic) NSArray *titleArray;
@property (copy, nonatomic) NSArray *placeholderArray;

@end

@implementation TCCommunityVisitViewController {
    __weak TCCommunityVisitViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)setupNavBar {
    self.navigationItem.title = @"社区详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    self.tableView.tableFooterView = [UIView new];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"立即预约"
                                                                attributes:@{
                                                                             NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                             NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                             }];
    [commitButton setAttributedTitle:title forState:UIControlStateNormal];
    [commitButton setBackgroundColor:TCRGBColor(81, 199, 209)];
    [commitButton addTarget:self action:@selector(handleClickCommitButton:) forControlEvents:UIControlEventTouchUpInside];
    commitButton.layer.cornerRadius = 2.5;
    commitButton.layer.masksToBounds = YES;
    commitButton.size = CGSizeMake(TCRealValue(315), 40);
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
        case TCInputCellTypeCount:
            cell.inputEnabled = NO;
            break;
        default:
            cell.inputEnabled = YES;
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

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    
}

- (void)didTapContainerViewIncommonInputViewCell:(TCCommonInputViewCell *)cell {
    
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleClickCommitButton:(UIButton *)sender {
    
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
        _placeholderArray = @[@"", @"请选择预约日期", @"请输入公司名称", @"请输入预约人姓名", @"请输入手机号码", @"请选择参观人数", @"请输入备注说明"];
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
