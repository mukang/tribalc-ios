//
//  TCApartmentCell.m
//  individual
//
//  Created by 王帅锋 on 2017/6/28.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCApartmentCell.h"

@interface TCApartmentCell ()

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIView *grayView;

@property (strong, nonatomic) UIView *lineView1;

@property (strong, nonatomic) UILabel *apartmentNumLabel;

@property (strong, nonatomic) UIView *lineView2;

@property (strong, nonatomic) UILabel *apartmentNameLabel;

@property (strong, nonatomic) UIButton *apartmentFeeBtn;

@property (strong, nonatomic) UIButton *apartmentModifyPwdBtn;

@property (strong, nonatomic) UIButton *apartmentCheckPwdBtn;

@property (strong, nonatomic) UIButton *apartmentCheckElecBtn;

@property (strong, nonatomic) UIView *lineView3;

@property (strong, nonatomic) UIButton *contractBtn;

@property (strong, nonatomic) UIView *verticalLineView;

@property (strong, nonatomic) UIButton *payPlanBtn;

@property (strong, nonatomic) UIView *lineView4;

@end

@implementation TCApartmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpViews];
    }
    return self;
}

- (void)setRentProtocol:(TCRentProtocol *)rentProtocol {
    if (_rentProtocol != rentProtocol) {
        _rentProtocol = rentProtocol;
        
        self.apartmentNumLabel.text = [NSString stringWithFormat:@"编号：%@",rentProtocol.sourceNum];
        self.apartmentNameLabel.text = [NSString stringWithFormat:@"公寓：%@",rentProtocol.sourceName];
    }
}

- (void)checkPayPlan {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCheckPayPlanWithRentProtocol:)]) {
        [self.delegate didClickCheckPayPlanWithRentProtocol:self.rentProtocol];
    }
}

- (void)fee {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickFeeWithRentProtocol:)]) {
        [self.delegate didClickFeeWithRentProtocol:self.rentProtocol];
    }
}

- (void)checkContract {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCheckContractWithRentProtocol:)]) {
        [self.delegate didClickCheckContractWithRentProtocol:self.rentProtocol];
    }
}

- (void)checkElec {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCheckElecWithRentProtocol:)]) {
        [self.delegate didClickCheckElecWithRentProtocol:self.rentProtocol];
    }
}

- (void)checkPwd {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickCheckPwdWithRentProtocol:)]) {
        [self.delegate didClickCheckPwdWithRentProtocol:self.rentProtocol];
    }
}

- (void)modifyPwd {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickModifyPwdWithRentProtocol:)]) {
        [self.delegate didClickModifyPwdWithRentProtocol:self.rentProtocol];
    }
}

- (void)setUpViews {
    
    [self.contentView addSubview:self.grayView];
    [self.contentView addSubview:self.lineView1];
    [self.contentView addSubview:self.apartmentNumLabel];
    [self.contentView addSubview:self.lineView2];
    [self.contentView addSubview:self.apartmentNameLabel];
    [self.contentView addSubview:self.apartmentFeeBtn];
    [self.contentView addSubview:self.apartmentModifyPwdBtn];
    [self.contentView addSubview:self.apartmentCheckPwdBtn];
    [self.contentView addSubview:self.apartmentCheckElecBtn];
    [self.contentView addSubview:self.lineView3];
    [self.contentView addSubview:self.contractBtn];
    [self.contentView addSubview:self.payPlanBtn];
    [self.contentView addSubview:self.lineView4];
    
    [self.contractBtn addSubview:self.verticalLineView];
    
    [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(@(TCRealValue(15)));
    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.grayView.mas_bottom);
        make.height.equalTo(@(1/kScale));
    }];
    
    [self.apartmentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@(TCRealValue(42)));
        make.top.equalTo(self.lineView1.mas_bottom);
    }];
    
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.apartmentNumLabel.mas_bottom);
        make.height.equalTo(@(1/kScale));
    }];
    
    [self.apartmentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.apartmentNumLabel);
        make.top.equalTo(self.lineView2.mas_bottom).offset(TCRealValue(5));
    }];
    
    [self.apartmentFeeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(TCRealValue(25));
        make.top.equalTo(self.lineView2.mas_bottom).offset(TCRealValue(65));
        make.height.equalTo(@(TCRealValue(32)));
        make.width.equalTo(@(TCRealValue(136)));
    }];
    
    [self.apartmentModifyPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-(TCRealValue(25)));
        make.top.width.height.equalTo(self.apartmentFeeBtn);
    }];
    
    [self.apartmentCheckPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.apartmentFeeBtn);
        make.top.equalTo(self.apartmentFeeBtn.mas_bottom).offset(TCRealValue(32));
    }];
    
    [self.apartmentCheckElecBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.width.height.equalTo(self.apartmentModifyPwdBtn);
        make.top.equalTo(self.apartmentCheckPwdBtn);
    }];
    
    [self.lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.apartmentCheckPwdBtn.mas_bottom).offset(TCRealValue(32));
        make.height.equalTo(@(1/kScale));
    }];
    
    [self.contractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.lineView3.mas_bottom);
        make.height.equalTo(@(TCRealValue(50)));
        make.width.equalTo(self.contentView).multipliedBy(0.5);
    }];
    
    [self.payPlanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView);
        make.width.height.top.equalTo(self.contractBtn);
    }];
    
    [self.lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.payPlanBtn.mas_bottom);
        make.height.equalTo(@(1/kScale));
    }];
    
    [self.verticalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.right.equalTo(self.contractBtn);
        make.height.equalTo(@(TCRealValue(37)));
        make.width.equalTo(@(1/kScale));
    }];
}

- (UIView *)verticalLineView {
    if (_verticalLineView == nil) {
        _verticalLineView = [[UIView alloc] init];
        _verticalLineView.backgroundColor = kLineColor;
    }
    return _verticalLineView;
}

- (UIView *)lineView4 {
    if (_lineView4 == nil) {
        _lineView4 = [[UIView alloc] init];
        _lineView4.backgroundColor = kLineColor;
    }
    return _lineView4;
}

- (UIButton *)payPlanBtn {
    if (_payPlanBtn == nil) {
        _payPlanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payPlanBtn setTitle:@"还款计划" forState: UIControlStateNormal];
        [_payPlanBtn setTitleColor:TCBlackColor forState:UIControlStateNormal];
        _payPlanBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_payPlanBtn setImage:[UIImage imageNamed:@"apartmenPayPlanImage"] forState:UIControlStateNormal];
        [_payPlanBtn addTarget:self action:@selector(checkPayPlan) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payPlanBtn;
}

- (UIButton *)contractBtn {
    if (_contractBtn == nil) {
        _contractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contractBtn setTitle:@"我的合同" forState: UIControlStateNormal];
        [_contractBtn setTitleColor:TCBlackColor forState:UIControlStateNormal];
        _contractBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_contractBtn setImage:[UIImage imageNamed:@"apartmenContractImage"] forState:UIControlStateNormal];
        [_contractBtn addTarget:self action:@selector(checkContract) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contractBtn;
}

- (UIView *)lineView3 {
    if (_lineView3 == nil) {
        _lineView3 = [[UIView alloc] init];
        _lineView3.backgroundColor = kLineColor;
    }
    return _lineView3;
}

- (UIButton *)apartmentCheckElecBtn {
    if (_apartmentCheckElecBtn == nil) {
        _apartmentCheckElecBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_apartmentCheckElecBtn setTitle:@"查看门锁电量" forState: UIControlStateNormal];
        [_apartmentCheckElecBtn setTitleColor:TCBlackColor forState:UIControlStateNormal];
        [_apartmentCheckElecBtn setImage:[UIImage imageNamed:@"apartmenCheckElecImage"] forState:UIControlStateNormal];
        [_apartmentCheckElecBtn addTarget:self action:@selector(checkElec) forControlEvents:UIControlEventTouchUpInside];
        _apartmentCheckElecBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _apartmentCheckElecBtn.layer.cornerRadius = TCRealValue(14);
        _apartmentCheckElecBtn.clipsToBounds = YES;
        _apartmentCheckElecBtn.layer.borderColor = kLineColor.CGColor;
        _apartmentCheckElecBtn.layer.borderWidth = 1/kScale;
    }
    return _apartmentCheckElecBtn;
}

- (UIButton *)apartmentCheckPwdBtn {
    if (_apartmentCheckPwdBtn == nil) {
        _apartmentCheckPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_apartmentCheckPwdBtn setTitle:@"查看临时密码" forState: UIControlStateNormal];
        [_apartmentCheckPwdBtn setImage:[UIImage imageNamed:@"apartmenModifyPwdImage"] forState:UIControlStateNormal];
        [_apartmentCheckPwdBtn addTarget:self action:@selector(checkPwd) forControlEvents:UIControlEventTouchUpInside];
        [_apartmentCheckPwdBtn setTitleColor:TCBlackColor forState:UIControlStateNormal];
        _apartmentCheckPwdBtn.layer.cornerRadius = TCRealValue(14);
        _apartmentCheckPwdBtn.clipsToBounds = YES;
        _apartmentCheckPwdBtn.layer.borderColor = kLineColor.CGColor;
        _apartmentCheckPwdBtn.layer.borderWidth = 1/kScale;
        _apartmentCheckPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _apartmentCheckPwdBtn;
}

- (UIButton *)apartmentModifyPwdBtn {
    if (_apartmentModifyPwdBtn == nil) {
        _apartmentModifyPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_apartmentModifyPwdBtn setTitle:@"修改门锁密码" forState: UIControlStateNormal];
        [_apartmentModifyPwdBtn setImage:[UIImage imageNamed:@"apartmenModifyPwdImage"] forState:UIControlStateNormal];
        [_apartmentModifyPwdBtn addTarget:self action:@selector(modifyPwd) forControlEvents:UIControlEventTouchUpInside];
        [_apartmentModifyPwdBtn setTitleColor:TCBlackColor forState:UIControlStateNormal];
        _apartmentModifyPwdBtn.layer.cornerRadius = TCRealValue(14);
        _apartmentModifyPwdBtn.clipsToBounds = YES;
        _apartmentModifyPwdBtn.layer.borderColor = kLineColor.CGColor;
        _apartmentModifyPwdBtn.layer.borderWidth = 1/kScale;
        _apartmentModifyPwdBtn.titleLabel.font = [UIFont systemFontOfSize:13];

    }
    return _apartmentModifyPwdBtn;
}

- (UIButton *)apartmentFeeBtn {
    if (_apartmentFeeBtn == nil) {
        _apartmentFeeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_apartmentFeeBtn setTitle:@"我的房屋缴费" forState: UIControlStateNormal];
        [_apartmentFeeBtn setImage:[UIImage imageNamed:@"apartmenFeeImage"] forState:UIControlStateNormal];
        [_apartmentFeeBtn setTitleColor:TCBlackColor forState:UIControlStateNormal];
        [_apartmentFeeBtn addTarget:self action:@selector(fee) forControlEvents:UIControlEventTouchUpInside];
        _apartmentFeeBtn.layer.cornerRadius = TCRealValue(14);
        _apartmentFeeBtn.clipsToBounds = YES;
        _apartmentFeeBtn.layer.borderColor = kLineColor.CGColor;
        _apartmentFeeBtn.layer.borderWidth = 1/kScale;
        _apartmentFeeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _apartmentFeeBtn;
}

- (UILabel *)apartmentNameLabel {
    if (_apartmentNameLabel == nil) {
        _apartmentNameLabel = [[UILabel alloc] init];
        _apartmentNameLabel.textColor = TCGrayColor;
        _apartmentNameLabel.font = [UIFont systemFontOfSize:12];
        _apartmentNameLabel.numberOfLines = 3;
    }
    return _apartmentNameLabel;
}

- (UIView *)lineView2 {
    if (_lineView2 == nil) {
        _lineView2 = [[UIView alloc] init];
        _lineView2.backgroundColor = kLineColor;
    }
    return _lineView2;
}

- (UILabel *)apartmentNumLabel {
    if (_apartmentNumLabel == nil) {
        _apartmentNumLabel = [[UILabel alloc] init];
        _apartmentNumLabel.font = [UIFont systemFontOfSize:14];
        _apartmentNumLabel.textColor = TCBlackColor;
    }
    return _apartmentNumLabel;
}

- (UIView *)lineView1 {
    if (_lineView1 == nil) {
        _lineView1 = [[UIView alloc] init];
        _lineView1.backgroundColor = kLineColor;
    }
    return _lineView1;
}

- (UIView *)grayView {
    if (_grayView == nil) {
        _grayView = [[UIView alloc] init];
        _grayView.backgroundColor = TCRGBColor(244, 244, 244);
    }
    return _grayView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
