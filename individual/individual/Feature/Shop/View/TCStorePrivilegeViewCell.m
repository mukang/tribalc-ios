//
//  TCStorePrivilegeViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/19.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStorePrivilegeViewCell.h"
#import "TCListStore.h"

@interface TCStorePrivilegeViewCell ()

@property (strong, nonatomic) NSMutableArray *labels;

@end

@implementation TCStorePrivilegeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = TCRGBColor(239, 244, 245);
    
    UILabel *lastLabel = nil;
    CGFloat topMargin = 27, leftMargin = 20, bottomMargin = 20, rightMargin = 20, margin = 11;
    for (int i=0; i<5; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = TCGrayColor;
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:label];
        [self.labels addObject:label];
        
        if (lastLabel) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastLabel.mas_bottom).offset(margin);
                make.left.equalTo(self.contentView).offset(leftMargin);
                make.right.equalTo(self.contentView).offset(-rightMargin);
            }];
        } else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView).offset(topMargin);
                make.left.equalTo(self.contentView).offset(leftMargin);
                make.right.equalTo(self.contentView).offset(-rightMargin);
            }];
        }
        lastLabel = label;
    }
    [lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-bottomMargin);
    }];
}

- (void)setStoreInfo:(TCListStore *)storeInfo {
    _storeInfo = storeInfo;
    
    UILabel *label = self.labels[0];
    label.text = [NSString stringWithFormat:@"地址    %@", storeInfo.address];
    
    label = self.labels[1];
    label.text = [NSString stringWithFormat:@"电话    %@", storeInfo.phone];
    
    label = self.labels[2];
    label.text = [NSString stringWithFormat:@"时间    %@", storeInfo.businessHours];
    
    label = self.labels[3];
    label.text = [NSString stringWithFormat:@"人均    ¥ %0.2f", storeInfo.avgprice];
    
    label = self.labels[4];
    NSArray *privileges = storeInfo.privileges;
    NSString *privilegeStr = [NSString string];
    for (int i=0; i<privileges.count; i++) {
        TCPrivilege *privilege = privileges[i];
        NSString *str = nil;
        switch (privilege.privilegeType) {
            case TCPrivilegeTypeDiscount:
                str = [NSString stringWithFormat:@"满%0.2f元%0.2f折", privilege.condition, privilege.value * 10];
                break;
            case TCPrivilegeTypeReduce:
                str = [NSString stringWithFormat:@"满%0.2f元减%0.2f元", privilege.condition, privilege.value];
                break;
            case TCPrivilegeTypeAliquot:
                str = [NSString stringWithFormat:@"每满%0.2f元减%0.2f", privilege.condition, privilege.value];
                break;
                
            default:
                break;
        }
        privilegeStr = [privilegeStr stringByAppendingFormat:@"%@ ", str];
    }
    label.text = [NSString stringWithFormat:@"折扣    %@", privilegeStr];
}

- (NSMutableArray *)labels {
    if (_labels == nil) {
        _labels = [NSMutableArray arrayWithCapacity:5];
    }
    return _labels;
}

@end
