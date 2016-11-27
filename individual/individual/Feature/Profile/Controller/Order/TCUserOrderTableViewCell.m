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
    CGRect screenRect = [UIScreen mainScreen].bounds;
    CGFloat height = 96.5;
    backView.frame = CGRectMake(20, height / 2 - 79 / 2, screenRect.size.width - 40, height);
    backView.backgroundColor = [UIColor whiteColor];
    
    _leftImgView.frame = CGRectMake(8, 0, 79, 79);
    titleLab.frame = CGRectMake(_leftImgView.x + _leftImgView.width + 9, _leftImgView.y + 7, screenRect.size.width - _leftImgView.x - _leftImgView.width - 13 - 54, 12);
    
    priceLab.font = [UIFont fontWithName:BOLD_FONT size:14];
    
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, screenRect.size.width - 40, 0.5)];
    [self addSubview:topLineView];
    
    UIView *downLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, height - 0.5, screenRect.size.width - 40, 0.5)];
    [self addSubview:downLineView];
    
    return self;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect screenRect = [UIScreen mainScreen].bounds;
        
        backView = [[UIView alloc] initWithFrame:CGRectMake(20, 1, screenRect.size.width - 20 - 20, 77 - 2)];
        backView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        [self.contentView addSubview:backView];
        
        _leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.height / 2 - 71.5 / 2, backView.height / 2 - 71.5 / 2, 71.5, 71.5)];
        [backView addSubview:_leftImgView];
        
        titleLab = [TCComponent createLabelWithFrame:CGRectMake(_leftImgView.x + _leftImgView.width + 9, 12, screenRect.size.width / 2, 12) AndFontSize:12 AndTitle:@""];
        [backView addSubview:titleLab];
        
        priceLab = [self getNumberOrPriceLabelWithFrame:CGRectMake(titleLab.x + titleLab.width + 1, titleLab.y, screenRect.size.width - 20 - 11 - titleLab.x - titleLab.width - 1 - 20, 13)];
        [backView addSubview:priceLab];
        
        numberLab = [self getNumberOrPriceLabelWithFrame:CGRectMake(priceLab.x, priceLab.y + priceLab.height + 5, priceLab.width, 13)];
        [backView addSubview:numberLab];
        
    }
    return self;
}



- (UILabel *)getNumberOrPriceLabelWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentRight;
    
    return label;
}

- (void)setSelectedStandardWithDic:(NSDictionary *)standard{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(_leftImgView.x + _leftImgView.width + 9, _leftImgView.height + _leftImgView.y - 20, [UIScreen mainScreen].bounds.size.width - 20 - 71.5 - 20 - 9, 13)];
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
    numberLab.font = [UIFont systemFontOfSize:13];
    numberLab.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    
    UIImageView *writeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(backView.width - 13, _leftImgView.height + _leftImgView.y - 20 + 1, 11, 11)];
    writeImgView.image = [UIImage imageNamed:@"map_div"];
    
    numberLab.frame = CGRectMake(writeImgView.x - 50 - 2, _leftImgView.height + _leftImgView.y - 20, 50, 13);
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
    priceLab.frame = CGRectMake(_leftImgView.x + _leftImgView.width + 1, titleLab.y + titleLab.height, [UIScreen mainScreen].bounds.size.width - 40 - _leftImgView.x - _leftImgView.width - 1, 14);
}

- (void)setTitleLabWithText:(NSString *)text {
    titleLab.lineBreakMode = NSLineBreakByWordWrapping;
    titleLab.numberOfLines = 2;
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: titleLab.font}];
    if (size.width > titleLab.width) {
        [titleLab setHeight:(12 * 2) + 5];
    }
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    NSRange range = NSMakeRange(0, text.length);
    [textAttr addAttribute:NSParagraphStyleAttributeName value:style range:range];
    titleLab.attributedText = textAttr;
    
}

- (UILabel *)getStandardLabelWithOrigin:(CGPoint)point AndText:(NSString *)text{
    
    UILabel *label = [TCComponent createLabelWithText:text AndFontSize:12];
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
