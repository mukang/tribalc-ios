//
//  TCPreparePayViewController.m
//  individual
//
//  Created by 王帅锋 on 17/6/7.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPreparePayViewController.h"
#import "TCBuluoApi.h"
#import "TCImageURLSynthesizer.h"
#import <UIImageView+WebCache.h>
#import "TCPaymentViewController.h"

@interface TCPreparePayViewController ()<TCPaymentViewControllerDelegate>

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic) UIView *moneyView;

@property (strong, nonatomic) UIButton *payBtn;

@property (strong, nonatomic) UILabel *moneyTitleLabel;

@property (strong, nonatomic) UITextField *textField;

@property (strong, nonatomic) TCStoreDetailInfo *storeDetailInfo;

@end

@implementation TCPreparePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"向商家付款";
    self.view.backgroundColor = TCRGBColor(240, 241, 242);
    [self loadData];
}

- (void)loadData {
    [[TCBuluoApi api] fetchStoreDetailInfoWithStoreId:self.storeId result:^(TCStoreDetailInfo *storeDetailInfo, NSError *error) {
        if (storeDetailInfo) {
            self.storeDetailInfo = storeDetailInfo;
            [self setUpViews];
        }else {
            NSString *reason = error.localizedDescription ?: @"请稍后再试";
            [MBProgressHUD showHUDWithMessage:[NSString stringWithFormat:@"获取店铺信息失败，%@", reason]];
        }
    }];
}

- (void)setUpViews {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
    
    [self.view addSubview:self.iconView];
    [self.view addSubview:self.nameLabel];
    [self.view addSubview:self.moneyView];
    [self.view addSubview:self.payBtn];
    [self.moneyView addSubview:self.moneyTitleLabel];
    [self.moneyView addSubview:self.textField];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(TCRealValue(16));
        make.width.height.equalTo(@(TCRealValue(64)));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.iconView.mas_bottom).offset(TCRealValue(5));
        make.height.equalTo(@(TCRealValue(15)));
    }];
    
    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(TCRealValue(20));
        make.height.equalTo(@(TCRealValue(76)));
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.moneyView.mas_bottom).offset(TCRealValue(44));
        make.width.equalTo(@(TCRealValue(315)));
        make.height.equalTo(@(TCRealValue(40)));
    }];
    
    [self.moneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyView).offset(TCRealValue(25));
        make.width.equalTo(@80);
        make.top.equalTo(self.moneyView).offset(TCRealValue(10));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyTitleLabel);
        make.right.equalTo(self.moneyView).offset(-(TCRealValue(25)));
        make.top.equalTo(self.moneyTitleLabel.mas_bottom).offset(TCRealValue(5));
    }];
}

- (void)tap {
    [self.view endEditing:YES];
}

- (void)pay {
    if (self.textField.text.length == 0) {
        [MBProgressHUD showHUDWithMessage:@"请输入金额"];
        return;
    }
    
    TCPaymentViewController *vc = [[TCPaymentViewController alloc] initWithTotalFee:[self.textField.text doubleValue]
                                                                         payPurpose:TCPayPurposeFace2Face
                                                                     fromController:self];
    vc.delegate = self;
    vc.targetID = self.storeDetailInfo.ID;
    [vc show:YES];
    
}

#pragma TCPaymentViewControllerDelegate

- (void)paymentViewController:(TCPaymentViewController *)controller didFinishedPaymentWithPayment:(TCUserPayment *)payment {
    
}

- (UIButton *)payBtn {
    if (_payBtn == nil) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setTitle:@"付 款" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBtn.layer.cornerRadius = 4.0;
        _payBtn.clipsToBounds = YES;
        _payBtn.backgroundColor = TCRGBColor(218, 216, 217);
        [_payBtn addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (UIImageView *)iconView {
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.cornerRadius = TCRealValue(64)/2;
        _iconView.clipsToBounds = YES;
        NSURL *URL = [TCImageURLSynthesizer synthesizeImageURLWithPath:self.storeDetailInfo.logo];
        [_iconView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"profile_default_avatar_icon"] options:SDWebImageRetryFailed];
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = TCBlackColor;
        _nameLabel.text = [NSString stringWithFormat:@"向商家\"%@\"付款",self.storeDetailInfo.name];
    }
    return _nameLabel;
}

- (UILabel *)moneyTitleLabel {
    if (_moneyTitleLabel == nil) {
        _moneyTitleLabel = [[UILabel alloc] init];
        _moneyTitleLabel.font = [UIFont systemFontOfSize:12];
        _moneyTitleLabel.textColor = TCBlackColor;
        _moneyTitleLabel.text = @"金额";
    }
    return _moneyTitleLabel;
}

- (UITextField *)textField {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
        label.text = @"¥";
        label.font = [UIFont systemFontOfSize:20];
        label.textColor = TCBlackColor;
        _textField.leftView = label;
        _textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _textField;
}

- (UIView *)moneyView {
    if (_moneyView == nil) {
        _moneyView = [[UIView alloc] init];
        _moneyView.backgroundColor = [UIColor whiteColor];
    }
    return _moneyView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
