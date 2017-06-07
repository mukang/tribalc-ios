//
//  TCPaymentMethodView.m
//  individual
//
//  Created by 穆康 on 2017/1/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPaymentMethodView.h"
#import "TCPaymentMethodViewCell.h"

#import "TCBankCard.h"

#import <TCCommonLibs/TCExtendButton.h>

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
    titleLabel.textColor = TCBlackColor;
    titleLabel.font = [UIFont systemFontOfSize:17];
    [self addSubview:titleLabel];
    
    TCExtendButton *backButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"payment_arrow_left"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(handleClickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    backButton.hitTestSlop = UIEdgeInsetsMake(-20, -20, -20, -20);
    [self addSubview:backButton];
    
    UIView *separatorView = [[UIView alloc] init];
    separatorView.backgroundColor = TCSeparatorLineColor;
    [self addSubview:separatorView];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorColor = TCSeparatorLineColor;
    tableView.rowHeight = 50;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[TCPaymentMethodViewCell class] forCellReuseIdentifier:@"TCPaymentMethodViewCell"];
    [self addSubview:tableView];
    if (self.paymentMethod != TCPaymentMethodBankCard) {
        [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.paymentMethod]
                               animated:NO
                         scrollPosition:UITableViewScrollPositionNone];
    }
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.bankCardList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCPaymentMethodViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCPaymentMethodViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.logoImageView.image = [UIImage imageNamed:@"balance_icon"];
        cell.titleLabel.text = @"余额支付";
    } else {
        TCBankCard *bankCard = self.bankCardList[indexPath.row];
        NSString *bankCardNum = bankCard.bankCardNum;
        NSString *lastNum;
        if (bankCardNum.length >= 4) {
            lastNum = [bankCardNum substringFromIndex:(bankCardNum.length - 4)];
        }
        cell.logoImageView.image = [UIImage imageNamed:bankCard.logo];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@储蓄卡(%@)", bankCard.bankName, lastNum];
    }
    /*
    switch (indexPath.section) {
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
     */
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(paymentMethodView:didSlectedPaymentMethod:)]) {
        if (indexPath.section == TCPaymentMethodBankCard) {
            self.currentBankCard = self.bankCardList[indexPath.row];
        }
        [self.delegate paymentMethodView:self didSlectedPaymentMethod:indexPath.section];
    }
}

#pragma mark - Actions

- (void)handleClickBackButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickBackButtonInPaymentMethodView:)]) {
        [self.delegate didClickBackButtonInPaymentMethodView:self];
    }
}

#pragma mark - Override Methods

- (void)setBankCardList:(NSArray *)bankCardList {
    _bankCardList = bankCardList;
    
    if (self.paymentMethod != TCPaymentMethodBankCard) return;
    if (self.bankCardList.count == 0) return;
    
    for (int i=0; i<bankCardList.count; i++) {
        TCBankCard *bankCard = bankCardList[i];
        if ([bankCard.ID isEqualToString:self.currentBankCard.ID]) {
            self.currentBankCard = bankCard;
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:self.paymentMethod]
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
            break;
        }
    }
}

@end
