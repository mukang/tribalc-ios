//
//  TCGoodsDetailViewController.m
//  individual
//
//  Created by 穆康 on 2017/9/1.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsDetailViewController.h"
#import "TCGoodsStandardViewController.h"
#import "TCPlaceOrderViewController.h"
#import "TCShoppingCartViewController.h"

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

@interface TCGoodsDetailViewController () <UITableViewDataSource, UITableViewDelegate, TCGoodsStandardViewControllerDelegate>

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) TCGoodsPicturesView *picturesView;

@property (strong, nonatomic) TCGoodsStandard *goodsStandard;

/** 一级规格 */
@property (copy, nonatomic) NSString *primaryKey;
/** 二级规格 */
@property (copy, nonatomic) NSString *secondaryKey;

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
    picturesView.pictures = @[self.goodsDetail.mainPicture];
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
            weakSelf.goodsDetail = goodsDetail;
            if (goodsDetail.standardId) {
                [weakSelf loadGoodsStandardWithStandardID:goodsDetail.standardId];
            } else {
                [MBProgressHUD hideHUD:YES];
                [weakSelf refreshData];
            }
        } else {
            NSString *message = error.localizedDescription ? : @"获取数据失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
        }
    }];
}

- (void)loadGoodsStandardWithStandardID:(NSString *)standardID {
    [[TCBuluoApi api] fetchGoodsStandard:standardID result:^(TCGoodsStandard *goodsStandard, NSError *error) {
        if (goodsStandard) {
            [MBProgressHUD hideHUD:YES];
            weakSelf.goodsStandard = goodsStandard;
            NSDictionary *goodsIndexes = goodsStandard.goodsIndexes;
            for (NSString *key in goodsIndexes.allKeys) {
                TCGoodsDetail *goodsDetail = goodsIndexes[key];
                if ([goodsDetail.ID isEqualToString:self.goodsDetail.ID]) {
                    if (goodsStandard.descriptions.secondary) {
                        NSArray *tempArray = [key componentsSeparatedByString:@"^"];
                        weakSelf.primaryKey = [tempArray firstObject];
                        weakSelf.secondaryKey = [tempArray lastObject];
                    } else {
                        weakSelf.primaryKey = key;
                    }
                    break;
                }
            }
            [weakSelf refreshData];
        } else {
            NSString *message = error.localizedDescription ? : @"获取数据失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
        }
    }];
}

/** 刷新数据 */
- (void)refreshData {
    self.picturesView.pictures = self.goodsDetail.pictures;
    [self.tableView reloadData];
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
            if (self.primaryKey) {
                if (self.secondaryKey) {
                    cell.textLabel.text = [NSString stringWithFormat:@"已选:\"%@\" \"%@\"", self.primaryKey, self.secondaryKey];
                } else {
                    cell.textLabel.text = [NSString stringWithFormat:@"已选:\"%@\"", self.primaryKey];
                }
            } else {
                cell.textLabel.text = @"请选择规格和数量";
            }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self showGoodsStandardViewWithMode:TCGoodsStandardViewModeSelect comfirmType:0];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
}

#pragma mark - TCGoodsStandardViewControllerDelegate

- (void)standardKeyDidChangeInGoodsStandardViewController:(TCGoodsStandardViewController *)controller {
    self.primaryKey = controller.primaryKey;
    self.secondaryKey = controller.secondaryKey;
    self.goodsDetail = controller.goodsDetail;
    [self refreshData];
}

- (void)buyNowInGoodsStandardViewController:(TCGoodsStandardViewController *)controller {
    TCGoods *goods = [[TCGoods alloc] init];
    goods.ID = self.goodsDetail.ID;
    goods.storeId = self.goodsDetail.storeId;
    goods.name = self.goodsDetail.name;
    goods.brand = self.goodsDetail.brand;
    goods.mainPicture = self.goodsDetail.mainPicture;
    goods.salePrice = self.goodsDetail.salePrice;
    goods.expressFee = self.goodsDetail.expressFee;
    
    TCCartItem *cartItem = [[TCCartItem alloc] init];
    cartItem.amount = controller.quantity;
    cartItem.standardId = self.goodsDetail.standardId;
    cartItem.repertory = self.goodsDetail.repertory;
    cartItem.goods = goods;
    
    TCListShoppingCart *shoppingCart = [[TCListShoppingCart alloc] init];
    shoppingCart.goodsList = @[cartItem];
    shoppingCart.store = self.goodsDetail.tMarkStore;
    
    TCPlaceOrderViewController *vc = [[TCPlaceOrderViewController alloc] initWithListShoppingCartArr:@[shoppingCart] type:TCPlaceOrderTypeBuyDirect];
    vc.fromController = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (void)handleClickShoppingCartButton:(id)sender {
    TCShoppingCartViewController *vc = [[TCShoppingCartViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)handleClickAddShoppingCartButton:(id)sender {
    [self showGoodsStandardViewWithMode:TCGoodsStandardViewModeConfirm comfirmType:TCGoodsStandardConfirmTypeAddShoppingCart];
}

- (void)handleClickBuyButton:(id)sender {
    [self showGoodsStandardViewWithMode:TCGoodsStandardViewModeConfirm comfirmType:TCGoodsStandardConfirmTypeBuyNow];
}

- (void)showGoodsStandardViewWithMode:(TCGoodsStandardViewMode)mode comfirmType:(TCGoodsStandardConfirmType)confirmType {
    TCGoodsStandardViewController *vc = [[TCGoodsStandardViewController alloc] initWithStandardViewMode:mode fromController:self];
    vc.primaryKey = self.primaryKey;
    vc.secondaryKey = self.secondaryKey;
    vc.goodsStandard = self.goodsStandard;
    vc.goodsDetail = self.goodsDetail;
    vc.confirmType = confirmType;
    vc.delegate = self;
    [vc show:YES];
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
