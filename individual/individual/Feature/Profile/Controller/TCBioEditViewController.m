//
//  TCBioEditViewController.m
//  individual
//
//  Created by 穆康 on 2016/10/28.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBioEditViewController.h"

#import "TCBioEditView.h"
#import "TCBioEditGenderView.h"
#import "TCBioEditAffectionView.h"

#import "TCBuluoApi.h"

#import "MBProgressHUD+Category.h"

static NSInteger const kMaxLength = 8;

@interface TCBioEditViewController () <UITextFieldDelegate, TCBioEditViewDelegate, TCBioEditGenderViewDelegate, TCBioEditAffectionViewDelegate>

@property (weak, nonatomic) TCBioEditView *editNickView;
@property (weak, nonatomic) TCBioEditGenderView *editGenderView;
@property (weak, nonatomic) TCBioEditView *editBirthdateView;
@property (weak, nonatomic) TCBioEditAffectionView *editAffectionView;
@property (weak, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) NSLayoutConstraint *nickViewTopConstraint;
@property (strong, nonatomic) NSLayoutConstraint *birthdateViewTopConstraint;

@property (strong, nonatomic) NSLayoutConstraint *nickViewCenterYConstraint;
@property (strong, nonatomic) NSLayoutConstraint *birthdateViewCenterYConstraint;

@property (strong, nonatomic) TCUserSession *userSession;

@end

@implementation TCBioEditViewController {
    __weak TCBioEditViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weakSelf = self;
    self.userSession = [[TCBuluoApi api] currentUserSession];
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    
    [self registerNotifications];
    
    switch (self.bioEditType) {
        case TCBioEditTypeNick:
            [self setupBioEditNickView];
            [self setupBioEditNickConstraints];
            break;
        case TCBioEditTypeGender:
            [self setupBioEditGenderView];
            [self setupBioEditGenderConstraints];
            break;
        case TCBioEditTypeBirthdate:
            [self setupBioEditBirthdateView];
            [self setupBioEditBirthdateConstraints];
            break;
        case TCBioEditTypeAffection:
            [self setupBioEditAffectionView];
            [self setupBioEditAffectionConstraints];
            break;
        default:
            break;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.82];
    }];
}

- (void)dealloc {
    [self removeNotifications];
}

#pragma mark - notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    if (self.bioEditType == TCBioEditTypeNick) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTextFieldTextDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    }
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if (self.bioEditType == TCBioEditTypeNick) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }
}

#pragma mark - Actions

- (void)keyboardWillShow:(NSNotification *)noti {
    if (self.bioEditType == TCBioEditTypeNick) {
        self.nickViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.editNickView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0
                                                                   constant:TCRealValue(116)];
        [self.view addConstraint:self.nickViewTopConstraint];
        [self.view removeConstraint:self.nickViewCenterYConstraint];
        
        NSDictionary *userInfo = noti.userInfo;
        CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
        [UIView animateWithDuration:duration animations:^{
            [weakSelf.view layoutIfNeeded];
        }];
    }
}

- (void)keyboardWillHidden:(NSNotification *)noti {
    if (self.bioEditType == TCBioEditTypeNick) {
        [self.view addConstraint:self.nickViewCenterYConstraint];
        [self.view removeConstraint:self.nickViewTopConstraint];
        
        NSDictionary *userInfo = noti.userInfo;
        CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
        [UIView animateWithDuration:duration animations:^{
            [weakSelf.view layoutIfNeeded];
        }];
    }
}

- (void)handleChangeDatePicker:(UIDatePicker *)datePicker {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年MM月dd日";
    self.editBirthdateView.textField.text = [dateFormatter stringFromDate:datePicker.date];
}

- (void)handleTextFieldTextDidChangeNotification:(NSNotification *)notification {
    UITextField *textField = (UITextField *)notification.object;
    UITextRange *markedRange = [textField markedTextRange];
    NSInteger markedTextLength = [textField offsetFromPosition:markedRange.start toPosition:markedRange.end];
    if (markedTextLength == 0 && textField.text.length > kMaxLength) {
        NSRange range = [textField.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, kMaxLength)];
        textField.text = [textField.text substringWithRange:range];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.editNickView.textField isFirstResponder]) {
        [self.editNickView.textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![[textField textInputMode] primaryLanguage] || [[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}

#pragma mark - TCBioEditViewDelegate

- (void)didClickCommitButtonInBioEditView:(TCBioEditView *)view {
    if ([view isEqual:self.editNickView]) {
        [self handleEditUserNick];
    } else if ([view isEqual:self.editBirthdateView]) {
        [self handleEditUserBirthdate];
    }
    
}

- (void)didClickCancelButtonInBioEditView:(TCBioEditView *)view {
    if ([view isEqual:self.editNickView]) {
        self.editNickView.hidden = YES;
        if ([self.editNickView.textField isFirstResponder]) {
            [self.editNickView.textField resignFirstResponder];
        }
    }
    if ([view isEqual:self.editBirthdateView]) {
        self.editBirthdateView.hidden = YES;
        self.datePicker.hidden = YES;
    }
    
    [self dismiss];
}

#pragma mark - TCBioEditGenderViewDelegate

- (void)bioEditGenderView:(TCBioEditGenderView *)view didClickCommitButtonWithGender:(TCUserGender)gender {
    if (gender == self.userSession.userInfo.gender) {
        view.hidden = YES;
        [self dismiss];
    } else {
        [self handleEditUserGender:gender];
    }
}

- (void)didClickCancelButtonInBioEditGenderView:(TCBioEditGenderView *)view {
    view.hidden = YES;
    [self dismiss];
}

#pragma mark - TCBioEditAffectionViewDelegate

- (void)bioEditAffectionView:(TCBioEditAffectionView *)view didClickCommitButtonWithEmotionState:(TCUserEmotionState)emotionState {
    if (emotionState == self.userSession.userInfo.emotionState) {
        view.hidden = YES;
        [self dismiss];
    } else {
        [self handleEditUserEmotionState:emotionState];
    }
}

- (void)didClickCancelButtonInBioEditAffectionView:(TCBioEditAffectionView *)view {
    view.hidden = YES;
    [self dismiss];
}

#pragma mark - Dismiss

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - Networking 

- (void)handleEditUserNick {
    NSString *nickname = self.editNickView.textField.text;
    if (nickname.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请您输入昵称"];
        return;
    }
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeUserNickname:nickname result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            if (weakSelf.bioEditBlock) {
                weakSelf.bioEditBlock(YES, TCBioEditTypeNick);
            }
            weakSelf.editNickView.hidden = YES;
            [weakSelf dismiss];
        } else {
            [MBProgressHUD showHUDWithMessage:@"昵称修改失败!"];
        }
    }];
}

- (void)handleEditUserGender:(TCUserGender)gender {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeUserGender:gender result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            if (weakSelf.bioEditBlock) {
                weakSelf.bioEditBlock(YES, TCBioEditTypeGender);
            }
            weakSelf.editGenderView.hidden = YES;
            [weakSelf dismiss];
        } else {
            [MBProgressHUD showHUDWithMessage:@"性别修改失败!"];
        }
    }];
}

- (void)handleEditUserBirthdate {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeUserBirthdate:self.datePicker.date result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            if (weakSelf.bioEditBlock) {
                weakSelf.bioEditBlock(YES, TCBioEditTypeBirthdate);
            }
            weakSelf.editBirthdateView.hidden = YES;
            weakSelf.datePicker.hidden = YES;
            [weakSelf dismiss];
        } else {
            [MBProgressHUD showHUDWithMessage:@"出生日期修改失败!"];
        }
    }];
}

- (void)handleEditUserEmotionState:(TCUserEmotionState)emotionState {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeUserEmotionState:emotionState result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD hideHUD:YES];
            if (weakSelf.bioEditBlock) {
                weakSelf.bioEditBlock(YES, TCBioEditTypeAffection);
            }
            weakSelf.editAffectionView.hidden = YES;
            [weakSelf dismiss];
        } else {
            [MBProgressHUD showHUDWithMessage:@"情感状况修改失败!"];
        }
    }];
}

#pragma mark - Setup Subviews

- (void)setupBioEditNickView {
    TCBioEditView *editNickView = [[[NSBundle mainBundle] loadNibNamed:@"TCBioEditView" owner:nil options:nil] firstObject];
    editNickView.translatesAutoresizingMaskIntoConstraints = NO;
    editNickView.titleLabel.text = @"昵称";
    editNickView.textField.text = self.userSession.userInfo.nickname;
    editNickView.textField.returnKeyType = UIReturnKeyDone;
    editNickView.textField.keyboardType = UIKeyboardTypeDefault;
    editNickView.textField.delegate = self;
    editNickView.delegate = self;
    [self.view addSubview:editNickView];
    self.editNickView = editNickView;
}

- (void)setupBioEditNickConstraints {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.editNickView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:TCRealValue(335)];
    [self.editNickView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.editNickView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1.0
                                               constant:190];
    [self.editNickView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.editNickView
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.editNickView
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
    self.nickViewCenterYConstraint = constraint;
}

- (void)setupBioEditGenderView {
    TCBioEditGenderView *editGenderView = [[[NSBundle mainBundle] loadNibNamed:@"TCBioEditGenderView" owner:nil options:nil] firstObject];
    editGenderView.translatesAutoresizingMaskIntoConstraints = NO;
    editGenderView.delegate = self;
    editGenderView.gender = self.userSession.userInfo.gender;
    [self.view addSubview:editGenderView];
    self.editGenderView = editGenderView;
}

- (void)setupBioEditGenderConstraints {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.editGenderView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:TCRealValue(335)];
    [self.editGenderView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.editGenderView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1.0
                                               constant:190];
    [self.editGenderView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.editGenderView
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.editGenderView
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
}

- (void)setupBioEditBirthdateView {
    TCBioEditView *editBirthdateView = [[[NSBundle mainBundle] loadNibNamed:@"TCBioEditView" owner:nil options:nil] firstObject];
    editBirthdateView.translatesAutoresizingMaskIntoConstraints = NO;
    editBirthdateView.textField.userInteractionEnabled = NO;
    editBirthdateView.textField.text = @"1990年01月01日";
    editBirthdateView.titleLabel.text = @"出生日期";
    editBirthdateView.delegate = self;
    [self.view addSubview:editBirthdateView];
    self.editBirthdateView = editBirthdateView;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = 1990;
    components.month = 1;
    components.day = 1;
    datePicker.date = [[NSCalendar currentCalendar] dateFromComponents:components];
    components.year = 2016;
    components.month = 1;
    components.day = 1;
    datePicker.maximumDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    [datePicker addTarget:self action:@selector(handleChangeDatePicker:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    self.datePicker = datePicker;
}

- (void)setupBioEditBirthdateConstraints {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.editBirthdateView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:TCRealValue(335)];
    [self.editBirthdateView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.editBirthdateView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1.0
                                               constant:190];
    [self.editBirthdateView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.editBirthdateView
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.editBirthdateView
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1.0
                                               constant:TCRealValue(116)];
    [self.view addConstraint:constraint];
    self.birthdateViewCenterYConstraint = constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:self.datePicker
                                              attribute:NSLayoutAttributeLeft
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeft
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.datePicker
                                              attribute:NSLayoutAttributeRight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.datePicker
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.datePicker
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1.0
                                               constant:190];
    [self.datePicker addConstraint:constraint];
}

- (void)setupBioEditAffectionView {
    TCBioEditAffectionView *editAffectionView = [[[NSBundle mainBundle] loadNibNamed:@"TCBioEditAffectionView" owner:nil options:nil] firstObject];
    editAffectionView.translatesAutoresizingMaskIntoConstraints = NO;
    editAffectionView.delegate = self;
    editAffectionView.emotionState = self.userSession.userInfo.emotionState;
    [self.view addSubview:editAffectionView];
    self.editAffectionView = editAffectionView;
}

- (void)setupBioEditAffectionConstraints {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.editAffectionView
                                                                  attribute:NSLayoutAttributeWidth
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:nil
                                                                  attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1.0
                                                                   constant:TCRealValue(335)];
    [self.editAffectionView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.editAffectionView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:nil
                                              attribute:NSLayoutAttributeNotAnAttribute
                                             multiplier:1.0
                                               constant:254];
    [self.editAffectionView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.editAffectionView
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.editAffectionView
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
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
