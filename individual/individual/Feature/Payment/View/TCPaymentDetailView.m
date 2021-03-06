//
//  TCPaymentDetailView.m
//  individual
//
//  Created by 穆康 on 2016/12/1.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCPaymentDetailView.h"
#import <TCCommonLibs/UIImage+Category.h>
#import <TCCommonLibs/TCExtendButton.h>

@interface TCPaymentDetailView ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet TCExtendButton *closeButton;
@property (weak, nonatomic) IBOutlet TCExtendButton *queryButton;

@end

@implementation TCPaymentDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.confirmButton.layer.cornerRadius = 2.5;
    self.confirmButton.layer.masksToBounds = YES;
    UIImage *normalImage = [UIImage imageWithColor:TCRGBColor(151, 171, 234)];
    UIImage *highlightedImage = [UIImage imageWithColor:TCRGBColor(112, 139, 224)];
    [self.confirmButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.confirmButton setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    
    self.closeButton.hitTestSlop = UIEdgeInsetsMake(-20, -20, -20, -20);
    self.queryButton.hitTestSlop = UIEdgeInsetsMake(-20, -20, -20, -20);
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapContainerView:)];
    [self.containerView addGestureRecognizer:tapGesture];
}

- (void)setTotalFee:(double)totalFee {
    _totalFee = totalFee;
    
    self.amountLabel.text = [NSString stringWithFormat:@"%0.2f元", totalFee];
}

- (IBAction)handleCickCloseButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickCloseButtonInPaymentDetailView:)]) {
        [self.delegate didClickCloseButtonInPaymentDetailView:self];
    }
}

- (IBAction)handleClickQueryButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickQueryButtonInPaymentDetailView:)]) {
        [self.delegate didClickQueryButtonInPaymentDetailView:self];
    }
}

- (IBAction)handleClickConfirmButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(didClickConfirmButtonInPaymentDetailView:)]) {
        [self.delegate didClickConfirmButtonInPaymentDetailView:self];
    }
}

- (void)handleTapContainerView:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(didTapChangePaymentMethodViewInPaymentDetailView:)]) {
        [self.delegate didTapChangePaymentMethodViewInPaymentDetailView:self];
    }
}

@end
