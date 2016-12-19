//
//  TCStandardView.m
//  individual
//
//  Created by WYH on 16/11/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStandardView.h"

@implementation TCStandardView {
    UIButton *subBtn;
    UIView *standardView;
    float standardViewPointY;
    UIView *standardSelectView;
    
    UILabel *priceLab;
    UILabel *inventoryLab;
 
    UIView *goodStyleButtonView;
    UIView *goodSizeButtonView;
    
    UIView *computeView;
}



- (instancetype)initWithTarget:(id)target AndNumberAddAction:(SEL)addAction AndNumberSubAction:(SEL)subAction AndAddShopCarAction:(SEL)addCartAction AndBuyAction:(SEL)buyAction AndCloseAction:(SEL)closeAction {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.hidden = YES;
        
        standardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        UIView *selectedInfoView = [self createSelectedInfoViewWithFrame:CGRectMake(0, 0, self.width, TCRealValue(118)) AndTarget:target AndCloseAction:closeAction];
        standardView.backgroundColor = [UIColor whiteColor];
        [standardView addSubview:selectedInfoView];
        
        standardSelectView = [[UIView alloc] initWithFrame:CGRectMake(0, selectedInfoView.y + selectedInfoView.height, self.width, TCRealValue(193))];
        standardSelectView.backgroundColor = [UIColor whiteColor];
        [standardView addSubview:standardSelectView];
        
        computeView = [self createNumberSelectViewWithFrame:CGRectMake(0, standardSelectView.y + standardSelectView.height, self.width, TCRealValue(84)) AndAddAction:addAction AndSubAction:subAction AndTarget:target];
        [standardView addSubview:computeView];
        
        UIView *bottomView = [self createBottomViewWithFrame:CGRectMake(0, computeView.y + computeView.height, self.width, TCRealValue(49)) AndTarget:target AndAddCartAction:addCartAction AndBuyAction:buyAction];
        [standardView addSubview:bottomView];
        
        [standardView setHeight:bottomView.height + bottomView.y];
        [self addSubview:standardView];
        [standardView setY:self.height];
        standardViewPointY = self.height - bottomView.height - bottomView.y;
        
        UIView *blankView = [self createBlankViewWithFrame:CGRectMake(0, 0, self.width, standardViewPointY)];
        [self addSubview:blankView];
        
        
    }
    
    return self;
}


- (UIView *)createSelectedInfoViewWithFrame:(CGRect)frame AndTarget:(id)target AndCloseAction:(SEL)closeAction{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    _selectedImgView = [self createSelectGoodImgViewWithFrame:CGRectMake(TCRealValue(20), TCRealValue(-9), TCRealValue(115), TCRealValue(115))];
    [view addSubview:_selectedImgView];
    
    UILabel *rmbStamp = [TCComponent createLabelWithFrame:CGRectMake(_selectedImgView.x + _selectedImgView.width + TCRealValue(12), TCRealValue(20), TCRealValue(20), TCRealValue(20)) AndFontSize:TCRealValue(20) AndTitle:@"￥" AndTextColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1]];
    [view addSubview:rmbStamp];
    
    priceLab = [TCComponent createLabelWithFrame:CGRectMake(rmbStamp.x + rmbStamp.width, rmbStamp.y, self.width - rmbStamp.x - rmbStamp.width, rmbStamp.height) AndFontSize:TCRealValue(20) AndTitle:@"" AndTextColor:rmbStamp.textColor];
    [view addSubview:priceLab];
    
    inventoryLab = [TCComponent createLabelWithFrame:CGRectMake(rmbStamp.x, rmbStamp.y + rmbStamp.height + TCRealValue(12), self.width - rmbStamp.x, TCRealValue(12)) AndFontSize:TCRealValue(12) AndTitle:@"(剩余:(null)件)" AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    [self correctInventoryLabelValue];
    [view addSubview:inventoryLab];
    
    UILabel *selectStamp = [TCComponent createLabelWithFrame:CGRectMake(rmbStamp.x, inventoryLab.y + inventoryLab.height + TCRealValue(13), TCRealValue(50), TCRealValue(14)) AndFontSize:TCRealValue(14) AndTitle:@"已选择" AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
    [view addSubview:selectStamp];
    
    [self createSelectedStandardWithOrigin:CGPointMake(selectStamp.x + selectStamp.width + TCRealValue(8), selectStamp.y - TCRealValue(1)) AndView:view];
    
    
    UIButton *closeBtn = [self createColseBtnWithFrame:CGRectMake(self.width - TCRealValue(20) - TCRealValue(22.5), TCRealValue(15), TCRealValue(22.5), TCRealValue(22.5))];
    [closeBtn addTarget:target action:closeAction forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    
    
    return view;
}




- (void)setSalePriceAndInventoryWithSalePrice:(float)salePrice AndInventory:(NSInteger)inventory AndImgUrlStr:(NSString *)urlStr{
    priceLab.text = [NSString stringWithFormat:@"%@", @([NSString stringWithFormat:@"%f", salePrice].floatValue)];
    inventoryLab.text = [NSString stringWithFormat:@"(剩余:%ld件)", (long)inventory];
    urlStr = [NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, urlStr];
    NSURL *imgUrl = [NSURL URLWithString:urlStr];
    [_selectedImgView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"home_image_place"]];
    
}

- (void)setSelectedPrimaryStandardWithText:(NSString *)text {
    _selectedPrimaryLab.text = text;
    [_selectedPrimaryLab sizeToFit];
    _selectedSecondLab.x = _selectedPrimaryLab.x + _selectedPrimaryLab.width + TCRealValue(9);
}

- (void)setSelectedSeconedStandardWithText:(NSString *)text {
    _selectedSecondLab.text = text;
    _selectedSecondLab.x = _selectedPrimaryLab.x + _selectedPrimaryLab.width + TCRealValue(9);
    [_selectedSecondLab sizeToFit];
}

- (void)setStandardSelectViewWithStandard:(TCGoodStandards *)standard AndPrimaryAction:(SEL)primaryAction AndSeconedAction:(SEL)seconedAction AndTarget:(id)target {
    if (standard.descriptions != NULL) {
        UIView *primaryView = [self createGoodStyleSelectViewWithFrame:CGRectMake(0, 0, self.width, TCRealValue(96)) AndStandard:standard AndStyleAction:primaryAction AndTarget:target];
        if (standard.descriptions[@"secondary"] != NULL) {
            UIView *seconedView = [self createGoodSizeSelectViewWithFrame:CGRectMake(0, primaryView.y + primaryView.height, self.width, TCRealValue(96)) AndStandard:standard AndAction:seconedAction AndTarget:target];
            [standardSelectView addSubview:seconedView];
        }
        [standardSelectView addSubview:primaryView];
    } else {
        computeView.y = TCRealValue(118);
    }


}


- (void)setPrimaryViewWithStandard:(TCGoodStandards *)standard AndTitle:(NSString *)title {
    for (int i = 0; i < goodStyleButtonView.subviews.count; i++) {
        if ([goodStyleButtonView.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *button = goodStyleButtonView.subviews[i];
            NSString *key = [NSString stringWithFormat:@"%@^%@", button.titleLabel.text, title];
            button.tag = i;
            if ([button.titleLabel.text isEqualToString:_selectedPrimaryLab.text]) {
                [button setTitleColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1] forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1] forState:UIControlStateNormal];
            }
            if (standard.goodsIndexes[key] == NULL) {
                [button setTitleColor:[UIColor colorWithRed:195/225.0 green:195/225.0 blue:195/225.0 alpha:1] forState:UIControlStateNormal];
                button.tag = -1;
            }
        }
    }
}


- (void)setSeconedViewWithStandard:(TCGoodStandards *)standard AndTitle:(NSString *)title {
    for (int i = 0; i < goodSizeButtonView.subviews.count; i++) {
        if ([goodSizeButtonView.subviews[i] isKindOfClass:[UIButton class]]) {
            UIButton *button = goodSizeButtonView.subviews[i];
            NSString *key = [NSString stringWithFormat:@"%@^%@", title, button.titleLabel.text];
            button.tag = i;
            if ([button.titleLabel.text isEqualToString:_selectedSecondLab.text]) {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1] forState:UIControlStateNormal];
            }
            if (standard.goodsIndexes[key] == NULL) {
                [button setTitleColor:[UIColor colorWithRed:195/225.0 green:195/225.0 blue:195/225.0 alpha:1] forState:UIControlStateNormal];
                button.tag = -1;
            }
        }
    }
}

- (UIView *)createBlankViewWithFrame:(CGRect)frame {
    UIView *blankView = [[UIView alloc] initWithFrame:frame];
    UITapGestureRecognizer *hideSelectRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchHideSelect:)];
    [blankView addGestureRecognizer:hideSelectRecognizer];
    
    return blankView;
}

- (void)touchHideSelect:(UITapGestureRecognizer *)tag {
    [self endSelectStandard];
}

- (void)endSelectStandard {
    [standardView setY:self.height];
    self.hidden = YES;

}


- (void)startSelectStandard {
    self.hidden = NO;
    [UIView animateWithDuration:0.15 animations:^{
        [standardView setY:standardViewPointY];
    } completion:nil];
}


- (void)touchColseBtn {
    self.hidden = YES;
}


- (UIView *)createBottomViewWithFrame:(CGRect)frame AndTarget:(id)target AndAddCartAction:(SEL)cartAction AndBuyAction:(SEL)buyAction{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIButton *shopcarBtn = [TCComponent createButtonWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) AndTitle:@"加入购物车" AndFontSize:TCRealValue(17)];
    [shopcarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shopcarBtn.backgroundColor = [UIColor colorWithRed:112/255.0 green:206/255.0 blue:213/255.0 alpha:1];
    [shopcarBtn addTarget:target action:cartAction forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shopcarBtn];
    
    
    return view;
}


- (void)correctInventoryLabelValue {
    if ([inventoryLab.text isEqualToString:@"(剩余:(null)件)"]) {
        inventoryLab.text = @"(剩余:0件)";
    }
}



- (void)createSelectedStandardWithOrigin:(CGPoint)point AndView:(UIView *)view {

    _selectedPrimaryLab = [TCComponent createLabelWithText:@"" AndFontSize:TCRealValue(14) AndTextColor:priceLab.textColor];
    [_selectedPrimaryLab setOrigin:point];
    [view addSubview:_selectedPrimaryLab];
    
    _selectedSecondLab = [TCComponent createLabelWithText:@"" AndFontSize:TCRealValue(14) AndTextColor:_selectedPrimaryLab.textColor];
    [_selectedSecondLab setOrigin:CGPointMake(_selectedPrimaryLab.x + _selectedPrimaryLab.width + TCRealValue(9), _selectedPrimaryLab.y)];
    [view addSubview:_selectedSecondLab];
    
}


- (UIButton *)createColseBtnWithFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setImage:[UIImage imageNamed:@"good_close"] forState:UIControlStateNormal];
    return button;
}

- (UIView *)createGoodStyleSelectViewWithFrame:(CGRect)frame AndStandard:(TCGoodStandards *)goodStandard AndStyleAction:(SEL)action AndTarget:(id)target{
    NSDictionary *infoDic = goodStandard.descriptions[@"primary"];
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), 0, frame.size.width - TCRealValue(40), TCRealValue(0.5))];
    [view addSubview:lineView];
    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(TCRealValue(20), TCRealValue(20), frame.size.width - TCRealValue(40), TCRealValue(14)) AndFontSize:TCRealValue(14) AndTitle:infoDic[@"label"] AndTextColor:[UIColor blackColor]];
    titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:TCRealValue(14)];
    [view addSubview:titleLab];
    
    goodStyleButtonView =[self createGoodStyleButtonViewWithFrame:CGRectMake(titleLab.x, titleLab.y + titleLab.height + TCRealValue(20), titleLab.width, TCRealValue(22.5)) AndStandard:goodStandard AndAction:(SEL)action AndTarget:target];

    [view addSubview:goodStyleButtonView];

    [view setHeight:goodStyleButtonView.height + TCRealValue(52) + TCRealValue(25)];

    return view;
}

- (UIView *)createGoodSizeSelectViewWithFrame:(CGRect)frame AndStandard:(TCGoodStandards *)goodStandard AndAction:(SEL)action AndTarget:(id)target{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *infoDic = goodStandard.descriptions[@"secondary"];
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), 0, frame.size.width - TCRealValue(40), TCRealValue(0.5))];
    [view addSubview:lineView];
    NSString *labelStr;
    if (![infoDic isEqual:[NSNull null]]) {
        labelStr = infoDic[@"label"];
    } else {
        labelStr = @"";
    }
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(TCRealValue(20), TCRealValue(20), frame.size.width - TCRealValue(40), TCRealValue(14)) AndFontSize:TCRealValue(14) AndTitle:labelStr AndTextColor:[UIColor blackColor]];
    titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:TCRealValue(14)];
    [view addSubview:titleLab];
    
    goodSizeButtonView = [self createGoodSizeButtonViewWithFrame:CGRectMake(titleLab.x, titleLab.y + titleLab.height + TCRealValue(20), titleLab.width, TCRealValue(30)) AndStandard:goodStandard AndTarget:target AndAction:action];
    
    [view addSubview:goodSizeButtonView];
    
    [view setHeight:goodSizeButtonView.height + TCRealValue(52) + TCRealValue(25)];
    

    
    return view;
}

- (UIView *)createGoodStyleButtonViewWithFrame:(CGRect)frame AndStandard:(TCGoodStandards *)standard AndAction:(SEL)action AndTarget:(id)target{
    UIView *buttonView = [[UIView alloc] initWithFrame:frame];
    
    NSArray *infoArr = standard.descriptions[@"primary"][@"types"];
    int width = 0;
    int height = 0;
    for (int i = 0; i < infoArr.count; i++) {
        UIButton *button = [self createGoodStyleButtonWithOrigin:CGPointMake(width, height) AndText:infoArr[i]];
        if (width + button.width > self.width - TCRealValue(40)) {
            width = 0;
            height += TCRealValue(22.5 + 13);
            [buttonView setHeight:height + TCRealValue(22.5)];
        }
        [button setOrigin:CGPointMake(width, height)];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        width += button.width + TCRealValue(13);
        [buttonView addSubview:button];
        [self initEmptyButtonWithStandard:standard AndButton:button AndPrimary:infoArr[i] AndSecond:_selectedSecondLab.text];
        
        if ([_selectedPrimaryLab.text isEqualToString:infoArr[i]]) {
            [self setSelectedButton:button];
        }
        
        
    }
    
    return buttonView;

}

- (void)initEmptyButtonWithStandard:(TCGoodStandards *)goodStandard AndButton:(UIButton *)btn AndPrimary:(NSString *)primary AndSecond:(NSString *)second{
    if (![_selectedSecondLab.text isEqualToString:@""] || ![_selectedPrimaryLab.text isEqualToString:@""]) {
        NSString *key = [NSString stringWithFormat:@"%@^%@", primary, second];
        if (goodStandard.goodsIndexes[key] == NULL) {
                [btn setTitleColor:[UIColor colorWithRed:195/255.0 green:195/255.0 blue:195/255.0 alpha:1] forState:UIControlStateNormal];
        }
    }
}

- (UILabel *)getInventoryLab {
    return inventoryLab;
}

- (void)setSelectedButton:(UIButton *)button {
    [button setTitleColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1]  forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1].CGColor;
}


- (UIView *)createGoodSizeButtonViewWithFrame:(CGRect)frame AndStandard:(TCGoodStandards *)standard AndTarget:(id)target AndAction:(SEL)action{
    UIView *buttonView = [[UIView alloc] initWithFrame:frame];
    NSArray *infoArr;
    if (![standard.descriptions[@"secondary"] isEqual:[NSNull null]]) {
        infoArr = standard.descriptions[@"secondary"][@"types"];
    } else {
        infoArr = @[];
    }
    
    int width = 0;
    int height = 0;
    for (int i = 0; i < infoArr.count; i++) {
        UIButton *button = [self createGoodSizeButtonWithOrigin:CGPointMake(width, height) AndTitle:infoArr[i]];
        if (width + button.width > self.width - TCRealValue(40)) {
            width = 0;
            height += TCRealValue(30 + 13);
            [buttonView setHeight:height + TCRealValue(30)];
        }
        [button setOrigin:CGPointMake(width, height)];
        [buttonView addSubview:button];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        width += button.width + TCRealValue(11);
        [self initEmptyButtonWithStandard:standard AndButton:button AndPrimary:_selectedPrimaryLab.text AndSecond:infoArr[i]];
        if ([_selectedSecondLab.text isEqualToString:infoArr[i]]) {
            button.backgroundColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    return buttonView;
}


- (UIView *)createNumberSelectViewWithFrame:(CGRect)frame AndAddAction:(SEL)addAction AndSubAction:(SEL)subAction AndTarget:(id)target{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(TCRealValue(20), TCRealValue(29), TCRealValue(50), TCRealValue(14))];
    numberLab.text = @"数量";
    [view addSubview:numberLab];

    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(TCRealValue(20), 0, frame.size.width - TCRealValue(40), TCRealValue(0.5))];
    [view addSubview:lineView];
    
    UIButton *addBtn = [self createComputeBtnWithFrame:CGRectMake(frame.size.width - TCRealValue(20) - TCRealValue(38), TCRealValue(20), TCRealValue(38), TCRealValue(35)) AndText:@"+"];
    [addBtn addTarget:target action:addAction forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    
    _numberLab = [self createBuyNumberLabelWithText:@"1"];
    [view addSubview:_numberLab];
    
    subBtn = [self createComputeBtnWithFrame:CGRectMake(_numberLab.x - TCRealValue(38), addBtn.y, TCRealValue(38), TCRealValue(35)) AndText:@"-"];
    [subBtn addTarget:target action:subAction forControlEvents:UIControlEventTouchDown];
    [view addSubview:subBtn];
    
    return view;
}

- (UILabel *)createBuyNumberLabelWithText:(NSString *)text {
    UILabel *label = [TCComponent createLabelWithText:text AndFontSize:TCRealValue(16) AndTextColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFrame:CGRectMake(self.width - TCRealValue(20) - TCRealValue(38) - TCRealValue(58), TCRealValue(20), TCRealValue(58), TCRealValue(35))];
    
    return label;
}

- (UIButton *)createComputeBtnWithFrame:(CGRect)frame AndText:(NSString *)text {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [button setTitleColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1] forState:UIControlStateNormal];
    button.layer.cornerRadius = TCRealValue(3);
    button.titleLabel.font = [UIFont systemFontOfSize:TCRealValue(16)];
    [button setTitle:text forState:UIControlStateNormal];
    return button;
}



- (UIButton *)createGoodStyleButtonWithOrigin:(CGPoint)point AndText:(NSString *)text {
    UIButton *button = [self createGoodSelectButtonWithFrame:CGRectMake(point.x, point.y, 0, 0) AndText:text];
    button.layer.cornerRadius = TCRealValue(5);
    button.titleLabel.font = [UIFont systemFontOfSize:TCRealValue(12)];
    [button sizeToFit];
    [button setWidth:button.width + TCRealValue(20)];
    
    return button;
}

- (UIButton *)createGoodSizeButtonWithOrigin:(CGPoint)origin AndTitle:(NSString *)title{
    UIButton *button = [self createGoodSelectButtonWithFrame:CGRectMake(origin.x, origin.y, 0, 0) AndText:title];
    button.layer.cornerRadius = TCRealValue(13);
    button.titleLabel.font = [UIFont systemFontOfSize:TCRealValue(12)];
    [button sizeToFit];
    button.layer.borderWidth = 0;
    button.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    [button setTitleColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1] forState:UIControlStateNormal];
    [button setWidth:button.width + TCRealValue(20)];
    
    return button;
}

- (UIButton *)createGoodSelectButtonWithFrame:(CGRect)frame AndText:(NSString *)text{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:text forState:UIControlStateNormal];
    button.layer.borderWidth = TCRealValue(1);
    button.layer.borderColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1].CGColor;
    [button setTitleColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1] forState:UIControlStateNormal];

    return button;
}



- (UIImageView *)createSelectGoodImgViewWithFrame:(CGRect)frame{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.layer.cornerRadius = TCRealValue(5);
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = TCRealValue(1.5);
    imageView.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1].CGColor;
    imageView.backgroundColor = [UIColor whiteColor];
//    
//    NSURL *imgUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", TCCLIENT_RESOURCES_BASE_URL, urlStr]];
//    [imageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"home_image_place"]];
    
    return imageView;
}



@end
