//
//  TCRechargeMethodsView.m
//  individual
//
//  Created by 穆康 on 2016/12/29.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRechargeMethodsView.h"
#import "TCRechargeMethodViewCell.h"
#import "TCRechargeAddBankCardViewCell.h"

#import "TCBuluoApi.h"

@interface TCRechargeMethodsView () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UILabel *methodLabel;
@property (weak, nonatomic) UIView *topSeparatorView;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation TCRechargeMethodsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

#pragma mark - Private Methods

- (void)setupSubviews {
    UILabel *methodLabel = [[UILabel alloc] init];
    methodLabel.text = @"充值方式";
    methodLabel.textAlignment = NSTextAlignmentLeft;
    methodLabel.textColor = TCGrayColor;
    methodLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:methodLabel];
    
    UIView *topSeparatorView = [[UIView alloc] init];
    topSeparatorView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topSeparatorView];
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = [UIColor whiteColor];
    tableView.rowHeight = 40;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[TCRechargeMethodViewCell class] forCellReuseIdentifier:@"TCRechargeMethodViewCell"];
    [tableView registerClass:[TCRechargeAddBankCardViewCell class] forCellReuseIdentifier:@"TCRechargeAddBankCardViewCell"];
    [self addSubview:tableView];
    
    self.methodLabel = methodLabel;
    self.topSeparatorView = topSeparatorView;
    self.tableView = tableView;
}

- (void)setupConstraints {
    __weak typeof(self) weakSelf = self;
    
    [self.methodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 14));
        make.top.equalTo(weakSelf.mas_top);
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
    }];
    [self.topSeparatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).with.offset(36);
        make.left.equalTo(weakSelf.mas_left).with.offset(20);
        make.right.equalTo(weakSelf.mas_right).with.offset(-20);
        make.height.mas_equalTo(0.5);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.topSeparatorView.mas_bottom);
        make.left.right.bottom.equalTo(weakSelf);
    }];
}

#pragma mark - Public Methods

- (void)reloadBankCardList {
    [self.tableView reloadData];
    
    if (!self.bankCardList.count) return;
    
    for (int i=0; i<self.bankCardList.count; i++) {
        TCBankCard *bankCard = self.bankCardList[i];
        if (bankCard == TCBankCardTypeNormal) {
            self.currentBankCard = self.bankCardList[i];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                                        animated:NO
                                  scrollPosition:UITableViewScrollPositionNone];
            break;
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankCardList.count ?: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bankCardList.count) {
        TCRechargeMethodViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRechargeMethodViewCell" forIndexPath:indexPath];
        cell.isBankCardMode = YES;
        cell.bankCard = self.bankCardList[indexPath.row];
        return cell;
    } else {
        TCRechargeAddBankCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TCRechargeAddBankCardViewCell" forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bankCardList.count) {
        TCBankCard *bankCard = self.bankCardList[indexPath.row];
        if (bankCard.type == TCBankCardTypeNormal) {
            self.currentBankCard = bankCard;
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(didSelectedAddBankCardInRechargeMethodsView:)]) {
            [self.delegate didSelectedAddBankCardInRechargeMethodsView:self];
        }
    }
}

#pragma mark - Override Methods

/*
- (void)setBankCardList:(NSArray *)bankCardList {
    _bankCardList = bankCardList;
    
    if (!bankCardList.count) return;
    
    NSString *defaultBankCardID = [[TCBuluoApi api] currentUserSession].userInfo.defaultBankCardID;
    BOOL hasDefaultBank = NO;
    if (defaultBankCardID) {
        for (int i=0; i<self.bankCardList.count; i++) {
            TCBankCard *bankCard = self.bankCardList[i];
            if ([bankCard.ID isEqualToString:defaultBankCardID]) {
                hasDefaultBank = YES;
                self.currentBankCard = bankCard;
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                                            animated:NO
                                      scrollPosition:UITableViewScrollPositionNone];
                break;
            }
        }
    }
    if (hasDefaultBank == NO) {
        self.currentBankCard = self.bankCardList[0];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
    }
}
 */

@end
