//
//  TCSelectStandardView.m
//  individual
//
//  Created by WYH on 16/12/8.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCSelectStandardView.h"
#import "TCBuluoApi.h"
#import "TCImageURLSynthesizer.h"
#import "TCComponent.h"
#import "TCClientConfig.h"
#import "NSObject+TCModel.h"

@implementation TCSelectStandardView {
    TCGoodDetail *mGoodDetail;
    TCGoodStandards *mGoodStandards;
    UIImageView *titleImageView;
    UILabel *priceLab;
    UILabel *inventoryLab;
    
    UIView *primarySelectButtonView;
    UIView *secondarySelectBtnView;
    
    NSString *selectTag;
}

- (instancetype)initWithGoodsId:(NSString *)goodsId AndSelectTag:(NSString *)tag{
    selectTag = tag;
    self = [super initWithFrame:CGRectMake(0, 0, TCScreenWidth, TCScreenHeight)];
    if (self) {
        [self fetchGoodDetailWithGoodsId:goodsId];
    }
    return self;
}

- (void)fetchGoodDetailWithGoodsId:(NSString *)goodsId {
    [[TCBuluoApi api] fetchGoodDetail:goodsId result:^(TCGoodDetail *goodDetail, NSError *error) {
        mGoodDetail = goodDetail;
        [self fetchGoodStandardWithStandardId:goodDetail.standardId];
    }];
}

- (void)fetchGoodStandardWithStandardId:(NSString *)standardId {
    [[TCBuluoApi api] fetchGoodStandards:standardId result:^(TCGoodStandards *goodStandard, NSError *error) {
        mGoodStandards = goodStandard;
        [self initUIWithGoodStandard:goodStandard];
    }];
}

- (void)initUIWithGoodStandard:(TCGoodStandards *)goodStandard {
    
    UIView *standardView = [[UIView alloc] initWithFrame:CGRectMake(0, TCScreenHeight, TCScreenWidth, TCScreenHeight)];
    standardView.backgroundColor = [UIColor whiteColor];
    
    UIView *titleView = [self getTitleViewWithFrame:CGRectMake(0, 0, TCScreenWidth, 118)];
    [standardView addSubview:titleView];
    
    UIView *standardSelectView = [self getStandardSelectViewWithOrigin:CGPointMake(0, titleView.y + titleView.height) AndGoodStandard:goodStandard];
    [standardView addSubview:standardSelectView];
    
    UIView *selectNumberView = [self getSelectNumberViewWithFrame:CGRectMake(0, standardSelectView.y + standardSelectView.height, TCScreenWidth, 89)];
    if (goodStandard.description == nil) {
        selectNumberView.y = 118;
    }
    [standardView addSubview:selectNumberView];
    
    UIButton *confirmBtn = [self getBottomBtnWithFrame:CGRectMake(0, standardSelectView.y + standardSelectView.height + 89, TCScreenWidth, 49)];
    [standardView addSubview:confirmBtn];
    
    standardView.height = confirmBtn.y + confirmBtn.height;
    
    
    UIView *backView = [self createBlankViewWithFrame:CGRectMake(0, 0, TCScreenWidth, standardView.y)];
    [self addSubview:backView];
    [self addSubview:standardView];
    [self startShowStandardView:standardView];
    
}

- (void)startShowStandardView:(UIView *)standardView {
    [UIView animateWithDuration:0.2 animations:^(void) {
        standardView.y = TCScreenHeight - standardView.height;
    }];
}


- (UIView *)createBlankViewWithFrame:(CGRect)frame {
    UIView *blankView = [[UIView alloc] initWithFrame:frame];
    blankView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UITapGestureRecognizer *hideSelectRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchHideSelect:)];
    [blankView addGestureRecognizer:hideSelectRecognizer];
    
    return blankView;
}


- (UIButton *)getBottomBtnWithFrame:(CGRect)frame {
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:frame];
    
    bottomBtn.backgroundColor = TCRGBColor(81, 199, 209);
    [bottomBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(touchConfirmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return bottomBtn;
}

- (UIView *)getStandardSelectViewWithOrigin:(CGPoint)point AndGoodStandard:(TCGoodStandards *)goodStandard {
    UIView *standardView = [[UIView alloc] initWithFrame:CGRectMake(point.x, point.y, TCScreenWidth, 0)];
    if (goodStandard.descriptions.allKeys.count == 0) {
        standardView.height = 194;
    } else {
        UIView *primaryView = [self getStandardPrimarySelectViewWithFrame:CGRectMake(0, 0, TCScreenWidth, 0) AndGoodStandard:goodStandard];
        [standardView addSubview:primaryView];
        standardView.height = primaryView.y + primaryView.height;

        if (goodStandard.descriptions.allKeys.count == 2) {
            UIView * secondaryView = [self getStandardSecondarySelectViewWithFrame:CGRectMake(0, primaryView.y + primaryView.height, TCScreenWidth, 0) AndGoodStandard:goodStandard];
            [standardView addSubview:secondaryView];
            standardView.height = secondaryView.y + secondaryView.height;
        }
    }
    
    return standardView;
}

- (UIView *)getTitleViewWithFrame:(CGRect)frame {
    UIView *titleView = [[UIView alloc] initWithFrame:frame];
    titleImageView = [self getTitleImageViewWithFrame:CGRectMake(20, frame.size.height - 12 - 115, 115, 115)];
    [titleView addSubview:titleImageView];
    
    UIButton *closeBtn = [TCComponent createImageBtnWithFrame:CGRectMake(TCScreenWidth - 20 - 20, 15, 20, 20) AndImageName:@"good_close"];
    [closeBtn addTarget:self action:@selector(touchCloseBtn) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:closeBtn];
    
    NSString *priceStr = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", mGoodDetail.salePrice].floatValue)];
    priceLab = [TCComponent createLabelWithFrame:CGRectMake(titleImageView.x + titleImageView.width + 12, 20, TCScreenWidth - titleImageView.x - 12 , 20) AndFontSize:20 AndTitle:priceStr AndTextColor:TCRGBColor(81, 199, 209)];
    [titleView addSubview:priceLab];
    
    inventoryLab = [TCComponent createLabelWithFrame:CGRectMake(priceLab.x, priceLab.y + priceLab.height + 10, priceLab.width, 12) AndFontSize:12 AndTitle:[NSString stringWithFormat:@"(剩余:%li件)", (long)mGoodDetail.repertory] AndTextColor:TCRGBColor(154, 154, 154)];
    [titleView addSubview:inventoryLab];
    
    UILabel *selectTagLab = [TCComponent createLabelWithFrame:CGRectMake(priceLab.x, inventoryLab.y + inventoryLab.height + 12, 45, 14) AndFontSize:14 AndTitle:@"已选择" AndTextColor:TCRGBColor(42, 42, 42)];
    [titleView addSubview:selectTagLab];
    
    UIView *selectedView = [self getSelectedViewWithFrame:CGRectMake(selectTagLab.x + selectTagLab.width + 4, selectTagLab.y - 1, TCScreenWidth - selectTagLab.x - selectTagLab.width - 2, selectTagLab.height)];
    [titleView addSubview:selectedView];
    
    
    return titleView;
}


- (UIView *)getStandardSelectBaseViewWithFrame:(CGRect)frame AndGoodStandard:(TCGoodStandards *)goodStandards AndTitle:(NSString *)title {
    UIView *standardSelectView = [[UIView alloc] initWithFrame:frame];
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, TCScreenWidth - 40, 1)];
    [standardSelectView addSubview:topLineView];
    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(20, 15, TCScreenWidth - 20, 14) AndFontSize:14 AndTitle:goodStandards.descriptions[@"primary"][@"label"]];
    titleLab.font = [UIFont fontWithName:BOLD_FONT size:14];
    [standardSelectView addSubview:titleLab];

    return standardSelectView;
}

- (UIView *)getStandardPrimarySelectViewWithFrame:(CGRect)frame AndGoodStandard:(TCGoodStandards *)goodStandards{
    UIView *primaryView = [self getStandardSelectBaseViewWithFrame:frame AndGoodStandard:goodStandards AndTitle:goodStandards.descriptions[@"primary"][@"label"]];
    
    primarySelectButtonView = [self getStandardPrimaryButtonViewWithFrame:CGRectMake(20, 15 + 14 + 15, frame.size.width - 40, 0) AndGoodStandard:goodStandards];
    [primaryView addSubview:primarySelectButtonView];
    
    primaryView.height = primarySelectButtonView.y + primarySelectButtonView.height + 20;
    return primaryView;
}

- (UIView *)getStandardSecondarySelectViewWithFrame:(CGRect)frame AndGoodStandard:(TCGoodStandards *)goodStandards {
    UIView *secondaryView = [self getStandardSelectBaseViewWithFrame:frame AndGoodStandard:goodStandards AndTitle:goodStandards.descriptions[@"secondary"][@"label"]];
    
    secondarySelectBtnView = [self getStandardSecondaryButtonViewWithFrame:CGRectMake(20, 15 + 14 + 15, frame.size.width - 40, 0) AndGoodStandard:goodStandards];
    [secondaryView addSubview:secondarySelectBtnView];
    
    secondaryView.height = secondarySelectBtnView.y + secondarySelectBtnView.height + 20;
    
    for (int i = 0; i < primarySelectButtonView.subviews.count; i++) {
        if ([primarySelectButtonView.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *primaryBtn = primarySelectButtonView.subviews[i];
            if ([[primaryBtn titleForState:UIControlStateNormal] isEqualToString:_primaryStandardLab.text]) {
                [self setupPrimarySelectedButton:primaryBtn AndStandard:mGoodStandards];
            }
        }
    }
    
    return secondaryView;
}


- (UIView *)getStandardPrimaryButtonViewWithFrame:(CGRect)frame AndGoodStandard:(TCGoodStandards *)goodStandards {
    UIView *selectView = [[UIView alloc] initWithFrame:frame];
    CGFloat height = 0;
    CGFloat width = 0;
    NSArray *primaryArr = goodStandards.descriptions[@"primary"][@"types"];
    for (int i = 0; i < primaryArr.count; i++) {
        UIButton *selectButton = [self getPrimaryButtonWithOrigin:CGPointMake(width, height) AndTitle:primaryArr[i] AndGoodStandards:goodStandards];
        if (width > frame.size.width) {
            width = 0;
            height += 24 + 12;
            selectButton.origin = CGPointMake(width, height);
        }
        width += selectButton.width + 13;
        [selectView addSubview:selectButton];
        selectView.height = selectButton.y + selectButton.height;
    }
    
    return selectView;
}

- (UIView *)getStandardSecondaryButtonViewWithFrame:(CGRect)frame AndGoodStandard:(TCGoodStandards *)goodStandards {
    UIView *selectView = [[UIView alloc] initWithFrame:frame];
    CGFloat height = 0;
    CGFloat width = 0;
    NSArray *secondaryArr = goodStandards.descriptions[@"secondary"][@"types"];

    for (int i = 0; i < secondaryArr.count; i++) {
        UIButton *selectButton = [self getSecondaryButtonWithOrigin:CGPointMake(width, height) AndTitle:secondaryArr[i] AndGoodStandards:goodStandards];
        if (width + selectButton.width > frame.size.width) {
            width = 0;
            height += 22 + 12;
            selectButton.origin = CGPointMake(width, height);
        }
        width += selectButton.width + 11;
        [selectView addSubview:selectButton];
        selectView.height = selectButton.y + selectButton.height;;
    }
    
    return selectView;
}


- (UIButton *)getSecondaryButtonWithOrigin:(CGPoint)point AndTitle:(NSString *)title AndGoodStandards:(TCGoodStandards *)goodStandard{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(point.x, point.y, 47.5, 22)];
    button.layer.cornerRadius = 11;
    button.backgroundColor = TCRGBColor(242, 242, 242);
    [button setTitleColor:TCRGBColor(42, 42, 42) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button sizeToFit];
    [button addTarget:self action:@selector(touchSecondaryStandardBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (button.width > 47.5 - 14) {
        button.size = CGSizeMake(button.width + 14, 22);
    } else {
        button.size = CGSizeMake(47.5, 22);
    }
    NSString *secondaryStr = [mGoodDetail.standardSnapshot componentsSeparatedByString:@"|"][1];
    NSString *secondaryType = [secondaryStr componentsSeparatedByString:@":"][1];
    if ([title isEqualToString:secondaryType]) {
        [self setupSecondarySelectedButton:button AndStandard:goodStandard];
    }
    
    return button;
}




- (UIButton *)getPrimaryButtonWithOrigin:(CGPoint)point AndTitle:(NSString *)title AndGoodStandards:(TCGoodStandards *)goodStandards{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(point.x, point.y, 51, 24)];
    button.layer.borderWidth = 1;
    button.layer.cornerRadius = 2.5;
    button.layer.borderColor = TCRGBColor(154, 154, 154).CGColor;
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:TCRGBColor(154, 154, 154) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(touchPrimaryStandardBtn:) forControlEvents:UIControlEventTouchUpInside];
    if (button.width > 51 - 14) {
        button.size = CGSizeMake(button.width + 14, 24);
    } else {
        button.size = CGSizeMake(51, 24);
    }
    NSString *type;
    if ([mGoodDetail.standardSnapshot containsString:@"|"]) {
        type = [mGoodDetail.standardSnapshot componentsSeparatedByString:@"|"][0];
        type = [type componentsSeparatedByString:@":"][1];
    } else {
        type = [mGoodDetail.standardSnapshot componentsSeparatedByString:@":"][1];
    }
    if ([type isEqualToString:title]) {
        [self setupPrimarySelectedButton:button AndStandard:goodStandards];
    }
    return button;
    
}


- (UIView *)getSelectNumberViewWithFrame:(CGRect)frame {
    UIView *selectNumberView = [[UIView alloc] initWithFrame:frame];
    
    UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, TCScreenWidth - 40, 1)];
    [selectNumberView addSubview:topLineView];
    
    UILabel *numberTagLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 29, 50, 14)];
    numberTagLab.text = @"数量";
    [selectNumberView addSubview:numberTagLab];
    
    UIButton *addBtn = [self createComputeBtnWithFrame:CGRectMake(frame.size.width - 20 - 38, frame.size.height / 2 - 38 / 5 * 3, 38, 35) AndText:@"+"];
    [addBtn addTarget:self action:@selector(touchAddNumberBtn:) forControlEvents:UIControlEventTouchUpInside];
    [selectNumberView addSubview:addBtn];
    
    _numberLab = [self createBuyNumberLabelWithText:@"1" AndFrame:CGRectMake(addBtn.x - 58, addBtn.y, 58, addBtn.height)];
    [selectNumberView addSubview:_numberLab];
    
    UIButton *subBtn = [self createComputeBtnWithFrame:CGRectMake(_numberLab.x - 38, addBtn.y, 38, 35) AndText:@"-"];
    [subBtn addTarget:self action:@selector(touchSubNumberBtn:) forControlEvents:UIControlEventTouchUpInside];
    [selectNumberView addSubview:subBtn];
    
    return selectNumberView;
}


- (UILabel *)createBuyNumberLabelWithText:(NSString *)text AndFrame:(CGRect)frame{
    UILabel *label = [TCComponent createLabelWithText:text AndFontSize:16 AndTextColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFrame:frame];
    
    return label;
}



- (UIButton *)createComputeBtnWithFrame:(CGRect)frame AndText:(NSString *)text {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [button setTitleColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:text forState:UIControlStateNormal];
    return button;
}


- (void)setupPrimarySelectedButton:(UIButton *)button AndStandard:(TCGoodStandards *)goodStandards{

    [self setupPrimaryLabWithText:[button titleForState:UIControlStateNormal]];
    if (mGoodStandards.descriptions.allKeys.count == 2) {
        [self filterPrimaryButtonWithTitle:[button titleForState:UIControlStateNormal]];
    }
    for (int i = 0; i < button.superview.subviews.count; i++) {
        if ([button.superview.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *noSelectBtn = button.superview.subviews[i];
            if (![[noSelectBtn titleColorForState:UIControlStateNormal] isEqual:TCRGBColor(221, 221, 221)]) {
                noSelectBtn.layer.borderColor = TCRGBColor(154, 154, 154).CGColor;
                [noSelectBtn setTitleColor:TCRGBColor(154, 154, 154) forState:UIControlStateNormal];
            }
        }
    }
    [button setTitleColor:TCRGBColor(81, 199, 209) forState:UIControlStateNormal];
    button.layer.borderColor = TCRGBColor(81, 199, 209).CGColor;
}


- (void)setupSecondarySelectedButton:(UIButton *)button AndStandard:(TCGoodStandards *)goodStandards{
    [self setupSecondaryLabWithText:[button titleForState:UIControlStateNormal]];
    [self filterSecondaryButtonWithTitle:[button titleForState:UIControlStateNormal]];
    for (int i = 0; i < button.superview.subviews.count; i++) {
        if ([button.superview.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *noSelectBtn = button.superview.subviews[i];
            if (![[noSelectBtn titleColorForState:UIControlStateNormal] isEqual:TCRGBColor(221, 221, 221)]) {
                noSelectBtn.backgroundColor = TCRGBColor(242, 242, 242);
                [noSelectBtn setTitleColor:TCRGBColor(42, 42, 42) forState:UIControlStateNormal];
            }
        }
    }
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = TCRGBColor(81, 199, 209);

}

- (void)filterPrimaryButtonWithTitle:(NSString *)title {
    for (int i = 0; i < secondarySelectBtnView.subviews.count; i++) {
        if ([secondarySelectBtnView.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *secondaryBtn = secondarySelectBtnView.subviews[i];
            NSString *indexesStr = [NSString stringWithFormat:@"%@^%@", title, [secondaryBtn titleForState:UIControlStateNormal]];
            if (![self judgeButtonIsEffective:indexesStr AndGoodStandards:mGoodStandards]) {
                secondaryBtn.backgroundColor = TCRGBColor(242, 242, 242);
                [secondaryBtn setTitleColor:TCRGBColor(221, 221, 221) forState:UIControlStateNormal];
            } else {
                if ([[secondaryBtn titleForState:UIControlStateNormal] isEqualToString:_secondaryStandardLab.text]) {
                    secondaryBtn.backgroundColor = TCRGBColor(81, 199, 209);
                    [secondaryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                } else {
                    secondaryBtn.backgroundColor = TCRGBColor(242, 242, 242);
                    [secondaryBtn setTitleColor:TCRGBColor(42, 42, 42) forState:UIControlStateNormal];
                }
            }
        }
    }
}

- (void)filterSecondaryButtonWithTitle:(NSString *)title {
    for (int i = 0; i < primarySelectButtonView.subviews.count; i++) {
        if ([primarySelectButtonView.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *primaryBtn = primarySelectButtonView.subviews[i];
            NSString *indexesStr = [NSString stringWithFormat:@"%@^%@",  [primaryBtn titleForState:UIControlStateNormal], title];
            if (![self judgeButtonIsEffective:indexesStr AndGoodStandards:mGoodStandards]) {
                primaryBtn.layer.borderColor = TCRGBColor(221, 221, 221).CGColor;
                [primaryBtn setTitleColor:TCRGBColor(221, 221, 221) forState:UIControlStateNormal];
            } else {
                if ([[primaryBtn titleForState:UIControlStateNormal] isEqualToString:_primaryStandardLab.text]) {
                    primaryBtn.layer.borderColor = TCRGBColor(81, 199, 209).CGColor;
                    [primaryBtn setTitleColor:TCRGBColor(81, 199, 209) forState:UIControlStateNormal];
                } else {
                    primaryBtn.layer.borderColor = TCRGBColor(154, 154, 154).CGColor;
                    [primaryBtn setTitleColor:TCRGBColor(154, 154, 154) forState:UIControlStateNormal];
                }
            }
        }
    }
}


- (BOOL)judgeButtonIsEffective:(NSString *)title AndGoodStandards:(TCGoodStandards *)goodStandards {
    NSDictionary *goodsIndexes = goodStandards.goodsIndexes;
    for (int i = 0; i < goodsIndexes.allKeys.count; i++) {
        if ([title isEqualToString:goodsIndexes.allKeys[i]]) {
            return YES;
        };
    }
    
    return NO;
}

- (UIView *)getSelectedViewWithFrame:(CGRect)frame {
    UIView *selectedView = [[UILabel alloc] initWithFrame:frame];
    
    _primaryStandardLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
    _primaryStandardLab.font = [UIFont systemFontOfSize:14];
    _primaryStandardLab.textColor = TCRGBColor(81, 199, 209);
    [selectedView addSubview:_primaryStandardLab];
    
    _secondaryStandardLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, frame.size.height)];
    _secondaryStandardLab.font = [UIFont systemFontOfSize:14];
    _secondaryStandardLab.textColor = _primaryStandardLab.textColor;
    [selectedView addSubview:_secondaryStandardLab];
    
    return selectedView;
}

- (void)setupPrimaryLabWithText:(NSString *)text {
    _primaryStandardLab.text = text;
    [_primaryStandardLab sizeToFit];
    
    _secondaryStandardLab.x = _primaryStandardLab.x + _primaryStandardLab.width + 3;
}

- (void)setupSecondaryLabWithText:(NSString *)text {
    _secondaryStandardLab.text = text;
    [_secondaryStandardLab sizeToFit];
}

- (NSString *)getSelectedStrWithStandardSnapshot:(NSString *)standardStr {
    
    if ([standardStr containsString:@":"]) {
        if ([standardStr containsString:@"|"]) {
            NSArray *standardArr = [standardStr componentsSeparatedByString:@"|"];
            NSArray *primaryArr = [standardArr[0] componentsSeparatedByString:@":"];
            NSArray *secondArr = [standardArr[1] componentsSeparatedByString:@":"];
            return [NSString stringWithFormat:@"%@ %@", primaryArr[1], secondArr[1]];
        } else {
            NSArray *primaryArr = [standardStr componentsSeparatedByString:@":"];
            return primaryArr[1];
        }
        
    } else {
        return @"";
    }
}


- (UIImageView *)getTitleImageViewWithFrame:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.layer.borderWidth = 1.5;
    imageView.layer.borderColor = TCRGBColor(242, 242, 242).CGColor;
    imageView.layer.cornerRadius = 5;
    [imageView sd_setImageWithURL:[TCImageURLSynthesizer synthesizeImageURLWithPath:mGoodDetail.mainPicture] ];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.layer.masksToBounds = YES;
    return imageView;
}

- (UIView *)getStandardSelectViewWithFrame:(CGRect)frame {
    UIView *selectStandardView = [[UIView alloc] initWithFrame:frame];
    
    return selectStandardView;
}


- (void)touchPrimaryStandardBtn:(UIButton *)button {
    if (![[button titleColorForState:UIControlStateNormal] isEqual:TCRGBColor(221, 221, 221)]) {
        [self setupPrimarySelectedButton:button AndStandard:mGoodStandards];
        NSString *goodsIndexes;
        if (mGoodStandards.descriptions.allKeys.count == 2) {
            goodsIndexes = [NSString stringWithFormat:@"%@^%@", _primaryStandardLab.text, _secondaryStandardLab.text];
        } else {
            goodsIndexes = [NSString stringWithFormat:@"%@", _primaryStandardLab.text];
        }
        TCGoodDetail *goodDetail = [[TCGoodDetail alloc] initWithObjectDictionary:mGoodStandards.goodsIndexes[goodsIndexes]];
        mGoodDetail = goodDetail;
        [self setupBaseInfoWithGoodDetailDic:goodDetail];
    }
}

- (void)touchSecondaryStandardBtn:(UIButton *)button {
    if (![[button titleColorForState:UIControlStateNormal] isEqual:TCRGBColor(221, 221, 221)]) {
        [self setupSecondarySelectedButton:button AndStandard:mGoodStandards];
        NSString *goodsIndexes = [NSString stringWithFormat:@"%@^%@", _primaryStandardLab.text, _secondaryStandardLab.text];
        TCGoodDetail *goodDetail = [[TCGoodDetail alloc] initWithObjectDictionary:mGoodStandards.goodsIndexes[goodsIndexes]];
        mGoodDetail = goodDetail;
        [self setupBaseInfoWithGoodDetailDic:goodDetail];
    }
}

- (void)setupBaseInfoWithGoodDetailDic:(TCGoodDetail *)goodDetail {
    priceLab.text = [NSString stringWithFormat:@"￥%@", @([NSString stringWithFormat:@"%f", goodDetail.salePrice].floatValue)];
    inventoryLab.text = [NSString stringWithFormat:@"剩余:%ld件", (long)goodDetail.repertory];
    [titleImageView sd_setImageWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, goodDetail.mainPicture]]];
    _numberLab.text = @"1";

}

- (void)touchAddNumberBtn:(UIButton *)button {
    NSInteger number = _numberLab.text.integerValue;
    NSString *inventoryStr = [inventoryLab.text componentsSeparatedByString:@":"][1];
    inventoryStr = [inventoryStr componentsSeparatedByString:@"件"][0];
    NSInteger inventory = inventoryStr.integerValue;
    if (number >= inventory) {
        [MBProgressHUD showHUDWithMessage:@"没有更多的货了"];
    } else {
        _numberLab.text = [NSString stringWithFormat:@"%li", (long)(number + 1)];
    }
}

- (void)touchSubNumberBtn:(UIButton *)button {
    NSInteger number = _numberLab.text.integerValue;
    if (number <= 1) {
        [MBProgressHUD showHUDWithMessage:@"不能再少了"];
    } else {
        _numberLab.text = [NSString stringWithFormat:@"%li", (long)(number - 1)];
    }
}

- (void)touchConfirmBtn:(UIButton *)button {
    NSString *notifiName = [NSString stringWithFormat:@"changeStandard%@", selectTag];
    NSDictionary *changeDic = @{ @"goodsId":mGoodDetail.ID , @"number":_numberLab.text, @"selectTag": selectTag };
    [[NSNotificationCenter defaultCenter] postNotificationName:notifiName object:changeDic];
    [self removeFromSuperview];
}

- (void)touchHideSelect:(id)sender {
    [self removeFromSuperview];
}

- (void)touchCloseBtn {
    [self removeFromSuperview];
}

@end
