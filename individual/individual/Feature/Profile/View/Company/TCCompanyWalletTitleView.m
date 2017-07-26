//
//  TCCompanyWalletTitleView.m
//  individual
//
//  Created by 穆康 on 2017/7/26.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCompanyWalletTitleView.h"

@implementation TCCompanyWalletTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = TCRGBColor(47, 50, 69);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = TCRGBColor(226, 177, 117);
    nameLabel.font = [UIFont systemFontOfSize:11];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    TCExtendButton *closeButton = [TCExtendButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"company_title_close_button"] forState:UIControlStateNormal];
    closeButton.hitTestSlop = UIEdgeInsetsMake(-5, -10, -5, -10);
    [self addSubview:closeButton];
    self.closeButton = closeButton;
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(closeButton.mas_left).offset(-10);
        make.centerY.equalTo(self);
    }];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12.5, 12.5));
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(self);
    }];
}

@end
