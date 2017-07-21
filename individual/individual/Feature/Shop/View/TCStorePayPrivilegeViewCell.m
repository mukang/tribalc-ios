//
//  TCStorePayPrivilegeViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStorePayPrivilegeViewCell.h"
#import "TCPrivilege.h"

@interface TCStorePayPrivilegeViewCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *derateLabel;
@property (weak, nonatomic) UIImageView *selectedIcon;
@property (weak, nonatomic) UIImageView *circleIcon;

@end

@implementation TCStorePayPrivilegeViewCell

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
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCGrayColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *derateLabel = [[UILabel alloc] init];
    derateLabel.textColor = TCBlackColor;
    derateLabel.textAlignment = NSTextAlignmentRight;
    derateLabel.font = [UIFont systemFontOfSize:14];
    derateLabel.hidden = YES;
    [self.contentView addSubview:derateLabel];
    self.derateLabel = derateLabel;
    
    UIImageView *circleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_pay_circle"]];
    [self.contentView addSubview:circleIcon];
    self.circleIcon = circleIcon;
    
    UIImageView *selectedIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_pay_selected"]];
    selectedIcon.hidden = YES;
    [self.contentView addSubview:selectedIcon];
    self.selectedIcon = selectedIcon;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    [selectedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
    [circleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(selectedIcon);
    }];
    [derateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(circleIcon.mas_left).offset(-9);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setPrivilege:(TCPrivilege *)privilege {
    _privilege = privilege;
    
    switch (privilege.privilegeType) {
        case TCPrivilegeTypeDiscount:
            self.titleLabel.text = [NSString stringWithFormat:@"满%0.0f元%0.2f折", privilege.condition, privilege.value * 10];
            break;
        case TCPrivilegeTypeReduce:
            self.titleLabel.text = [NSString stringWithFormat:@"满%0.0f元减%0.0f元", privilege.condition, privilege.value];
            break;
        case TCPrivilegeTypeAliquot:
            self.titleLabel.text = [NSString stringWithFormat:@"每满%0.0f元减%0.0f元", privilege.condition, privilege.value];
            break;
            
        default:
            break;
    }
    
    if (privilege.selected) {
        self.titleLabel.textColor = TCBlackColor;
        self.derateLabel.text = [NSString stringWithFormat:@"-¥%0.2f", privilege.deductibleValue];
        self.derateLabel.hidden = (privilege.privilegeType == TCPrivilegeTypeDiscount);
        self.selectedIcon.hidden = NO;
    } else {
        self.titleLabel.textColor = TCGrayColor;
        self.derateLabel.hidden = YES;
        self.selectedIcon.hidden = YES;
    }
}

@end
