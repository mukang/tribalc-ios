//
//  TCApartmentRentPayDetailView.m
//  individual
//
//  Created by 穆康 on 2017/6/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCApartmentRentPayDetailView.h"
#import <TCCommonLibs/TCCommonButton.h>
#import "TCRentProtocol.h"

@interface TCApartmentRentPayDetailView ()

@property (weak, nonatomic) UIView *topLine;
@property (weak, nonatomic) UIView *bottomLine;
@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UILabel *numLabel;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UILabel *beginAndEndDateLabel;
@property (weak, nonatomic) UILabel *periodLabel;
@property (weak, nonatomic) UILabel *imminentDateLabel;
@property (weak, nonatomic) UILabel *amountLabel;
@property (weak, nonatomic) TCCommonButton *payButton;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TCApartmentRentPayDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = TCSeparatorLineColor;
    [self addSubview:bottomLine];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.layer.borderWidth = 0.5;
    containerView.layer.borderColor = TCSeparatorLineColor.CGColor;
    containerView.layer.cornerRadius = 2.5;
    containerView.layer.masksToBounds = YES;
    [self addSubview:containerView];
    
    self.numLabel = [self createLabel];
    self.nameLabel = [self createLabel];
    self.beginAndEndDateLabel = [self createLabel];
    self.periodLabel = [self createLabel];
    self.imminentDateLabel = [self createLabel];;
    self.amountLabel = [self createLabel];
    
    TCCommonButton *payButton = [TCCommonButton buttonWithTitle:@"确认缴费" target:self action:@selector(handleClickPayButton:)];
    [self addSubview:payButton];
    self.payButton = payButton;
}

- (void)setupConstraints {
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.left.right.equalTo(self);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.bottom.left.right.equalTo(self);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLine.mas_bottom).offset(TCRealValue(12));
        make.left.equalTo(self).offset(TCRealValue(12));
        make.right.equalTo(self).offset(TCRealValue(-12));
        make.height.mas_equalTo(TCRealValue(218));
    }];
    
    CGFloat labelMargin = TCRealValue(18);
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(TCRealValue(23));
        make.leading.equalTo(self.containerView).offset(TCRealValue(10));
        make.trailing.equalTo(self.containerView).offset(TCRealValue(-10));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numLabel.mas_bottom).offset(labelMargin);
        make.leading.equalTo(self.containerView).offset(TCRealValue(10));
        make.trailing.equalTo(self.containerView).offset(TCRealValue(-10));
    }];
    [self.beginAndEndDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(labelMargin);
        make.leading.equalTo(self.containerView).offset(TCRealValue(10));
        make.trailing.equalTo(self.containerView).offset(TCRealValue(-10));
    }];
    [self.periodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beginAndEndDateLabel.mas_bottom).offset(labelMargin);
        make.leading.equalTo(self.containerView).offset(TCRealValue(10));
        make.trailing.equalTo(self.containerView).offset(TCRealValue(-10));
    }];
    [self.imminentDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.periodLabel.mas_bottom).offset(labelMargin);
        make.leading.equalTo(self.containerView).offset(TCRealValue(10));
        make.trailing.equalTo(self.containerView).offset(TCRealValue(-10));
    }];
    [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imminentDateLabel.mas_bottom).offset(labelMargin);
        make.leading.equalTo(self.containerView).offset(TCRealValue(10));
        make.trailing.equalTo(self.containerView).offset(TCRealValue(-10));
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_bottom).offset(TCRealValue(18));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(TCRealValue(315), TCRealValue(40)));
    }];
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = TCRGBColor(136, 136, 136);
    label.font = [UIFont systemFontOfSize:TCRealValue(14)];
    [self.containerView addSubview:label];
    return label;
}

- (void)setRentProtocol:(TCRentProtocol *)rentProtocol {
    _rentProtocol = rentProtocol;
    
    self.numLabel.text = [NSString stringWithFormat:@"编号：%@", rentProtocol.sourceNum];
    
    self.nameLabel.text = [NSString stringWithFormat:@"公寓：%@", rentProtocol.sourceName];
    
    NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:(rentProtocol.beginTime / 1000.0)];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:(rentProtocol.endTime / 1000.0)];
    self.beginAndEndDateLabel.text = [NSString stringWithFormat:@"租赁日期：%@ 至 %@", [self.dateFormatter stringFromDate:beginDate], [self.dateFormatter stringFromDate:endDate]];
    
    self.periodLabel.text = [NSString stringWithFormat:@"当前缴费周期：第%zd期", rentProtocol.payCycle];
    
    NSDate *imminentDate = [NSDate dateWithTimeIntervalSince1970:(rentProtocol.imminentPayTime / 1000.0)];
    self.imminentDateLabel.text = [NSString stringWithFormat:@"缴费日期：%@", [self.dateFormatter stringFromDate:imminentDate]];
    
    NSString *amountStr = [NSString stringWithFormat:@"%0.2f", rentProtocol.monthlyRent];
    NSString *unitStr = @"元";
    NSString *totalStr = [NSString stringWithFormat:@"缴费金额：%@%@", amountStr, unitStr];
    NSRange amountRange = [totalStr rangeOfString:amountStr];
    NSRange unitRange = [totalStr rangeOfString:unitStr];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:totalStr];
    [attText addAttributes:@{
                             NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(20)],
                             NSForegroundColorAttributeName: TCRGBColor(246, 57, 84)
                             }
                     range:amountRange];
    [attText addAttributes:@{
                             NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(14)],
                             NSForegroundColorAttributeName: TCRGBColor(246, 57, 84)
                             }
                     range:unitRange];
    self.amountLabel.attributedText = attText;
}

- (void)handleClickPayButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickPayButtonInApartmentRentPayDetailView:)]) {
        [self.delegate didClickPayButtonInApartmentRentPayDetailView:self];
    }
}

- (NSDateFormatter *)dateFormatter {
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

@end
