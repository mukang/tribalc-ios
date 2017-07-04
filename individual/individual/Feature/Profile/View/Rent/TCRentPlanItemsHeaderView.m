//
//  TCRentPlanItemsHeaderView.m
//  individual
//
//  Created by 穆康 on 2017/7/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRentPlanItemsHeaderView.h"
#import "TCRentProtocol.h"

@interface TCRentPlanItemsHeaderView ()

@property (weak, nonatomic) UILabel *numLabel;
@property (weak, nonatomic) UILabel *apartmentLabel;

@end

@implementation TCRentPlanItemsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *separaterLine = [[UIView alloc] init];
    separaterLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:separaterLine];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.textColor = TCGrayColor;
    numLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:numLabel];
    self.numLabel = numLabel;
    
    UILabel *apartmentLabel = [[UILabel alloc] init];
    apartmentLabel.textColor = TCBlackColor;
    apartmentLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:apartmentLabel];
    self.apartmentLabel = apartmentLabel;
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self.mas_top).offset(14.5);
    }];
    [apartmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.centerY.equalTo(self.mas_bottom).offset(-21);
    }];
    [separaterLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self.mas_top).offset(29);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setRentProtocol:(TCRentProtocol *)rentProtocol {
    _rentProtocol = rentProtocol;
    
    self.numLabel.text = [NSString stringWithFormat:@"编号：%@", rentProtocol.sourceNum];
    self.apartmentLabel.text = [NSString stringWithFormat:@"公寓：%@", rentProtocol.sourceName];
}

@end
