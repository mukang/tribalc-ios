//
//  TCStorePayViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStorePayViewCell.h"
#import <TCCommonLibs/TCCommonButton.h>

@implementation TCStorePayViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    TCCommonButton *payButton = [TCCommonButton buttonWithTitle:@"买  单"
                                                          color:TCCommonButtonColorPurple
                                                         target:self
                                                         action:@selector(handleClickPayButton:)];
    [self.contentView addSubview:payButton];
    
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(315), 40));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(20);
    }];
}

- (void)handleClickPayButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickPayButtonInStorePayViewCell:)]) {
        [self.delegate didClickPayButtonInStorePayViewCell:self];
    }
}

@end
