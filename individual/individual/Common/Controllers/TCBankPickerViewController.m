//
//  TCBankPickerViewController.m
//  individual
//
//  Created by 穆康 on 2017/7/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCBankPickerViewController.h"

#import <TCCommonLibs/TCExtendButton.h>

#import "TCBankCard.h"

static CGFloat const subviewHeight = 240;
static CGFloat const duration = 0.25;

@interface TCBankPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

/** 显示的时候是否有动画 */
@property (nonatomic) BOOL showAnimated;

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIPickerView *pickerView;

@end

@implementation TCBankPickerViewController {
    __weak TCBankPickerViewController *weakSelf;
    __weak UIViewController *sourceController;
}

- (instancetype)initWithBankPickerType:(TCBankPickerType)type fromController:(UIViewController *)controller {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _bankPikerType = type;
        weakSelf = self;
        sourceController = controller;
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"TCBankPickerViewController初始化错误"
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
    
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [containerView addSubview:pickerView];
    self.pickerView = pickerView;
    
    TCExtendButton *cancelButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"取消"
                                                                     attributes:@{
                                                                                  NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                  NSForegroundColorAttributeName: TCRGBColor(81, 199, 209)
                                                                                  }]
                            forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(handleClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.hitTestSlop = UIEdgeInsetsMake(0, -20, 0, -20);
    [containerView addSubview:cancelButton];
    
    TCExtendButton *confirmButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [confirmButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"确定"
                                                                      attributes:@{
                                                                                   NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                                   NSForegroundColorAttributeName: TCRGBColor(81, 199, 209)
                                                                                   }]
                             forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(handleClickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.hitTestSlop = UIEdgeInsetsMake(0, -20, 0, -20);
    [containerView addSubview:confirmButton];
    
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView).offset(40);
        make.left.bottom.right.equalTo(containerView);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView);
        make.left.equalTo(containerView).offset(20);
        make.bottom.equalTo(pickerView.mas_top);
    }];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(containerView);
        make.right.equalTo(containerView).offset(-20);
        make.bottom.equalTo(pickerView.mas_top);
    }];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.banks.count;
}

#pragma mark - UIPickerViewDelegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    TCBankCard *bankCard = self.banks[row];
    NSString *title = bankCard.bankName;
    return [[NSAttributedString alloc] initWithString:title attributes:@{
                                                                         NSFontAttributeName : [UIFont systemFontOfSize:14]
                                                                         }];
}

#pragma mark - Get Current Info

- (TCBankCard *)getCurrentSelectedInfo {
    NSInteger currentIndex = [self.pickerView selectedRowInComponent:0];
    return self.banks[currentIndex];
}

#pragma mark - Actions

- (void)handleClickCancelButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonInBankPickerViewController:)]) {
        [self.delegate didClickCancelButtonInBankPickerViewController:self];
    }
    [self dismiss:YES completion:nil];
}

- (void)handleClickConfirmButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(bankPickerViewController:didClickConfirmButtonWithBankCard:)]) {
        TCBankCard *bankCard = [self getCurrentSelectedInfo];
        [self.delegate bankPickerViewController:self didClickConfirmButtonWithBankCard:bankCard];
    }
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
