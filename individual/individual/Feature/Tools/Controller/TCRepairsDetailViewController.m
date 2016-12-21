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

#import "TCDatePickerView.h"
#import "TCPhotoPicker.h"

#import "TCImageURLSynthesizer.h"
#import "TCBuluoApi.h"

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
UITextViewDelegate,
UIScrollViewDelegate,
TCCommonInputViewCellDelegate,
TCRepairsPhotosViewCellDelegate,
TCRepairsCommitViewCellDelegate,
TCPhotoPickerDelegate,
TCDatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *currentEditIndex;

@property (strong, nonatomic) TCPhotoPicker *photoPicker;
@property (strong, nonatomic) NSMutableArray *selectedPhotos;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) TCPropertyRepairsInfo *repairsInfo;

@end

@implementation TCRepairsDetailViewController {
    __weak TCRepairsDetailViewController *weakSelf;
}

- (instancetype)initWithPropertyRepairsType:(TCPropertyRepairsType)repairsType {
    self = [super initWithNibName:@"TCRepairsDetailViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        weakSelf = self;
        _repairsType = repairsType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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
        TCUserInfo *userInfo = [[TCBuluoApi api] currentUserSession].userInfo;
        TCUserSensitiveInfo *userSensitiveInfo = [[TCBuluoApi api] currentUserSession].userSensitiveInfo;
        switch (indexPath.row) {
            case TCInputCellTypeCommunity:
                cell.title = @"社区";
                cell.content = userInfo.communityName;
                cell.inputEnabled = NO;
                break;
            case TCInputCellTypeCompany:
                cell.title = @"公司";
                cell.content = userSensitiveInfo.companyName;
                cell.inputEnabled = NO;
                break;
            case TCInputCellTypeName:
                cell.title = @"申请人";
                cell.content = userInfo.name;
                cell.inputEnabled = NO;
                break;
            case TCInputCellTypefloor:
                cell.title = @"楼层";
                cell.placeholder = @"请输入：楼层-门牌号";
                cell.content = self.repairsInfo.floor;
                cell.inputEnabled = YES;
                break;
            case TCInputCellTypeAppointTime:
                cell.title = @"约定时间";
                cell.placeholder = @"请选择约定时间";
                if (self.repairsInfo.appointTime) {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.repairsInfo.appointTime / 1000];
                    cell.content = [self.dateFormatter stringFromDate:date];
                } else {
                    cell.content = nil;
                }
                cell.inputEnabled = NO;
                break;
                
            default:
                break;
        }
        currentCell = cell;
    } else {
        if (indexPath.row == 0) {
            TCRepairsDescViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRepairsDescViewCell" forIndexPath:indexPath];
            cell.textView.delegate = self;
            cell.textView.returnKeyType = UIReturnKeyDone;
            currentCell = cell;
        } else if (indexPath.row == 1) {
            TCRepairsPhotosViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRepairsPhotosViewCell" forIndexPath:indexPath];
            cell.selectedPhotos = self.selectedPhotos;
            cell.delegate = self;
            currentCell = cell;
        } else {
            TCRepairsCommitViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRepairsCommitViewCell" forIndexPath:indexPath];
            cell.delegate = self;
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.row == TCInputCellTypefloor) {
        self.repairsInfo.floor = textField.text;
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
    if (indexPath.row == TCInputCellTypeAppointTime) {
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
    self.repairsInfo.appointTime = (NSInteger)(timestamp * 1000);
    [self.tableView reloadData];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.currentEditIndex = [NSIndexPath indexPathForRow:0 inSection:1];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.repairsInfo.problemDesc = textView.text;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView endEditing:YES];
}

#pragma mark - TCRepairsPhotosViewCellDelegate

- (void)didClickAddButtonInRepairsPhotosViewCell:(TCRepairsPhotosViewCell *)cell {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf showPhotoPikerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    [alertController addAction:cameraAction];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [weakSelf showPhotoPikerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    [alertController addAction:albumAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)repairsPhotosViewCell:(TCRepairsPhotosViewCell *)cell didClickDeleteButtonWithPhotoIndex:(NSInteger)photoIndex {
    [self.selectedPhotos removeObjectAtIndex:photoIndex];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - TCPhotoPickerDelegate

- (void)photoPicker:(TCPhotoPicker *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [photoPicker dismissPhotoPicker];
    self.photoPicker = nil;
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *photoImage;
        if (info[UIImagePickerControllerEditedImage]) {
            photoImage = info[UIImagePickerControllerEditedImage];
        } else {
            photoImage = info[UIImagePickerControllerOriginalImage];
        }
        [self.selectedPhotos addObject:photoImage];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)photoPickerDidCancel:(TCPhotoPicker *)photoPicker {
    [photoPicker dismissPhotoPicker];
    self.photoPicker = nil;
}

#pragma mark - TCRepairsCommitViewCellDelegate

- (void)didClickCommitButtonInRepairsCommitViewCell:(TCRepairsCommitViewCell *)cell {
    [self handleClickCommitButton];
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

- (void)showPhotoPikerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    TCPhotoPicker *photoPicker = [[TCPhotoPicker alloc] initWithSourceController:self];
    photoPicker.delegate = self;
    [photoPicker showPhotoPikerWithSourceType:sourceType];
    self.photoPicker = photoPicker;
}

- (void)handleClickCommitButton {
    if (!self.repairsInfo.floor.length) {
        [MBProgressHUD showHUDWithMessage:@"请您填写楼层信息"];
        return;
    }
    if (!self.repairsInfo.appointTime) {
        [MBProgressHUD showHUDWithMessage:@"请您选择约定时间"];
        return;
    }
    
    switch (self.repairsType) {
        case TCPropertyRepairsTypePipe:
            self.repairsInfo.fixProject = @"PIPE_FIX";
            break;
        case TCPropertyRepairsTypeLighting:
            self.repairsInfo.fixProject = @"PUBLIC_LIGHTING";
            break;
        case TCPropertyRepairsTypeWaterPipe:
            self.repairsInfo.fixProject = @"WATER_PIPE_FIX";
            break;
        case TCPropertyRepairsTypeElectric:
            self.repairsInfo.fixProject = @"ELECTRICAL_FIX";
            break;
        case TCPropertyRepairsTypeOther:
            self.repairsInfo.fixProject = @"OTHERS";
            break;
            
        default:
            break;
    }
    
    NSInteger totalCount = self.selectedPhotos.count;
    __block NSInteger uploadCount = 0;
    NSMutableArray *pictures = [NSMutableArray array];
    
    [MBProgressHUD showHUD:YES];
    if (!totalCount) {
        [self handleCommitRepairsInfo];
    } else {
        for (UIImage *image in self.selectedPhotos) {
            [[TCBuluoApi api] uploadImage:image progress:nil result:^(BOOL success, TCUploadInfo *uploadInfo, NSError *error) {
                if (success) {
                    uploadCount ++;
                    [pictures addObject:[TCImageURLSynthesizer synthesizeImagePathWithName:uploadInfo.objectKey source:kTCImageSourceOSS]];
                    if (uploadCount == totalCount) {
                        weakSelf.repairsInfo.pictures = [pictures copy];
                        [weakSelf handleCommitRepairsInfo];
                    }
                } else {
                    NSString *reason = error.localizedDescription ?: @"请稍后再试";
                    [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"提交失败，%@", reason]];
                }
            }];
        }
    }
}

- (void)handleCommitRepairsInfo {
    [[TCBuluoApi api] commitPropertyRepairsInfo:self.repairsInfo result:^(BOOL success, TCPropertyManage *propertyManage, NSError *error) {
        if (success) {
            [MBProgressHUD showHUDWithMessage:@"提交成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"提交失败，%@", reason]];
        }
    }];
}

#pragma mark - Override Methods

- (NSMutableArray *)selectedPhotos {
    if (_selectedPhotos == nil) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
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

- (TCPropertyRepairsInfo *)repairsInfo {
    if (_repairsInfo == nil) {
        _repairsInfo = [[TCPropertyRepairsInfo alloc] init];
    }
    return _repairsInfo;
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
