//
//  TCOrderAddressView.m
//  individual
//
//  Created by WYH on 16/11/26.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCOrderAddressView.h"

@implementation TCOrderAddressView

- (instancetype)initWithOrigin:(CGPoint)point WithName:(NSString *)name AndPhone:(NSString *)phone AndAddress:(NSString *)address{
    CGRect screen = [UIScreen mainScreen].bounds;
    UIImage *backImg = [UIImage imageNamed:@"order_address_back"];
    
    self = [super initWithFrame:CGRectMake(point.x, point.y, screen.size.width, 107)];
    self.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    if (self) {
        UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 7.5, screen.size.width, 96)];
        backImgView.image = backImg;
        [self addSubview:backImgView];
        
        UILabel *receiverLab = [self getReceiverLabelWithFrame:CGRectMake(32, 20, 152, 14) AndName:name];
        [backImgView addSubview:receiverLab];
        
        UILabel *phoneLab = [self getPhoneLabWithFrame:CGRectMake(receiverLab.x + receiverLab.width, receiverLab.y, self.width - 77 - receiverLab.x - receiverLab.width, 14) AndPhoneStr:phone];
        [backImgView addSubview:phoneLab];
        
        UIButton *locationLogo = [TCComponent createImageBtnWithFrame:CGRectMake(20, backImgView.height / 2 - 4, 12, 12) AndImageName:@"order_location"];
        [backImgView addSubview:locationLogo];
        
        UILabel *addressLab = [self getAddressLabelWithFrame:CGRectMake(receiverLab.x + 4, locationLogo.y, self.width - receiverLab.x - 4 - (self.width - phoneLab.x - phoneLab.width), 13) AndText:address];
        [backImgView addSubview:addressLab];
        
        UIButton *rightArrow = [self getRightArrowButtonWithFrame:CGRectMake(self.width - 38, 31, 9, 16)];
        [backImgView addSubview:rightArrow];
        
    }
    
    return self;
}

- (UIButton *)getRightArrowButtonWithFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    UIImage *arrowImg = [UIImage imageNamed:@"goods_select_standard"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:arrowImg];
    [button addSubview:imgView];
    return button;
}

- (UILabel *)getReceiverLabelWithFrame:(CGRect)frame AndName:(NSString *)name {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    NSString *nameStr = [NSString stringWithFormat:@"收货人 : %@", name];
    label.text = nameStr;
    label.font = [UIFont fontWithName:BOLD_FONT size:14];
    
    return label;
}

- (UILabel *)getPhoneLabWithFrame:(CGRect)frame AndPhoneStr:(NSString *)phone {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = phone;
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont fontWithName:BOLD_FONT size:14];
    
    return label;
}

- (UILabel *)getAddressLabelWithFrame:(CGRect)frame AndText:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    
    label.font = [UIFont systemFontOfSize:12];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 2;
    
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: label.font}];
    if (size.width > label.width) {
        [label setHeight:(label.height * 2) + 4];
    }
    
    text = text == nil ? @"" : text;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 4;
    NSRange range = NSMakeRange(0, text.length);
    [attr addAttribute:text value:style range:range];
    label.attributedText = attr;
    
    return label;
}



@end
