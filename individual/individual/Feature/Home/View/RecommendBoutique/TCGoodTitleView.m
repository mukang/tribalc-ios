//
//  TCGoodTitleView.m
//  individual
//
//  Created by WYH on 16/11/25.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodTitleView.h"

@implementation TCGoodTitleView

- (instancetype)initWithFrame:(CGRect)frame WithTitle:(NSString *)title AndPrice:(float)price AndOriginPrice:(float)originPrice AndTags:(NSArray *)tags{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLab = [self createTitleLabelWithText:title WithFrame:CGRectMake(20, 15, frame.size.width - 40, 16)];
        [self addSubview:_titleLab];
        
        [self initSalePriceLabelWithPrice:price];
        
        _originPriceLab = [self getOriginPriceLabelWithFrame:CGRectMake(_priceDecimalLab.x + _priceDecimalLab.width + 18, _priceIntegerLab.y + 5, 0, 17-5) AndOriginPrice:originPrice];
        [self addSubview:_originPriceLab];

        [self setHeight:_priceIntegerLab.y + _priceIntegerLab.height + 20];
        
        _tagLab = [self createTagLabelWithTag:tags];
        [_tagLab setOrigin:CGPointMake(self.width - 20 - _tagLab.width, _priceDecimalLab.y)];
        [self addSubview:_tagLab];
        
        
    }
    return self;
}

- (void)setSalePriceWithPrice:(float)price {
    NSString *priceIntegerStr = [NSString stringWithFormat:@"￥%i", (int)price];
    _priceIntegerLab.text = priceIntegerStr;
    
    [_priceDecimalLab setX:_priceIntegerLab.x + _priceIntegerLab.width];
    
    if ([[self changeFloat:price] rangeOfString:@"."].location != NSNotFound) {
        NSString *priceDecimalStr = [[self changeFloat:price] componentsSeparatedByString:@"."][1];
        _priceDecimalLab.text = [NSString stringWithFormat:@".%@", priceDecimalStr];
    } else {
        _priceDecimalLab.text = [NSString stringWithFormat:@""];
    }
    
    [_priceDecimalLab sizeToFit];

}

- (void)setOriginPriceLabWithOriginPrice:(float)originPrice {
    NSString *originStr = [NSString stringWithFormat:@"￥%@", [self changeFloat:originPrice]];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:originStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12], NSForegroundColorAttributeName:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1], NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle|NSUnderlinePatternSolid), NSStrikethroughColorAttributeName:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1]}];
    
    _originPriceLab.attributedText = attrStr;
    _originPriceLab.x = _priceDecimalLab.x + _priceDecimalLab.width + 18;
    [_originPriceLab sizeToFit];
}

- (void)setTagLabWithTagArr:(NSArray *)tags {
    NSString *tagStr = tags[0];
    for (int i = 0; i < tags.count; i++) {
        tagStr = [NSString stringWithFormat:@"%@/%@", tagStr, tags[i]];
    }
    _tagLab.text = tagStr;
    [_tagLab sizeToFit];
    [_tagLab setOrigin:CGPointMake(self.width - 20 - _tagLab.width, _priceDecimalLab.y)];
}

- (UILabel *)createTagLabelWithTag:(NSArray *)tags {
    NSArray *tagArr = tags;
    NSString *tagStr = tagArr[0];
    for (int i = 1; i < tagArr.count; i++) {
        tagStr = [NSString stringWithFormat:@"%@/%@", tagStr, tagArr[i]];
    }
    UILabel *label = [TCComponent createLabelWithText:tagStr AndFontSize:11];
    label.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    [label setHeight:17];
    return label;
}



- (void)initSalePriceLabelWithPrice:(float)price {
    NSString *priceIntegerStr = [NSString stringWithFormat:@"￥%i", (int)price];
    _priceIntegerLab = [self createPriceLabelWithOrigin:CGPointMake(20, _titleLab.y + _titleLab.height + 20) AndFontSize:17 AndText:priceIntegerStr];
    [self addSubview:_priceIntegerLab];
    
    if ([[self changeFloat:price] rangeOfString:@"."].location != NSNotFound) {
        NSString *priceDecimalStr = [[self changeFloat:price] componentsSeparatedByString:@"."][1];
        priceDecimalStr = [NSString stringWithFormat:@".%@", priceDecimalStr];
        _priceDecimalLab = [self createPriceLabelWithOrigin:CGPointMake(_priceIntegerLab.x + _priceIntegerLab.width, _priceIntegerLab.y + 17 - 12) AndFontSize:12 AndText:priceDecimalStr];
    } else {
        _priceDecimalLab = [[UILabel alloc] initWithFrame:CGRectMake(_priceIntegerLab.x + _priceIntegerLab.width, _priceIntegerLab.y + 17 - 12, 0, 0)];
    }
    [self addSubview:_priceDecimalLab];

}

- (UILabel *)getOriginPriceLabelWithFrame:(CGRect)frame AndOriginPrice:(float)originalPrice {
    NSString *originalPriceStr = [NSString stringWithFormat:@"￥%@", [self changeFloat: originalPrice]];
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:12];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:originalPriceStr attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:frame.size.height], NSForegroundColorAttributeName:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1], NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle|NSUnderlinePatternSolid), NSStrikethroughColorAttributeName:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1]}];
    ;
    label.attributedText = attrStr;
    [label sizeToFit];
    
    return label;
}

- (UILabel *)createTitleLabelWithText:(NSString *)text WithFrame:(CGRect)frame{
    CGSize labelSize = {0, 0};
    labelSize = [text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    UILabel *label =  [TCComponent createLabelWithFrame:frame AndFontSize:16 AndTitle:text AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
    label.text = text;
    label.numberOfLines = 2;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 7.0f;
    NSRange range = NSMakeRange(0, text.length);
    
    NSLog(@"%@", text);
    NSMutableAttributedString *textAttr = [[NSMutableAttributedString alloc] initWithString:text];
    [textAttr addAttribute:NSParagraphStyleAttributeName value:style range:range];
    label.attributedText = textAttr;
    
    if (labelSize.width > label.width) {
        [label setHeight:2 * label.height + 17];
    }
    [label sizeToFit];
    
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


-(NSString *)changeFloat:(double)flo
{
    
    NSString *stringFloat = [NSString stringWithFormat:@"%f", flo];
    const char *floatChars = [stringFloat UTF8String];
    NSUInteger length = [stringFloat length];
    int zeroLength = 0;
    NSUInteger i = length-1;
    for(; (int)i>=0; i--)
    {
        if(floatChars[i] == '0'/*0x30*/) {
            zeroLength++;
        } else {
            if(floatChars[i] == '.')
                i--;
            break;
        }
    }
    NSString *returnString;
    if(i == -1) {
        returnString = @"0";
    } else {
        returnString = [stringFloat substringToIndex:i+1];
    }
    return returnString;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
