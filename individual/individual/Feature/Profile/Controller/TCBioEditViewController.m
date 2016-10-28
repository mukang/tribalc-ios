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

@interface TCBioEditViewController ()

@property (weak, nonatomic) TCBioEditView *editNickView;
@property (weak, nonatomic) TCBioEditGenderView *editGenderView;
@property (weak, nonatomic) TCBioEditView *editBirthdateView;
@property (weak, nonatomic) TCBioEditAffectionView *editAffectionView;

@end

@implementation TCBioEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.82];
    
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

- (void)setupBioEditNickView {
    TCBioEditView *editNickView = [[[NSBundle mainBundle] loadNibNamed:@"TCBioEditView" owner:nil options:nil] firstObject];
    editNickView.translatesAutoresizingMaskIntoConstraints = NO;
    editNickView.titleLabel.text = @"昵称";
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
