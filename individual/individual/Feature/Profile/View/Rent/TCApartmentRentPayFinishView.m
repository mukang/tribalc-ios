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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
    
    NSString *partStr = @"全部付款计划";
    NSString *totalStr = [NSString stringWithFormat:@"您已缴纳了全部房租，可在%@/n中查看房租缴纳状态", partStr];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [attText setAttributes:@{
                             NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(12.5)],
                             NSForegroundColorAttributeName: TCGrayColor
                             }
                     range:NSMakeRange(0, totalStr.length)];
    YYTextHighlight *highlight = [YYTextHighlight highlightWithAttributes:@{
                                                                            NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(12.5)],
                                                                            NSForegroundColorAttributeName: TCRGBColor(74, 119, 250),
                                                                            NSUnderlineStyleAttributeName: @(1)
                                                                            }];
    highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [self handleClickPayPlan];
    };
    [attText yy_setTextHighlight:highlight range:[totalStr rangeOfString:partStr]];
    
    YYLabel *label = [[YYLabel alloc] init];
    label.numberOfLines = 2;
    label.attributedText = attText;
    [self addSubview:label];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.left.right.equalTo(self);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(TCRealValue(94), TCRealValue(90.5)));
        make.centerX.equalTo(self);
        make.top.equalTo(topLine.mas_bottom).offset(TCRealValue(117.5));
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(TCRealValue(27));
        make.centerX.equalTo(self);
    }];
}

- (void)handleClickPayPlan {
    if ([self.delegate respondsToSelector:@selector(didClickPayPlanInApartmentRentPayFinishView:)]) {
        [self.delegate didClickPayPlanInApartmentRentPayFinishView:self];
    }
}

@end
