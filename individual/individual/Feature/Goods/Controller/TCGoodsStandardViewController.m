//
//  TCGoodsStandardViewController.m
//  individual
//
//  Created by 穆康 on 2017/9/5.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandardViewController.h"

#import "TCGoodsStandardHeaderView.h"
#import "TCGoodsStandardView.h"

#import "TCBuluoApi.h"

#import <TCCommonLibs/UIImage+Category.h>

static CGFloat const subviewHeight = 446;
static CGFloat const duration = 0.1;

@interface TCGoodsStandardViewController () <TCGoodsStandardUnitsViewDelegate>

/** 显示的时候是否有动画 */
@property (nonatomic) BOOL showAnimated;

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) TCGoodsStandardHeaderView *standardHeaderView;
@property (weak, nonatomic) TCGoodsStandardView *standardView;

@end

@implementation TCGoodsStandardViewController {
    __weak TCGoodsStandardViewController *weakSelf;
    __weak UIViewController *sourceController;
}

- (instancetype)initWithStandardViewMode:(TCGoodsStandardViewMode)mode fromController:(UIViewController *)controller {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _standardViewMode = mode;
        _quantity = 1;
        weakSelf = self;
        sourceController = controller;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"TCGoodsStandardViewController初始化错误"
                                   reason:@"请使用接口文件提供的初始化方法"
                                 userInfo:nil];
    return nil;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TCARGBColor(0, 0, 0, 0);
    [self setupSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.showAnimated) {
        [UIView animateWithDuration:duration animations:^{
            weakSelf.view.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
            weakSelf.containerView.y = TCScreenHeight - subviewHeight;
        }];
    } else {
        weakSelf.view.backgroundColor = TCARGBColor(0, 0, 0, 0.62);
        weakSelf.containerView.y = TCScreenHeight - subviewHeight;
    }
}

- (void)dealloc {
    TCLog(@"%s", __func__);
}

#pragma mark - Public Methods

- (void)show:(BOOL)animated {
    self.showAnimated = animated;
    
    sourceController.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [sourceController presentViewController:self animated:NO completion:nil];
}

- (void)dismiss:(BOOL)animated completion:(void (^)())completion {
    if (animated) {
        [UIView animateWithDuration:duration animations:^{
            weakSelf.view.backgroundColor = TCARGBColor(0, 0, 0, 0);
            weakSelf.containerView.y = TCScreenHeight;
        } completion:^(BOOL finished) {
            [weakSelf dismissViewControllerAnimated:NO completion:^{
                if (completion) {
                    completion();
                }
            }];
        }];
    } else {
        self.view.backgroundColor = TCARGBColor(0, 0, 0, 0);
        self.containerView.y = TCScreenHeight;
        [weakSelf dismissViewControllerAnimated:NO completion:^{
            if (completion) {
                completion();
            }
        }];
    }
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleClickCloseButton:)];
    [bgView addGestureRecognizer:tap];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.frame = CGRectMake(0, TCScreenHeight, TCScreenWidth, subviewHeight);
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    TCGoodsStandardHeaderView *standardHeaderView = [[TCGoodsStandardHeaderView alloc] init];
    [standardHeaderView.closeButton addTarget:self action:@selector(handleClickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:standardHeaderView];
    self.standardHeaderView = standardHeaderView;
    [self refreshStandardHeaderView];
    
    TCGoodsStandardView *standardView = [[TCGoodsStandardView alloc] initWithGoodsStandard:self.goodsStandard];
    standardView.primaryView.currentKey = self.primaryKey;
    standardView.secondaryView.currentKey = self.secondaryKey;
    if (self.primaryKey) {
        [standardView.primaryView reloadStandardDataWithAnotherKey:self.secondaryKey];
        [standardView.secondaryView reloadStandardDataWithAnotherKey:self.primaryKey];
    } else if (self.goodsStandard.descriptions.primary && !self.goodsStandard.descriptions.secondary) {
        [standardView.primaryView reloadStandardDataWithAnotherKey:nil];
    }
    standardView.primaryView.delegate = self;
    standardView.secondaryView.delegate = self;
    [standardView.quantityView.minusButton addTarget:self
                                              action:@selector(handleClickMinusButton:)
                                    forControlEvents:UIControlEventTouchUpInside];
    [standardView.quantityView.addButton addTarget:self
                                            action:@selector(handleClickAddButton:)
                                  forControlEvents:UIControlEventTouchUpInside];
    standardView.quantityView.quantity = self.quantity;
    
    [containerView addSubview:standardView];
    self.standardView = standardView;
    
    CGFloat bottomH = 49.0;
    [standardHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(containerView);
        make.height.mas_equalTo(115);
    }];
    [standardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(standardHeaderView.mas_bottom);
        make.left.right.equalTo(containerView);
        make.bottom.equalTo(containerView).offset(-bottomH);
    }];
    
    if (_standardViewMode == TCGoodsStandardViewModeConfirm) {
        UIButton *confirmButton = [self creatButtonWithTitle:@"确  定"
                                                 normalImage:[UIImage imageWithColor:TCRGBColor(113, 130, 220)]
                                            highlightedImage:[UIImage imageWithColor:TCRGBColor(90, 111, 220)]];
        [confirmButton addTarget:self
                          action:@selector(handleClickConfirmButton:)
                forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:confirmButton];
        
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(bottomH);
            make.left.right.bottom.equalTo(containerView);
        }];
        
    } else {
        UIButton *addShoppingCartButton = [self creatButtonWithTitle:@"加入购物车"
                                                         normalImage:[UIImage imageWithColor:TCRGBColor(151, 171, 234)]
                                                    highlightedImage:[UIImage imageWithColor:TCRGBColor(125, 151, 234)]];
        [addShoppingCartButton addTarget:self
                                  action:@selector(handleClickAddShoppingCartButton:)
                        forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:addShoppingCartButton];
        
        UIButton *buyButton = [self creatButtonWithTitle:@"立即购买"
                                             normalImage:[UIImage imageWithColor:TCRGBColor(113, 130, 220)]
                                        highlightedImage:[UIImage imageWithColor:TCRGBColor(90, 111, 220)]];
        [buyButton addTarget:self
                      action:@selector(handleClickBuyButton:)
            forControlEvents:UIControlEventTouchUpInside];
        [containerView addSubview:buyButton];
        
        [addShoppingCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(containerView);
            make.height.mas_equalTo(bottomH);
        }];
        [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(addShoppingCartButton);
            make.left.equalTo(addShoppingCartButton.mas_right);
            make.right.bottom.equalTo(containerView);
        }];
    }
}

- (UIButton *)creatButtonWithTitle:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    return button;
}

- (void)refreshStandardHeaderView {
    self.standardHeaderView.goodsDetail = self.goodsDetail;
    NSString *standardStr = nil;
    if (self.primaryKey) {
        if (self.secondaryKey) {
            standardStr = [NSString stringWithFormat:@"%@ %@", self.primaryKey, self.secondaryKey];
        } else {
            standardStr = self.primaryKey;
        }
    }
    self.standardHeaderView.standardStr = standardStr;
}

#pragma mark - TCGoodsStandardUnitsViewDelegate

- (void)goodsStandardUnitsView:(TCGoodsStandardUnitsView *)view didSelectUnitWithKey:(NSString *)key {
    NSString *standardKey = nil;
    if (view.unitsLevel == TCGoodsStandardUnitsLevelPrimary) {
        self.primaryKey = key;
        if (self.standardView.secondaryView) {
            standardKey = [NSString stringWithFormat:@"%@^%@", key, self.secondaryKey];
            [self.standardView.secondaryView reloadStandardDataWithAnotherKey:key];
        } else {
            standardKey = key;
        }
    } else {
        self.secondaryKey = key;
        standardKey = [NSString stringWithFormat:@"%@^%@", self.primaryKey, key];
        [self.standardView.primaryView reloadStandardDataWithAnotherKey:key];
    }
    
    TCGoodsDetail *goodsDetail = self.goodsStandard.goodsIndexes[standardKey];
    if (!goodsDetail) {
        return;
    }
    
    self.goodsDetail = goodsDetail;
    self.quantity = 1;
    self.standardView.quantityView.quantity = self.quantity;
    
    [self refreshStandardHeaderView];
    
    if ([self.delegate respondsToSelector:@selector(standardKeyDidChangeInGoodsStandardViewController:)]) {
        [self.delegate standardKeyDidChangeInGoodsStandardViewController:self];
    }
}

#pragma mark - Actions

- (void)handleClickCloseButton:(id)sender {
    [self dismiss:YES completion:nil];
}

- (void)handleClickMinusButton:(id)sender {
    self.quantity --;
    self.standardView.quantityView.quantity = self.quantity;
}

- (void)handleClickAddButton:(id)sender {
    if (self.goodsDetail.dailyLimit && (self.quantity >= (self.goodsDetail.dailyLimit - self.goodsDetail.dailySaled))) {
        [MBProgressHUD showHUDWithMessage:@"已超过商品每日限购数量"];
        return;
    }
    if (self.quantity >= self.goodsDetail.repertory) {
        [MBProgressHUD showHUDWithMessage:@"库存不足"];
        return;
    }
    
    self.quantity ++;
    self.standardView.quantityView.quantity = self.quantity;
}

- (void)handleClickConfirmButton:(id)sender {
    if (self.confirmType == TCGoodsStandardConfirmTypeAddShoppingCart) {
        [self handleAddShoppingCart];
    } else if (self.confirmType == TCGoodsStandardConfirmTypeBuyNow) {
        [self handleBuyNow];
    } else {
        [self handleModifyShoppingCart];
    }
}

- (void)handleClickAddShoppingCartButton:(id)sender {
    [self determineTheResidualAmount];
    [self handleAddShoppingCart];
}

- (void)handleClickBuyButton:(id)sender {
    [self determineTheResidualAmount];
    [self handleBuyNow];
}

- (void)handleAddShoppingCart {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] addToShoppingCartWithGoodsID:self.goodsDetail.ID quantity:self.quantity result:^(BOOL success, NSError *error) {
        if (success) {
            [MBProgressHUD showHUDWithMessage:@"添加到购物车成功"];
            [weakSelf dismiss:YES completion:nil];
        } else {
            NSString *message = error.localizedDescription ?: @"添加失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
        }
    }];
}

- (void)handleBuyNow {
    [self dismiss:YES completion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(buyNowInGoodsStandardViewController:)]) {
            [weakSelf.delegate buyNowInGoodsStandardViewController:self];
        }
    }];
}

- (void)determineTheResidualAmount {
    if (self.goodsDetail.dailyLimit && (self.quantity >= (self.goodsDetail.dailyLimit - self.goodsDetail.dailySaled))) {
        [MBProgressHUD showHUDWithMessage:@"已超过商品每日限购数量"];
        return;
    }
    if (self.quantity >= self.goodsDetail.repertory) {
        [MBProgressHUD showHUDWithMessage:@"库存不足"];
        return;
    }
}

- (void)handleModifyShoppingCart {
    [MBProgressHUD showHUD:YES];
    [[TCBuluoApi api] changeShoppingCartWithShoppingCartGoodsId:self.cartItemID AndNewGoodsId:self.goodsDetail.ID AndAmount:self.quantity result:^(TCCartItem *cartItem, NSError *error) {
        if (cartItem) {
            [MBProgressHUD showHUDWithMessage:@"修改成功"];
            [self dismiss:YES completion:^{
                if ([weakSelf.delegate respondsToSelector:@selector(didModifyShoppingCartInGoodsStandardViewController:)]) {
                    [weakSelf.delegate didModifyShoppingCartInGoodsStandardViewController:self];
                }
            }];
        } else {
            NSString *message = error.localizedDescription ?: @"修改失败，请稍后再试";
            [MBProgressHUD showHUDWithMessage:message];
        }
    }];
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
