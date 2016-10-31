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

@interface TCBioEditViewController () <UITextFieldDelegate>

@property (weak, nonatomic) TCBioEditView *editNickView;
@property (weak, nonatomic) TCBioEditGenderView *editGenderView;
@property (weak, nonatomic) TCBioEditView *editBirthdateView;
@property (weak, nonatomic) TCBioEditAffectionView *editAffectionView;

@property (strong, nonatomic) NSLayoutConstraint *nickViewTopConstraint;
@property (strong, nonatomic) NSLayoutConstraint *birthdateViewTopConstraint;

@property (strong, nonatomic) NSLayoutConstraint *nickViewCenterYConstraint;
@property (strong, nonatomic) NSLayoutConstraint *birthdateViewCenterYConstraint;

@end

@implementation TCBioEditViewController {
    __weak TCBioEditViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    weakSelf = self;
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.82];
    
    [self addGesture];
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

- (void)dealloc {
    [self removeNotifications];
}

#pragma mark - add gesture

- (void)addGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBackgroundViewGesture:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - actions

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

- (void)handleBackgroundViewGesture:(UITapGestureRecognizer *)gesture {
    if (self.bioEditType == TCBioEditTypeNick && [self.editNickView.textField isFirstResponder]) {
        [self.editNickView.textField resignFirstResponder];
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.editNickView.textField isFirstResponder]) {
        [self.editNickView.textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - setup subviews

- (void)setupBioEditNickView {
    TCBioEditView *editNickView = [[[NSBundle mainBundle] loadNibNamed:@"TCBioEditView" owner:nil options:nil] firstObject];
    editNickView.translatesAutoresizingMaskIntoConstraints = NO;
    editNickView.titleLabel.text = @"昵称";
    editNickView.textField.returnKeyType = UIReturnKeyDone;
    editNickView.textField.delegate = self;
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
    editBirthdateView.titleLabel.text = @"出生日期";
    [self.view addSubview:editBirthdateView];
    self.editBirthdateView = editBirthdateView;
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
                                              attribute:NSLayoutAttributeCenterY
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterY
                                             multiplier:1.0
                                               constant:0];
    [self.view addConstraint:constraint];
    self.birthdateViewCenterYConstraint = constraint;
}

- (void)setupBioEditAffectionView {
    TCBioEditAffectionView *editAffectionView = [[[NSBundle mainBundle] loadNibNamed:@"TCBioEditAffectionView" owner:nil options:nil] firstObject];
    editAffectionView.translatesAutoresizingMaskIntoConstraints = NO;
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
                                               constant:300];
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
