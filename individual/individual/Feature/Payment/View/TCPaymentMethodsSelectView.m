//
//  TCPaymentMethodsSelectView.m
//  individual
//
//  Created by 穆康 on 2017/9/21.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPaymentMethodsSelectView.h"
#import "TCPaymentMethodViewCell.h"
#import "TCPaymentAddBankCardViewCell.h"

#import <TCCommonLibs/TCExtendButton.h>

@interface TCPaymentMethodsSelectView () <UITableViewDataSource, UITableViewDelegate>

@property (copy, nonatomic) NSArray *methodModels;
@property (strong, nonatomic) TCPaymentMethodModel *currentMethodModel;
@property (nonatomic) TCBackButtonStyle backButtonStyle;

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) TCExtendButton *backButton;
@property (weak, nonatomic) UIView *separatorView;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCPaymentMethodsSelectView

- (instancetype)initWithPaymentMethodModels:(NSArray *)methodModels backButtonStyle:(TCBackButtonStyle)backButtonStyle {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _methodModels = methodModels;
        _backButtonStyle = backButtonStyle;
        for (TCPaymentMethodModel *model in methodModels) {
            if (model.isSelected) {
                _currentMethodModel = model;
                break;
            }
        }
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择付款方式";
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:titleLabel];
    
    TCExtendButton *backButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    if (_backButtonStyle == TCBackButtonStyleLeftArrow) {
        [backButton setImage:[UIImage imageNamed:@"payment_arrow_left"] forState:UIControlStateNormal];
    } else {
        [backButton setImage:[UIImage imageNamed:@"payment_close_button"] forState:UIControlStateNormal];
    }
    [backButton addTarget:self action:@selector(handleClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    backButton.hitTestSlop = UIEdgeInsetsMake(-20, -20, -20, -20);
    [self addSubview:backButton];
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TCSeparatorLineColor;
    [self addSubview:separatorView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = 50;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[TCPaymentMethodViewCell class] forCellReuseIdentifier:@"TCPaymentMethodViewCell"];
    [tableView registerClass:[TCPaymentAddBankCardViewCell class] forCellReuseIdentifier:@"TCPaymentAddBankCardViewCell"];
    [self addSubview:tableView];
    
    self.titleLabel = titleLabel;
    self.backButton = backButton;
    self.separatorView = separatorView;
    self.tableView = tableView;
}

- (void)setupConstraints {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_top).offset(31);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(62);
        make.height.mas_equalTo(0.5);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.separatorView.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hideAddBankCardItem) {
        return self.methodModels.count;
    } else {
        return self.methodModels.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.methodModels.count) {
        TCPaymentAddBankCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCPaymentAddBankCardViewCell" forIndexPath:indexPath];
        return cell;
    } else {
        TCPaymentMethodViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCPaymentMethodViewCell" forIndexPath:indexPath];
        cell.methodModel = self.methodModels[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.methodModels.count) {
        if ([self.delegate respondsToSelector:@selector(didClickAddBankCardInPaymentMethodsSelectView:)]) {
            [self.delegate didClickAddBankCardInPaymentMethodsSelectView:self];
        }
    } else {
        TCPaymentMethodModel *model = self.methodModels[indexPath.row];
        if (model.isInvalid) {
            return;
        }
        if (![self.currentMethodModel isEqual:model]) {
            model.selected = YES;
            self.currentMethodModel.selected = NO;
            self.currentMethodModel = model;
            [tableView reloadData];
        }
        if ([self.delegate respondsToSelector:@selector(paymentMethodsSelectView:didSlectedMethod:)]) {
            [self.delegate paymentMethodsSelectView:self didSlectedMethod:model];
        }
    }
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickBackButtonInPaymentMethodsSelectView:)]) {
        [self.delegate didClickBackButtonInPaymentMethodsSelectView:self];
    }
}

@end

