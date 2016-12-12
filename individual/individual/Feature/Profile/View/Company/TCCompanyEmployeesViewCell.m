//
//  TCCompanyEmployeesViewCell.m
//  individual
//
//  Created by 穆康 on 2016/12/12.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCCompanyEmployeesViewCell.h"

@implementation TCCompanyEmployeesViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
//    self.contentView.backgroundColor = 
}

@end
