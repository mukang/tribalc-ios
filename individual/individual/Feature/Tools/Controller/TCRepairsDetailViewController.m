//
//  TCRepairsDetailViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRepairsDetailViewController.h"

#import "TCCommonInputViewCell.h"
#import "TCRepairsDescViewCell.h"
#import "TCRepairsPhotosViewCell.h"
#import "TCRepairsCommitViewCell.h"

typedef NS_ENUM(NSInteger, TCInputCellType) {
    TCInputCellTypeCommunity = 0,
    TCInputCellTypeCompany,
    TCInputCellTypeName,
    TCInputCellTypefloor,
    TCInputCellTypeAppointTime
};

@interface TCRepairsDetailViewController ()
<UITableViewDataSource,
UITableViewDelegate,
TCCommonInputViewCellDelegate,
TCRepairsDescViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *currentEditIndex;

@end

@implementation TCRepairsDetailViewController {
    __weak TCRepairsDetailViewController *weakSelf;
}

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

- (void)setupNavBar {
    self.navigationItem.title = @"添加详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleClickBackButton:)];
}

- (void)setupSubviews {
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *nib = [UINib nibWithNibName:@"TCCommonInputViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCCommonInputViewCell"];
    nib = [UINib nibWithNibName:@"TCRepairsDescViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCRepairsDescViewCell"];
    nib = [UINib nibWithNibName:@"TCRepairsPhotosViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCRepairsPhotosViewCell"];
    nib = [UINib nibWithNibName:@"TCRepairsCommitViewCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TCRepairsCommitViewCell"];
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
    UITableViewCell *currentCell;
    if (indexPath.section == 0) {
        TCCommonInputViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCommonInputViewCell" forIndexPath:indexPath];
        cell.hideSeparatorView = NO;
        cell.delegate = self;
        switch (indexPath.row) {
            case TCInputCellTypeCommunity:
                cell.title = @"社区";
                cell.content = @"北京天安门广场社区";
                cell.inputEnabled = NO;
                break;
            case TCInputCellTypeCompany:
                cell.title = @"公司";
                cell.content = @"杭州部落公社科技有限公司";
                cell.inputEnabled = NO;
                break;
            case TCInputCellTypeName:
                cell.title = @"申请人";
                cell.content = @"唐纳德·特朗普";
                cell.inputEnabled = NO;
                break;
            case TCInputCellTypefloor:
                cell.title = @"楼层";
                cell.placeholder = @"请输入：楼层-门牌号";
                cell.inputEnabled = YES;
                break;
            case TCInputCellTypeAppointTime:
                cell.title = @"约定时间";
                cell.placeholder = @"请选择约定时间";
                cell.inputEnabled = NO;
                break;
                
            default:
                break;
        }
        currentCell = cell;
    } else {
        if (indexPath.row == 0) {
            TCRepairsDescViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRepairsDescViewCell" forIndexPath:indexPath];
            cell.delegate = self;
            currentCell = cell;
        } else if (indexPath.row == 1) {
            TCRepairsPhotosViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRepairsPhotosViewCell" forIndexPath:indexPath];
            currentCell = cell;
        } else {
            TCRepairsCommitViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRepairsCommitViewCell" forIndexPath:indexPath];
            currentCell = cell;
        }
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 50;
        } else {
            return 45;
        }
    } else {
        if (indexPath.row == 0) {
            return 146.5;
        } else if (indexPath.row == 1) {
            return 151;
        } else {
            return 85;
        }
    }
}

#pragma mark - TCCommonInputViewCellDelegate

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldBeginEditing:(UITextField *)textField {
    self.currentEditIndex = [self.tableView indexPathForCell:cell];
    return YES;
}

- (void)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldDidEndEditing:(UITextField *)textField {
    
}

- (BOOL)commonInputViewCell:(TCCommonInputViewCell *)cell textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didTapContainerViewIncommonInputViewCell:(TCCommonInputViewCell *)cell {
    
}

#pragma mark - TCRepairsDescViewCellDelegate

- (BOOL)textViewShouldBeginEditingInRepairsDescViewCell:(TCRepairsDescViewCell *)cell {
    self.currentEditIndex = [self.tableView indexPathForCell:cell];
    return YES;
}

- (BOOL)repairsDescViewCell:(TCRepairsDescViewCell *)cell textViewShouldReturn:(UITextView *)textView {
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
    return YES;
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

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    if (self.currentEditIndex.section != 1 || self.currentEditIndex.row != 0) return;
    
    NSDictionary *info = notification.userInfo;
    
    CGFloat height = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, height, 0);
    
    [UIView animateWithDuration:duration animations:^{
        [weakSelf.tableView scrollToRowAtIndexPath:weakSelf.currentEditIndex atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
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
