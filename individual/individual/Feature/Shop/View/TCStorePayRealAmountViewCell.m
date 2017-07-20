//
//  TCStorePayRealAmountViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStorePayRealAmountViewCell.h"

@interface TCStorePayRealAmountViewCell ()

@property (weak, nonatomic) UILabel *amountLabel;

@end

@implementation TCStorePayRealAmountViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"实付金额：";
    titleLabel.textColor = TCBlackColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    
    UILabel *symbolLable = [[UILabel alloc] init];
    symbolLable.text = @"¥";
    symbolLable.textColor = [UIColor redColor];
    symbolLable.textAlignment = NSTextAlignmentRight;
    symbolLable.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:symbolLable];
    
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.textColor = [UIColor redColor];
    amountLabel.textAlignment = NSTextAlignmentRight;
    amountLabel.font = [UIFont systemFontOfSize:22.5];
    [self.contentView addSubview:amountLabel];
    self.amountLabel = amountLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    [symbolLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(amountLabel.mas_left).offset(-2);
        make.bottom.equalTo(amountLabel);
    }];
}

- (void)setRealAmount:(double)realAmount {
    _realAmount = realAmount;
    
    self.amountLabel.text = [NSString stringWithFormat:@"%0.2f", realAmount];
}

@end
