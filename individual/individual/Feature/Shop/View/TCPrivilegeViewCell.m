//
//  TCPrivilegeViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/20.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPrivilegeViewCell.h"
#import "TCPrivilege.h"

@interface TCPrivilegeViewCell ()

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *validLabel;

@end

@implementation TCPrivilegeViewCell

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
    titleLabel.textColor = TCBlackColor;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *validLabel = [[UILabel alloc] init];
    validLabel.textColor = TCGrayColor;
    validLabel.textAlignment = NSTextAlignmentRight;
    validLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:validLabel];
    self.validLabel = validLabel;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView);
    }];
    [validLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(self.contentView);
    }];
}

- (void)setPrivilege:(TCPrivilege *)privilege {
    _privilege = privilege;
    
    NSNumber *conditionNumber = [NSNumber numberWithDouble:privilege.condition];
    NSNumber *valueNumber = [NSNumber numberWithDouble:privilege.value];
    
    switch (privilege.privilegeType) {
        case TCPrivilegeTypeDiscount:
        {
            NSNumber *tempNumber = [NSNumber numberWithDouble:(privilege.value * 10)];
            if (privilege.condition) {
                self.titleLabel.text = [NSString stringWithFormat:@"满%@元%@折", conditionNumber, tempNumber];
            } else {
                self.titleLabel.text = [NSString stringWithFormat:@"优惠%@折", tempNumber];
            }
        }
            break;
        case TCPrivilegeTypeReduce:
            self.titleLabel.text = [NSString stringWithFormat:@"满%@元减%@元", conditionNumber, valueNumber];
            break;
        case TCPrivilegeTypeAliquot:
            self.titleLabel.text = [NSString stringWithFormat:@"每满%@元减%@元", conditionNumber, valueNumber];
            break;
            
        default:
            break;
    }
    
    int64_t startSecond = 0, endSecond = 0, hour = 0, minute = 0;
    startSecond = [[privilege.activityTime firstObject] longLongValue];
    endSecond = [[privilege.activityTime lastObject] longLongValue];
    
    hour = startSecond / 3600;
    minute = (startSecond / 60) % 60;
    NSString *startStr = [NSString stringWithFormat:@"%02lld:%02lld", hour, minute];
    
    hour = endSecond / 3600;
    minute = (endSecond / 60) % 60;
    NSString *endStr = (startSecond < endSecond) ? [NSString stringWithFormat:@"%02lld:%02lld", hour, minute] : [NSString stringWithFormat:@"次日%02lld:%02lld", hour, minute];
    
    self.validLabel.text = [NSString stringWithFormat:@"（有效时间：每天%@-%@）", startStr, endStr];
}

@end
