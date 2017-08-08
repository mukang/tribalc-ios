//
//  TCApartmentRentPayFinishView.m
//  individual
//
//  Created by 穆康 on 2017/6/29.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCApartmentRentPayFinishView.h"
#import <YYText.h>

@implementation TCApartmentRentPayFinishView

- (instancetype)initWithType:(TCRentPayFinishViewType)type {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _type = type;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _type = TCRentPayFinishViewTypeIndividual;
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:topLine];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apartment_rent_pay_finish"]];
    [self addSubview:imageView];
    
    NSString *differenceStr = (_type == TCRentPayFinishViewTypeIndividual) ? @"房租" : @"租金";
    
    NSString *partStr = @"全部付款计划";
    NSString *totalStr = [NSString stringWithFormat:@"您已缴纳了全部%@，可在%@", differenceStr, partStr];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [attText setAttributes:@{
                             NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(12.5)],
                             NSForegroundColorAttributeName: TCGrayColor
                             }
                     range:NSMakeRange(0, totalStr.length)];
    NSRange highlightRange = [totalStr rangeOfString:partStr];
    [attText setAttributes:@{
                             NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(12.5)],
                             NSForegroundColorAttributeName: TCRGBColor(74, 119, 250),
                             NSUnderlineStyleAttributeName: @(1)
                             }
                     range:highlightRange];
    YYTextHighlight *highlight = [[YYTextHighlight alloc] init];
    highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [self handleClickPayPlan];
    };
    [attText yy_setTextHighlight:highlight range:highlightRange];
    
    YYLabel *firstLabel = [[YYLabel alloc] init];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.attributedText = attText;
    [self addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] init];
    secondLabel.text = [NSString stringWithFormat:@"中查看%@缴纳状态", differenceStr];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.textColor = TCGrayColor;
    secondLabel.font = [UIFont systemFontOfSize:TCRealValue(12.5)];
    [self addSubview:secondLabel];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.left.right.equalTo(self);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(94), TCRealValue(90.5)));
        make.centerX.equalTo(self);
        make.top.equalTo(topLine.mas_bottom).offset(TCRealValue(117.5));
    }];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(TCRealValue(27));
        make.centerX.equalTo(self);
    }];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstLabel.mas_bottom).offset(TCRealValue(2));
        make.centerX.equalTo(self);
    }];
}

- (void)handleClickPayPlan {
    if ([self.delegate respondsToSelector:@selector(didClickPayPlanInApartmentRentPayFinishView:)]) {
        [self.delegate didClickPayPlanInApartmentRentPayFinishView:self];
    }
}

@end
