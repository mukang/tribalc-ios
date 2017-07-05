//
//  TCRentPlanItemViewCell.m
//  individual
//
//  Created by 穆康 on 2017/7/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRentPlanItemViewCell.h"
#import <TCCommonLibs/TCCommonButton.h>
#import "TCRentPlanItem.h"

@interface TCRentPlanItemViewCell ()

@property (weak, nonatomic) UIView *containerView;
@property (weak, nonatomic) UIView *topContainerView;
@property (weak, nonatomic) UIImageView *itemImageView;
@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) UILabel *planTimeLabel;
@property (weak, nonatomic) UILabel *tenancyLabel;
@property (weak, nonatomic) UILabel *planPayLabel;
@property (weak, nonatomic) UILabel *actualPayLabel;
@property (weak, nonatomic) TCCommonButton *payButton;
@property (weak, nonatomic) UIImageView *statusImageView;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TCRentPlanItemViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UIView *containerView = [[UIView alloc] init];
    containerView.layer.borderColor = TCSeparatorLineColor.CGColor;
    containerView.layer.borderWidth = 0.5;
    containerView.layer.cornerRadius = 2.5;
    containerView.layer.masksToBounds = YES;
    [self.contentView addSubview:containerView];
    
    UIView *topContainerView = [[UIView alloc] init];
    topContainerView.backgroundColor = TCBackgroundColor;
    [containerView addSubview:topContainerView];
    
    UIImageView *itemImageView = [[UIImageView alloc] init];
    itemImageView.image = [UIImage imageNamed:@"rent_plan_item"];
    [topContainerView addSubview:itemImageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TCGrayColor;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [topContainerView addSubview:titleLabel];
    
    UILabel *planTimeLabel = [[UILabel alloc] init];
    planTimeLabel.textColor = TCGrayColor;
    planTimeLabel.font = [UIFont systemFontOfSize:14];
    [containerView addSubview:planTimeLabel];
    
    UILabel *tenancyLabel = [[UILabel alloc] init];
    tenancyLabel.textColor = TCGrayColor;
    tenancyLabel.font = [UIFont systemFontOfSize:14];
    [containerView addSubview:tenancyLabel];
    
    UILabel *planPayLabel = [[UILabel alloc] init];
    planPayLabel.textColor = TCGrayColor;
    planPayLabel.font = [UIFont systemFontOfSize:14];
    [containerView addSubview:planPayLabel];
    
    UILabel *actualPayLabel = [[UILabel alloc] init];
    actualPayLabel.textColor = TCGrayColor;
    actualPayLabel.textAlignment = NSTextAlignmentRight;
    actualPayLabel.font = [UIFont systemFontOfSize:14];
    [containerView addSubview:actualPayLabel];
    
    TCCommonButton *payButton = [TCCommonButton buttonWithTitle:@"付 款"
                                                         target:self
                                                         action:@selector(handleClickPayButton:)];
    [payButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"付 款"
                                                                  attributes:@{
                                                                               NSFontAttributeName: [UIFont systemFontOfSize:14],
                                                                               NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                               }]
                         forState:UIControlStateNormal];
    [containerView addSubview:payButton];
    
    UIImageView *statusImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:statusImageView];
    [self.contentView bringSubviewToFront:statusImageView];
    
    self.containerView = containerView;
    self.topContainerView = topContainerView;
    self.itemImageView = itemImageView;
    self.titleLabel = titleLabel;
    self.planTimeLabel = planTimeLabel;
    self.tenancyLabel = tenancyLabel;
    self.planPayLabel = planPayLabel;
    self.actualPayLabel = actualPayLabel;
    self.payButton = payButton;
    self.statusImageView = statusImageView;
}

- (void)setupConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(11);
        make.left.equalTo(self.contentView).offset(12);
        make.right.equalTo(self.contentView).offset(-12);
        make.bottom.equalTo(self.contentView);
    }];
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(35);
    }];
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16.5, 16.5));
        make.left.equalTo(self.topContainerView).offset(10);
        make.centerY.equalTo(self.topContainerView);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itemImageView.mas_right).offset(6);
        make.centerY.equalTo(self.topContainerView);
    }];
    [self.planTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topContainerView.mas_bottom).offset(8);
        make.left.equalTo(self.containerView).offset(10);
    }];
    [self.tenancyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.planTimeLabel.mas_bottom).offset(8);
        make.left.equalTo(self.containerView).offset(10);
    }];
    [self.planPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tenancyLabel.mas_bottom).offset(8);
        make.left.equalTo(self.containerView).offset(10);
    }];
    [self.actualPayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.planPayLabel);
        make.right.equalTo(self.containerView).offset(-10);
    }];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(47, 19));
        make.centerY.equalTo(self.planPayLabel);
        make.right.equalTo(self.containerView).offset(-10);
    }];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(63.5, 47.5));
        make.top.equalTo(self.contentView).offset(6);
        make.right.equalTo(self.contentView).offset(-15);
    }];
}

- (void)setPlanItem:(TCRentPlanItem *)planItem {
    _planItem = planItem;
    
    self.titleLabel.text = [NSString stringWithFormat:@"第%zd期付款计划", planItem.itemNum];
    
    NSDate *planDate = [NSDate dateWithTimeIntervalSince1970:(planItem.plannedTime / 1000.0)];
    self.planTimeLabel.text = [NSString stringWithFormat:@"付款日：%@", [self.dateFormatter stringFromDate:planDate]];
    
    NSDate *beginDate = [NSDate dateWithTimeIntervalSince1970:(planItem.startTime / 1000.0)];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:(planItem.endTime / 1000.0)];
    self.tenancyLabel.text = [NSString stringWithFormat:@"租期：%@ 至 %@", [self.dateFormatter stringFromDate:beginDate], [self.dateFormatter stringFromDate:endDate]];
    
    self.planPayLabel.text = [NSString stringWithFormat:@"需还款：%0.2f", planItem.plannedRental];
    
    if (planItem.finished) {
        self.actualPayLabel.hidden = NO;
        self.statusImageView.hidden = NO;
        self.payButton.hidden = YES;
        self.actualPayLabel.text = [NSString stringWithFormat:@"已还款：%0.2f", planItem.actualPay];
        self.statusImageView.image = [UIImage imageNamed:@"rent_plan_finish"];
    } else {
        self.actualPayLabel.hidden = YES;
        self.payButton.hidden = planItem.isCurrentItem ? NO : YES;
        if ([planDate compare:[NSDate date]] == NSOrderedAscending) {
            self.statusImageView.hidden = NO;
            self.statusImageView.image = [UIImage imageNamed:@"rent_plan_overdue"];
        } else {
            self.statusImageView.hidden = YES;
        }
    }
}

- (void)handleClickPayButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(rentPlanItemViewCell:didClickPayButtonWithPlanItem:)]) {
        [self.delegate rentPlanItemViewCell:self didClickPayButtonWithPlanItem:self.planItem];
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
