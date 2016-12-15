//
//  TCUserOrderTableViewCell.m
//  individual
//
//  Created by WYH on 16/11/22.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCUserOrderTableViewCell.h"

@implementation TCUserOrderTableViewCell {
    UILabel *titleLab;
    UILabel *priceLab;
    UILabel *numberLab;
    UIView *backView;
}

- (instancetype)initOrderDetailCellWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect screenRect = [UIScreen mainScreen].bounds;
        CGFloat height = TCRealValue(96.5);
        backView.frame = CGRectMake(TCRealValue(20), height / 2 - TCRealValue(79) / 2, screenRect.size.width - TCRealValue(40), height);
        backView.backgroundColor = [UIColor whiteColor];
        
        _leftImgView.frame = CGRectMake(TCRealValue(8), 0, TCRealValue(79), TCRealValue(79));
        titleLab.frame = CGRectMake(_leftImgView.x + _leftImgView.width + TCRealValue(9), _leftImgView.y + TCRealValue(7), screenRect.size.width - _leftImgView.x - _leftImgView.width - TCRealValue(13) - TCRealValue(54), TCRealValue(12));
        
        priceLab.font = [UIFont fontWithName:BOLD_FONT size:TCRealValue(14)];
        
        UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), 0, screenRect.size.width - TCRealValue(40), TCRealValue(0.5))];
        [self addSubview:topLineView];
        
        UIView *downLineView = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), height - TCRealValue(0.5), screenRect.size.width - TCRealValue(40), TCRealValue(0.5))];
        [self addSubview:downLineView];
    }
    
    return self;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect screenRect = [UIScreen mainScreen].bounds;
        
        backView = [[UIView alloc] initWithFrame:CGRectMake(TCRealValue(20), TCRealValue(1), screenRect.size.width - TCRealValue(20) - TCRealValue(20), TCRealValue(77 - 2))];
        backView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        [self.contentView addSubview:backView];
        
        _leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.height / 2 - TCRealValue(71.5) / 2, backView.height / 2 - TCRealValue(71.5) / 2, TCRealValue(71.5), TCRealValue(71.5))];
        [backView addSubview:_leftImgView];
        
        titleLab = [TCComponent createLabelWithFrame:CGRectMake(_leftImgView.x + _leftImgView.width + TCRealValue(9), 12, TCRealValue(337 / 2), TCRealValue(12)) AndFontSize:TCRealValue(12) AndTitle:@""];
        [backView addSubview:titleLab];
        
        priceLab = [self getNumberOrPriceLabelWithFrame:CGRectMake(titleLab.x + titleLab.width + TCRealValue(1), titleLab.y, screenRect.size.width - TCRealValue(20) - TCRealValue(11) - titleLab.x - titleLab.width - TCRealValue(1) - TCRealValue(20), TCRealValue(13))];
        [backView addSubview:priceLab];
        
        numberLab = [self getNumberOrPriceLabelWithFrame:CGRectMake(priceLab.x, priceLab.y + priceLab.height + TCRealValue(5), priceLab.width, TCRealValue(13))];
        [backView addSubview:numberLab];
        
    }
    return self;
}



- (UILabel *)getNumberOrPriceLabelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:TCRealValue(12)];
    label.textAlignment = NSTextAlignmentRight;
    
    return label;
}

- (NSDictionary *)getSelectesStandardDic:(NSString *)standard {
    if (![standard containsString:@":"]) {
        return nil;
    }
    if ([standard containsString:@":"] && ![standard containsString:@"|"]) {
        NSArray *standardArr = [standard componentsSeparatedByString:@":"];
        return @{
                 @"primary":@{
                     @"label":standardArr[0],
                     @"types":standardArr[1]
                 }
                 };
    }
    if ([standard containsString:@":"] && [standard containsString:@"|"]) {
        NSArray *standardArr = [standard componentsSeparatedByString:@"|"];
        NSArray *primaryArr = [standardArr[0] componentsSeparatedByString:@":"];
        NSArray *secondaryArr = [standardArr[1] componentsSeparatedByString:@":"];
        return @{
                 @"primary": @{ @"label":primaryArr[0], @"types":primaryArr[1] },
                 @"secondary":@{  @"label":secondaryArr[0], @"types":secondaryArr[1] }
                 };
    }
    
    return nil;
}

- (void)setSelectedStandard:(NSString *)standardStr{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_leftImgView.x + _leftImgView.width + TCRealValue(9), _leftImgView.height + _leftImgView.y - TCRealValue(20), [UIScreen mainScreen].bounds.size.width - TCRealValue(20) - TCRealValue(71.5) - TCRealValue(20) - TCRealValue(9), TCRealValue(13))];
    NSDictionary *standard = [self getSelectesStandardDic:standardStr];
    if (standard[@"secondary"] == NULL && standard[@"primary"] != NULL) {
        UILabel *primaryStandardLab = [self getStandardLabelWithOrigin:CGPointMake(0, 0) AndText:[NSString stringWithFormat:@"%@ : %@", standard[@"primary"][@"label"], standard[@"primary"][@"types"]]];
        [view addSubview:primaryStandardLab];
    } else if (standard[@"secondary"] != NULL) {
        NSString *standardStr = [NSString stringWithFormat:@"%@ : %@      %@ : %@", standard[@"primary"][@"label"], standard[@"primary"][@"types"], standard[@"secondary"][@"label"], standard[@"secondary"][@"types"]];
        UILabel *standardLab = [self getStandardLabelWithOrigin:CGPointMake(0, 0) AndText:standardStr];
        [view addSubview:standardLab];
    }
    [backView addSubview:view];
}

- (void)setNumberLabel:(float)number {
    NSString *numberStr = [NSString stringWithFormat:@"x %@", @([NSString stringWithFormat:@"%f", number].floatValue)];
    numberLab.text = numberStr;
}

- (void)setBoldNumberLabel:(float)number {
    NSString *numberStr = [NSString stringWithFormat:@"x%@", @([NSString stringWithFormat:@"%f", number].floatValue)];
    numberLab.font = [UIFont systemFontOfSize:TCRealValue(13)];
    numberLab.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    
    UIImageView *writeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.width - TCRealValue(13), _leftImgView.height + _leftImgView.y - TCRealValue(20) + TCRealValue(1), TCRealValue(11), TCRealValue(11))];
    writeImgView.image = [UIImage imageNamed:@"order_write"];
    
    numberLab.frame = CGRectMake(writeImgView.x - TCRealValue(50) - TCRealValue(2), _leftImgView.height + _leftImgView.y - TCRealValue(20), TCRealValue(50), TCRealValue(13));
    numberLab.text = numberStr;
    [backView addSubview:writeImgView];
    
}

- (void)setPriceLabel:(float)price {
    NSString *priceStr = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", price].floatValue)];
    priceLab.text = priceStr;
}

- (void)setBoldPriceLabel:(float)price {
    NSString *priceStr = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", price].floatValue)];
    priceLab.text = priceStr;
    priceLab.frame = CGRectMake(_leftImgView.x + _leftImgView.width + TCRealValue(1), titleLab.y + titleLab.height + TCRealValue(2), [UIScreen mainScreen].bounds.size.width - TCRealValue(40) - _leftImgView.x - _leftImgView.width - TCRealValue(1), TCRealValue(14));
}

- (void)setTitleLabWithText:(NSString *)text {
    titleLab.lineBreakMode = NSLineBreakByWordWrapping;
    titleLab.numberOfLines = TCRealValue(2);
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: titleLab.font}];
    if (size.width > titleLab.width) {
        [titleLab setHeight:TCRealValue((12 * 2) + 5)];
    }
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    NSRange range = NSMakeRange(0, text.length);
    [textAttr addAttribute:NSParagraphStyleAttributeName value:style range:range];
    titleLab.attributedText = textAttr;
    
}

- (UILabel *)getStandardLabelWithOrigin:(CGPoint)point AndText:(NSString *)text{
    
    UILabel *label = [TCComponent createLabelWithText:text AndFontSize:TCRealValue(12)];
    [label setOrigin:point];
    label.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    
    return label;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
