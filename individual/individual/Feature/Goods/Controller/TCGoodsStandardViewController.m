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
    [standardView.primaryView reloadStandardDataWithAnotherKey:self.secondaryKey];
    [standardView.secondaryView reloadStandardDataWithAnotherKey:self.primaryKey];
    standardView.primaryView.delegate = self;
    standardView.secondaryView.delegate = self;
    [containerView addSubview:standardView];
    self.standardView = standardView;
    
    [standardHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(containerView);
        make.height.mas_equalTo(115);
    }];
    [standardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(standardHeaderView.mas_bottom);
        make.left.right.bottom.equalTo(containerView);
    }];
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
    self.goodsDetail = self.goodsStandard.goodsIndexes[standardKey];
    
    [self refreshStandardHeaderView];
    
    if ([self.delegate respondsToSelector:@selector(standardKeyDidChangeInGoodsStandardViewController:)]) {
        [self.delegate standardKeyDidChangeInGoodsStandardViewController:self];
    }
}

#pragma mark - Actions

- (void)handleClickCloseButton:(id)sender {
    [self dismiss:YES completion:nil];
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
