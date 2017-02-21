//
//  TCPaymentMethodView.m
//  individual
//
//  Created by 穆康 on 2017/1/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPaymentMethodView.h"
#import "TCExtendButton.h"
#import "TCPaymentMethodViewCell.h"

@interface TCPaymentMethodView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) TCExtendButton *backButton;
@property (weak, nonatomic) UIView *separatorView;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCPaymentMethodView

- (instancetype)initWithPaymentMethod:(TCPaymentMethod)paymentMethod {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _paymentMethod = paymentMethod;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"选择付款方式";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = TCRGBColor(42, 42, 42);
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:titleLabel];
    
    TCExtendButton *backButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"payment_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(handleClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    backButton.hitTestSlop = UIEdgeInsetsMake(-20, -20, -20, -20);
    [self addSubview:backButton];
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TCRGBColor(221, 221, 221);
    [self addSubview:separatorView];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorColor = TCRGBColor(221, 221, 221);
    tableView.rowHeight = 50;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[TCPaymentMethodViewCell class] forCellReuseIdentifier:@"TCPaymentMethodViewCell"];
    [self addSubview:tableView];
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.paymentMethod inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    self.titleLabel = titleLabel;
    self.backButton = backButton;
    self.separatorView = separatorView;
    self.tableView = tableView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 21));
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.centerY.equalTo(weakSelf.mas_top).with.offset(31);
    }];
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(7, 22));
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
        make.centerY.equalTo(weakSelf.titleLabel.mas_centerY);
    }];
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf.mas_top).with.offset(62);
        make.height.mas_equalTo(0.5);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.separatorView.mas_bottom);
        make.left.bottom.right.equalTo(weakSelf);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCPaymentMethodViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCPaymentMethodViewCell" forIndexPath:indexPath];
    switch (indexPath.row) {
        case TCPaymentMethodBalance:
            cell.logoImageView.image = [UIImage imageNamed:@"balance_icon"];
            cell.titleLabel.text = @"余额支付";
            break;
        case TCPaymentMethodWechat:
            cell.logoImageView.image = [UIImage imageNamed:@"wechat_icon"];
            cell.titleLabel.text = @"微信支付";
            break;
        case TCPaymentMethodAlipay:
            cell.logoImageView.image = [UIImage imageNamed:@"alipay_icon"];
            cell.titleLabel.text = @"支付宝支付";
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(paymentMethodView:didSlectedPaymentMethod:)]) {
        [self.delegate paymentMethodView:self didSlectedPaymentMethod:indexPath.row];
    }
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickBackButtonInPaymentMethodView:)]) {
        [self.delegate didClickBackButtonInPaymentMethodView:self];
    }
}

@end
