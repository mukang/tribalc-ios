//
//  TCCompanyViewController.m
//  individual
//
//  Created by 穆康 on 2016/12/7.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCompanyViewController.h"

#import "TCImagePlayerView.h"
#import "TCCompanyIntroViewCell.h"

#import "TCUserCompanyInfo.h"

@interface TCCompanyViewController () <UITableViewDataSource, UITableViewDelegate, TCCompanyIntroViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) CGFloat headerViewHeight;
@property (nonatomic) CGFloat topBarHeight;

@property (nonatomic) BOOL companyIntroUnfold;

@end

@implementation TCCompanyViewController {
    __weak TCCompanyViewController *weakSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    weakSelf = self;
    self.headerViewHeight = TCRealValue(270);
    self.topBarHeight = 64.0;
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupNavBar];
    [self setupSubviews];
}

- (void)setupNavBar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_item"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleCickBackButton:)];
}

- (void)setupSubviews {
    TCImagePlayerView *imagePlayerView = [[TCImagePlayerView alloc] initWithFrame:CGRectMake(0, 0, TCScreenWidth, self.headerViewHeight)];
    self.tableView.tableHeaderView = imagePlayerView;
    
    [self.tableView registerClass:[TCCompanyIntroViewCell class] forCellReuseIdentifier:@"TCCompanyIntroViewCell"];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCCompanyIntroViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCCompanyIntroViewCell" forIndexPath:indexPath];
    cell.unfold = self.companyIntroUnfold;
    cell.companyInfo = self.userCompanyInfo.company;
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TCCompanyIntroViewCell tableView:tableView heightForRowAtIndexPath:indexPath withCompanyInfo:self.userCompanyInfo.company unfold:YES];
}

#pragma mark - TCCompanyIntroViewCellDelegate

- (void)companyIntroViewCell:(TCCompanyIntroViewCell *)cell didClickUnfoldButtonWithUnfold:(BOOL)unfold {
    self.companyIntroUnfold = !unfold;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Actions

- (void)handleCickBackButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
