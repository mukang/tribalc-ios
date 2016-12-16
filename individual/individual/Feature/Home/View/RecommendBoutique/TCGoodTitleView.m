//
//  TCGoodTitleView.m
//  individual
//
//  Created by WYH on 16/11/25.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodTitleView.h"

@implementation TCGoodTitleView {
    UIImageView *tagImgView;
}

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title AndPrice:(float)price AndOriginPrice:(float)originPrice AndTags:(NSArray *)tags{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLab = [self createTitleLabelWithText:title WithFrame:CGRectMake(TCRealValue(20), TCRealValue(15), frame.size.width - TCRealValue(40), TCRealValue(16))];
        [self addSubview:_titleLab];
        
        [self initSalePriceLabelWithPrice:price];
        
        _originPriceLab = [self getOriginPriceLabelWithFrame:CGRectMake(_priceDecimalLab.x + _priceDecimalLab.width + TCRealValue(16), _priceDecimalLab.y, 0, TCRealValue(12)) AndOriginPrice:originPrice];
        [self addSubview:_originPriceLab];

        [self setHeight:_priceIntegerLab.y + _priceIntegerLab.height + TCRealValue(16)];
        
        _tagLab = [self createTagLabelWithTag:tags];
        [_tagLab setOrigin:CGPointMake(self.width - TCRealValue(20) - _tagLab.width, _priceDecimalLab.y)];
        [self addSubview:_tagLab];
        
        tagImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_tagLab.x - TCRealValue(12), _tagLab.y + TCRealValue(2.5), TCRealValue(11), TCRealValue(12))];
        tagImgView.image = [UIImage imageNamed:@"good_tag"];
        [self addSubview:tagImgView];
        
        
    }
    return self;
}

- (void)setSalePriceWithPrice:(float)price {
    NSString *floatPriceStr = [NSString stringWithFormat:@"%f", price];
    NSString *accuratePriceStr = [NSString stringWithFormat:@"%@", @(floatPriceStr.floatValue)];
    
    NSString *priceIntegerStr = [NSString stringWithFormat:@"￥%i", (int)price];
    _priceIntegerLab.text = priceIntegerStr;
    
    [_priceDecimalLab setX:_priceIntegerLab.x + _priceIntegerLab.width];
    
    if ([accuratePriceStr rangeOfString:@"."].location != NSNotFound) {
        NSString *priceDecimalStr = [accuratePriceStr componentsSeparatedByString:@"."][1];
        _priceDecimalLab.text = [NSString stringWithFormat:@".%@", priceDecimalStr];
    } else {
        _priceDecimalLab.text = [NSString stringWithFormat:@""];
    }
    
    [_priceDecimalLab sizeToFit];

}

- (void)setOriginPriceLabWithOriginPrice:(float)originPrice {
    NSString *originStr = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", originPrice].floatValue)];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:originStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TCRealValue(12)], NSForegroundColorAttributeName:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1], NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle|NSUnderlinePatternSolid), NSStrikethroughColorAttributeName:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1]}];
    
    _originPriceLab.attributedText = attrStr;
    _originPriceLab.x = _priceDecimalLab.x + _priceDecimalLab.width + TCRealValue(12);
    [_originPriceLab sizeToFit];
}

- (void)setTagLabWithTagArr:(NSArray *)tags {
    NSString *tagStr = tags[0];
    for (int i = 0; i < tags.count; i++) {
        tagStr = [NSString stringWithFormat:@"%@/%@", tagStr, tags[i]];
    }
    _tagLab.text = tagStr;
    [_tagLab sizeToFit];
    [_tagLab setOrigin:CGPointMake(self.width - TCRealValue(20) - _tagLab.width, _priceDecimalLab.y)];
    tagImgView.origin = CGPointMake(_tagLab.x - TCRealValue(12), _tagLab.y);
}

- (UILabel *)createTagLabelWithTag:(NSArray *)tags {
    NSArray *tagArr = tags;
    NSString *tagStr = tagArr[0];
    for (int i = 1; i < tagArr.count; i++) {
        tagStr = [NSString stringWithFormat:@"%@/%@", tagStr, tagArr[i]];
    }
    UILabel *label = [TCComponent createLabelWithText:tagStr AndFontSize:11];
    label.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    [label setHeight:TCRealValue(17)];
    return label;
}



- (void)initSalePriceLabelWithPrice:(float)price {
    NSString *floatPriceStr = [NSString stringWithFormat:@"%f", price];
    NSString *accuratePriceStr = [NSString stringWithFormat:@"%@", @(floatPriceStr.floatValue)];
    
    NSString *priceIntegerStr = [NSString stringWithFormat:@"￥%i", (int)price];
    _priceIntegerLab = [self createPriceLabelWithOrigin:CGPointMake(TCRealValue(20), _titleLab.y + _titleLab.height + TCRealValue(16)) AndFontSize:TCRealValue(17) AndText:priceIntegerStr];
    [self addSubview:_priceIntegerLab];
    
    if ([accuratePriceStr rangeOfString:@"."].location != NSNotFound) {
        NSString *priceDecimalStr = [accuratePriceStr componentsSeparatedByString:@"."][1];
        priceDecimalStr = [NSString stringWithFormat:@".%@", priceDecimalStr];
        _priceDecimalLab = [self createPriceLabelWithOrigin:CGPointMake(_priceIntegerLab.x + _priceIntegerLab.width, _priceIntegerLab.y + TCRealValue(17) - TCRealValue(12)) AndFontSize:TCRealValue(12) AndText:priceDecimalStr];
    } else {
        _priceDecimalLab = [[UILabel alloc] initWithFrame:CGRectMake(_priceIntegerLab.x + _priceIntegerLab.width, _priceIntegerLab.y + TCRealValue(17) - TCRealValue(12), 0, 0)];
    }
    [self addSubview:_priceDecimalLab];

}

- (UILabel *)getOriginPriceLabelWithFrame:(CGRect)frame AndOriginPrice:(float)originalPrice {
    NSString *accuratePriceStr = [NSString stringWithFormat:@"%@", @([NSString stringWithFormat:@"%f", originalPrice].floatValue)];
    NSString *originalPriceStr = [NSString stringWithFormat:@"￥%@", accuratePriceStr];
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:TCRealValue(12)];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:originalPriceStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:frame.size.height], NSForegroundColorAttributeName:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1], NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle|NSUnderlinePatternSolid), NSStrikethroughColorAttributeName:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1]}];
    ;
    label.attributedText = attrStr;
    [label sizeToFit];
    
    return label;
}

- (void)setupTitleWithText:(NSString *)text {
    CGSize labelSize = {0, 0};
    labelSize = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(15)]}];

    _titleLab.frame = CGRectMake(TCRealValue(20), TCRealValue(15), self.size.width - TCRealValue(40), TCRealValue(16));
    if (labelSize.width > _titleLab.width) {
        [_titleLab setHeight:2 * _titleLab.height + TCRealValue(13)];
    }
    _titleLab.text = text;
    _titleLab.numberOfLines = TCRealValue(2);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = TCRealValue(3);
    NSRange range = NSMakeRange(0, text.length);
    text = text ? text : @"";
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text];
    [textAttr addAttribute:NSParagraphStyleAttributeName value:style range:range];
    _titleLab.attributedText = textAttr;
    _titleLab.lineBreakMode = NSLineBreakByCharWrapping;


}

- (UILabel *)createTitleLabelWithText:(NSString *)text WithFrame:(CGRect)frame{
    
    
    CGSize labelSize = {0, 0};
    labelSize = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:TCRealValue(15)]}];
    
    UILabel *label =  [TCComponent createLabelWithFrame:frame AndFontSize:TCRealValue(15) AndTitle:text AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
    if (labelSize.width > label.width) {
        [label setHeight:2 * label.height + TCRealValue(8)];
    }
    label.text = text;
    label.numberOfLines = TCRealValue(2);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = TCRealValue(3);
    NSRange range = NSMakeRange(0, text.length);
    text = text ? text : @"";
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text];
    [textAttr addAttribute:NSParagraphStyleAttributeName value:style range:range];
    label.attributedText = textAttr;
    
    
    label.lineBreakMode = NSLineBreakByCharWrapping;
    
    return label;
}


- (UILabel *)createPriceLabelWithOrigin:(CGPoint)point AndFontSize:(float)fontSize AndText:(NSString *)text {
    UILabel *label = [TCComponent createLabelWithText:text AndFontSize:fontSize];
    label.origin = point;
    label.font = [UIFont fontWithName:BOLD_FONT size:fontSize];
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    
    return label;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
