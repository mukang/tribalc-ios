//
//  TCApartmentWithholdConfirmViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/3.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCApartmentWithholdConfirmViewCell.h"
#import <TCCommonLibs/TCCommonButton.h>

@interface TCApartmentWithholdConfirmViewCell ()

@property (weak, nonatomic) TCCommonButton *button;

@end

@implementation TCApartmentWithholdConfirmViewCell

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    TCCommonButton *button = [TCCommonButton buttonWithTitle:@"确认添加"
                                                      target:self
                                                      action:@selector(handleClickButton:)];
    [self.contentView addSubview:button];
    self.button = button;
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(315), 40));
        make.center.equalTo(self.contentView);
    }];
}

- (void)handleClickButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickConfirmButtonInApartmentWithholdConfirmViewCell:)]) {
        [self.delegate didClickConfirmButtonInApartmentWithholdConfirmViewCell:self];
    }
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    
    NSString *title = isEdit ? @"确认修改" : @"确认添加";
    NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:title
                                                                 attributes:@{
                                                                              NSFontAttributeName: [UIFont systemFontOfSize:16],
                                                                              NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                              }];
    [self.button setAttributedTitle:attStr forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
