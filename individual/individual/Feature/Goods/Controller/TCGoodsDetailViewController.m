//
//  TCGoodsDetailViewController.m
//  individual
//
//  Created by 穆康 on 2017/9/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsDetailViewController.h"

#import "TCGoodsPicturesView.h"
#import "TCGoodsTitleViewCell.h"
#import "TCGoodsStoreInfoViewCell.h"
#import "TCGoodsDetailInfoViewCell.h"
#import "TCGoodsStandardSelectViewCell.h"
#import "TCGoodsToolsBar.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/UIImage+Category.h>
#import <UITableView+FDTemplateLayoutCell.h>

#define headerViewH TCScreenWidth

@interface TCGoodsDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCGoodsPicturesView *picturesView;

@property (strong, nonatomic) TCGoodsDetail *goodsDetail;
@property (strong, nonatomic) TCGoodsStandard *goodsStandard;

@end

@implementation TCGoodsDetailViewController {
    __weak TCGoodsDetailViewController *weakSelf;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    weakSelf = self;
    self.hideOriginalNavBar = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupSubviews];
    [self loadNetData];
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageWithColor:TCRGBColor(57, 57, 57)] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"nav_back_item_white"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(handleClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    backButton.layer.cornerRadius = 13.75;
    backButton.layer.masksToBounds = YES;
    [self.view addSubview:backButton];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.backgroundColor = TCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(headerViewH, 0, 0, 0);
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCGoodsTitleViewCell class] forCellReuseIdentifier:@"TCGoodsTitleViewCell"];
    [tableView registerClass:[TCGoodsStoreInfoViewCell class] forCellReuseIdentifier:@"TCGoodsStoreInfoViewCell"];
    [tableView registerClass:[TCGoodsDetailInfoViewCell class] forCellReuseIdentifier:@"TCGoodsDetailInfoViewCell"];
    [tableView registerClass:[TCGoodsStandardSelectViewCell class] forCellReuseIdentifier:@"TCGoodsStandardSelectViewCell"];
    [tableView setContentOffset:CGPointMake(0, -headerViewH) animated:NO];
    [self.view insertSubview:tableView belowSubview:backButton];
    self.tableView = tableView;
    
    TCGoodsPicturesView *picturesView = [[TCGoodsPicturesView alloc] init];
    [tableView addSubview:picturesView];
    self.picturesView = picturesView;
    
    
    TCGoodsToolsBar *toolsBar = [[TCGoodsToolsBar alloc] init];
    [toolsBar.shoppingCartButton addTarget:self
                                    action:@selector(handleClickShoppingCartButton:)
                          forControlEvents:UIControlEventTouchUpInside];
    [toolsBar.addShoppingCartButton addTarget:self
                                       action:@selector(handleClickAddShoppingCartButton:)
                             forControlEvents:UIControlEventTouchUpInside];
    [toolsBar.buyButton addTarget:self
                           action:@selector(handleClickBuyButton:)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toolsBar];
    
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(27.5, 27.5));
        make.left.equalTo(self.view).offset(13);
        make.top.equalTo(self.view).offset(30);
    }];
    [toolsBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(toolsBar.mas_top);
    }];
    [picturesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(tableView);
        make.top.equalTo(tableView).offset(-headerViewH);
        make.height.mas_equalTo(headerViewH);
    }];
}

- (void)loadNetData {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] fetchGoodsDetail:self.goodsID result:^(TCGoodsDetail *goodsDetail, NSError *error) {
        if (goodsDetail) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.goodsDetail = goodsDetail;
            weakSelf.picturesView.pictures = goodsDetail.pictures;
            [weakSelf.tableView reloadData];
        } else {
            NSString *message = error.localizedDescription ? : @"获取数据失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
        }
    }];
}

- (void)updateHeaderView {
    CGFloat offsetY = self.tableView.contentOffset.y;
    if (offsetY > 0) return;
    if (offsetY > -headerViewH) {
        offsetY = -headerViewH;
    }
    
    [self.picturesView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView).offset(offsetY);
        make.height.mas_equalTo(-offsetY);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.goodsDetail.detail.count) {
        return 4;
    } else {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *currentCell;
    switch (indexPath.section) {
        case 0:
        {
            TCGoodsTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsTitleViewCell" forIndexPath:indexPath];
            cell.goodsDetail = self.goodsDetail;
            currentCell = cell;
        }
            break;
        case 1:
        {
            TCGoodsStandardSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsStandardSelectViewCell" forIndexPath:indexPath];
            currentCell = cell;
        }
            break;
        case 2:
        {
            TCGoodsStoreInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsStoreInfoViewCell" forIndexPath:indexPath];
            cell.goodsDetail = self.goodsDetail;
            currentCell = cell;
        }
            break;
        case 3:
        {
            TCGoodsDetailInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCGoodsDetailInfoViewCell" forIndexPath:indexPath];
            cell.detailPictures = self.goodsDetail.detail;
            currentCell = cell;
        }
            break;
            
        default:
            break;
    }
    return currentCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [tableView fd_heightForCellWithIdentifier:@"TCGoodsTitleViewCell" configuration:^(TCGoodsTitleViewCell *cell) {
                cell.goodsDetail = self.goodsDetail;
            }];
            break;
        case 1:
            return 38;
            break;
        case 2:
            return 64;
            break;
        case 3:
            return [tableView fd_heightForCellWithIdentifier:@"TCGoodsDetailInfoViewCell" configuration:^(TCGoodsDetailInfoViewCell *cell) {
                cell.detailPictures = self.goodsDetail.detail;
            }];
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 7.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
}

#pragma mark - Actions

- (void)handleClickShoppingCartButton:(id)sender {
    
}

- (void)handleClickAddShoppingCartButton:(id)sender {
    
}

- (void)handleClickBuyButton:(id)sender {
    
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
