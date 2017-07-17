//
//  TCSearchViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/17.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSearchViewController.h"

#import "TCSearchBarView.h"

@interface TCSearchViewController () <UITextFieldDelegate>

@property (weak, nonatomic) TCSearchBarView *searchBar;

@property (weak, nonatomic) UIView *noResultsView;
@property (weak, nonatomic) UILabel *noResultsLabel;

@end

@implementation TCSearchViewController {
    __weak TCSearchViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.view.backgroundColor = TCRGBColor(239, 244, 245);
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![self.searchBar.textField isFirstResponder]) {
        [self.searchBar.textField becomeFirstResponder];
    }
}

#pragma mark - Private Methods

- (void)setupNavBar {
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    TCSearchBarView *searchBar = [[TCSearchBarView alloc] init];
    searchBar.textField.delegate = self;
    [searchBar.cancelButton addTarget:self action:@selector(handleClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(64);
    }];
}

- (void)setupSubviews {
    UIView *noResultsView = [[UIView alloc] init];
    noResultsView.backgroundColor = [UIColor clearColor];
    noResultsView.hidden = YES;
    [self.view addSubview:noResultsView];
    self.noResultsView = noResultsView;
    
    UIImageView *noResultsIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_no_results"]];
    [noResultsView addSubview:noResultsIcon];
    
    UILabel *noResultsLabel = [[UILabel alloc] init];
    noResultsLabel.textAlignment = NSTextAlignmentCenter;
    noResultsLabel.textColor = TCGrayColor;
    noResultsLabel.font = [UIFont systemFontOfSize:12];
    noResultsLabel.numberOfLines = 0;
    [noResultsView addSubview:noResultsLabel];
    self.noResultsLabel = noResultsLabel;
    
    [noResultsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    [noResultsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(94), TCRealValue(90.5)));
        make.top.equalTo(noResultsView).offset(TCRealValue(128));
        make.centerX.equalTo(noResultsView);
    }];
    [noResultsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noResultsView).offset(30);
        make.right.equalTo(noResultsView).offset(-30);
        make.top.equalTo(noResultsIcon.mas_bottom).offset(TCRealValue(22.5));
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.noResultsView.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.searchBar.textField isFirstResponder]) {
        [self.searchBar.textField resignFirstResponder];
    }
    self.noResultsLabel.text = [NSString stringWithFormat:@"找不到任何“%@”匹配的内容", textField.text];
    self.noResultsView.hidden = NO;
    
    return YES;
}

#pragma mark - Actions

- (void)handleClickCancelButton:(id)sender {
    if ([self.searchBar.textField isFirstResponder]) {
        [self.searchBar.textField resignFirstResponder];
    }
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
