//
//  TCGoodsStandardUnitView.m
//  individual
//
//  Created by 穆康 on 2017/9/6.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsStandardUnitView.h"

#define selectedColor TCRGBColor(113, 130, 220)

@interface TCGoodsStandardUnitView ()

@property (weak, nonatomic) UILabel *titleLabel;

@end

@implementation TCGoodsStandardUnitView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 2.5;
        self.layer.masksToBounds = YES;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    CGFloat width = 50.0, height = 24;
    CGFloat padding = 10.0;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(padding);
        make.right.equalTo(self).offset(-padding);
    }];
    [titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(width);
        make.height.mas_equalTo(height);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setType:(TCGoodsStandardUnitViewType)type {
    _type = type;
    
    switch (type) {
        case TCGoodsStandardUnitViewTypeNormal:
            self.backgroundColor = TCBackgroundColor;
            self.titleLabel.textColor = TCGrayColor;
            break;
        case TCGoodsStandardUnitViewTypeSelected:
            self.backgroundColor = selectedColor;
            self.titleLabel.textColor = [UIColor whiteColor];
            break;
        case TCGoodsStandardUnitViewTypeDisabled:
            self.backgroundColor = TCBackgroundColor;
            self.titleLabel.textColor = TCSeparatorLineColor;
            break;
            
        default:
            break;
    }
}

- (CGFloat)realWidth {
    CGFloat minWidth = 50.0, height = 24.0;
    CGFloat padding = 10.0;
    CGFloat width = [self.titleLabel textRectForBounds:CGRectMake(0, 0, CGFLOAT_MAX, height) limitedToNumberOfLines:1].size.width;
    if (width + padding * 2.0 <= minWidth) {
        return minWidth;
    } else {
        return width + padding * 2.0;
    }
}

@end
