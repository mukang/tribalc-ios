//
//  TCGoodsStandardSelectViewCell.m
//  individual
//
//  Created by 穆康 on 2017/9/5.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandardSelectViewCell.h"

@implementation TCGoodsStandardSelectViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.textLabel.text = @"请选择规格和数量";
    self.textLabel.textColor = TCBlackColor;
    self.textLabel.font = [UIFont systemFontOfSize:14];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.x = 20;
}

@end
