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
}

- (instancetype)initWithData:(NSDictionary *)data AndTarget:(id)target AndStyleAction:(SEL)styleAction AndSizeAction:(SEL)sizeAction AndCloseAction:(SEL)closeAction AndNumberAddAction:(SEL)addAction AndNumberSubAction:(SEL)subAction AndAddShoppingCartAction:(SEL)addCartAction AndBuyAction:(SEL)buyAction
{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        self.hidden = YES;
        
        
        standardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        
        UIView *selectedInfoView = [self createSelectedInfoViewWithFrame:CGRectMake(0, 0, self.width, 118) AndInfo:data AndCloseAction:closeAction AndTarget:target];
        [standardView addSubview:selectedInfoView];
        
        UIView *goodStyleSelectView = [self createGoodStyleSelectViewWithFrame:CGRectMake(selectedInfoView.x, selectedInfoView.y + selectedInfoView.height, self.width, 96) AndInfo:data[@"style"] AndStyleAction:styleAction AndTarget:target];
        [standardView addSubview:goodStyleSelectView];
        [standardView bringSubviewToFront:goodStyleSelectView];
        
        UIView *goodSizeSelectView = [self createGoodSizeSelectViewWithFrame:CGRectMake(goodStyleSelectView.x, goodStyleSelectView.y + goodStyleSelectView.height, self.width, 96) AndInfo:data[@"size"] AndAction:sizeAction AndTarget:target];
        [standardView addSubview:goodSizeSelectView];

        UIView *computeView = [self createNumberSelectViewWithFrame:CGRectMake(0, goodSizeSelectView.y + goodSizeSelectView.height, self.width, 89)AndAddAction:(SEL)addAction AndSubAction:(SEL)subAction AndTarget:(id)target];
        [standardView addSubview:computeView];

        
        UIView *bottomView = [self createBottomViewWithFrame:CGRectMake(0, computeView.y + computeView.height, self.width, 49) AndTarget:target AndAddCartAction:addCartAction AndBuyAction:buyAction];
        [standardView addSubview:bottomView];

        [standardView setHeight:bottomView.height + bottomView.y];
        [self addSubview:standardView];
        [standardView setY:self.height];
        standardViewPointY = self.height - bottomView.height - bottomView.y;

    }
    
    return self;
}


- (void)startSelectStandard {
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [standardView setY:standardViewPointY];
    } completion:nil];
}

- (void)endSelectStandard {
    [UIView animateWithDuration:0.3 animations:^{
        [standardView setY:self.height];
    }completion:nil];
    
    self.hidden = YES;
}


- (UIView *)createBottomViewWithFrame:(CGRect)frame AndTarget:(id)target AndAddCartAction:(SEL)cartAction AndBuyAction:(SEL)buyAction{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIButton *shopcarBtn = [TCComponent createButtonWithFrame:CGRectMake(0, 0, frame.size.width / 2, frame.size.height) AndTitle:@"加入购物车" AndFontSize:17];
    [shopcarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shopcarBtn.backgroundColor = [UIColor colorWithRed:112/255.0 green:206/255.0 blue:213/255.0 alpha:1];
    [shopcarBtn addTarget:target action:cartAction forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:shopcarBtn];
    
    UIButton *buyBtn = [TCComponent createButtonWithFrame:CGRectMake(frame.size.width / 2, 0, frame.size.width / 2, frame.size.height) AndTitle:@"立即购买" AndFontSize:17];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shopcarBtn addTarget:target action:buyAction forControlEvents:UIControlEventTouchUpInside];
    buyBtn.backgroundColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    [view addSubview:buyBtn];

    
    return view;
}

- (UIView *)createSelectedInfoViewWithFrame:(CGRect)frame AndInfo:(NSDictionary *)info AndCloseAction:(SEL)closeAction AndTarget:(id)target {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    _selectedImgView = [self createSelectGoodImgViewWithFrame:CGRectMake(20, -9, 115, 115)];
    _selectedImgView.image = [UIImage imageNamed:info[@"style"][0][@"img"]];
    [view addSubview:_selectedImgView];
    
    UILabel *rmbStamp = [TCComponent createLabelWithFrame:CGRectMake(_selectedImgView.x + _selectedImgView.width + 12, 20, 20, 20) AndFontSize:20 AndTitle:@"￥" AndTextColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1]];
    [view addSubview:rmbStamp];
    
    _priceLab = [TCComponent createLabelWithFrame:CGRectMake(rmbStamp.x + rmbStamp.width, rmbStamp.y, self.width - rmbStamp.x - rmbStamp.width, rmbStamp.height) AndFontSize:20 AndTitle:info[@"style"][0][@"price"] AndTextColor:rmbStamp.textColor];
    [view addSubview:_priceLab];
    
    NSString *inventoryStr = [NSString stringWithFormat:@"(剩余:%@件)", @"99999"];
    _inventoryLab = [TCComponent createLabelWithFrame:CGRectMake(rmbStamp.x, rmbStamp.y + rmbStamp.height + 12, self.width - rmbStamp.x, 12) AndFontSize:12 AndTitle:inventoryStr AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    [view addSubview:_inventoryLab];
    
    UILabel *selectStamp = [TCComponent createLabelWithFrame:CGRectMake(rmbStamp.x, _inventoryLab.y + _inventoryLab.height + 13, 50, 14) AndFontSize:14 AndTitle:@"已选择" AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
    [view addSubview:selectStamp];
    
    _selectedGoodStyleLab = [TCComponent createLabelWithText:info[@"style"][0][@"title"] AndFontSize:14 AndTextColor:_priceLab.textColor];
    [_selectedGoodStyleLab setOrigin:CGPointMake(selectStamp.x + selectStamp.width + 8, selectStamp.y - 1)];
    [view addSubview:_selectedGoodStyleLab];
    
    _selectedGoodSizeLab = [TCComponent createLabelWithText:info[@"size"][0] AndFontSize:14 AndTextColor:_selectedGoodStyleLab.textColor];
    [_selectedGoodSizeLab setOrigin:CGPointMake(_selectedGoodStyleLab.x + _selectedGoodStyleLab.width + 9, _selectedGoodStyleLab.y)];
    [view addSubview:_selectedGoodSizeLab];
    
    UIButton *closeBtn = [self createColseBtnWithFrame:CGRectMake(self.width - 20 - 15, 15, 15, 15)];
    [closeBtn addTarget:target action:closeAction forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    
    
    return view;
}

- (void)modifyInventoryLabel {
    NSURL *url = [NSURL URLWithString:@""];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"post";
//    _selectedGoodSizeLab.text  _selectGoodStyleLab.text
    NSDictionary *body = @{  };
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
    request.HTTPBody = bodyData;
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSString *inventoryStr = [NSString stringWithFormat:@"(剩余:%@件)", result[@""]];
            _inventoryLab.text = inventoryStr;
            
        }
    }];
    [dataTask resume];

}

- (UIButton *)createColseBtnWithFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.layer.cornerRadius = frame.size.height / 2;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1].CGColor;
    [button setTitle:@"X" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [button setTitleColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1] forState:UIControlStateNormal];
    return button;
}

- (UIView *)createGoodStyleSelectViewWithFrame:(CGRect)frame AndInfo:(NSArray *)infoArr AndStyleAction:(SEL)action AndTarget:(id)target{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, frame.size.width - 40, 0.5)];
    [view addSubview:lineView];
    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(20, 20, frame.size.width - 40, 14) AndFontSize:14 AndTitle:@"款式" AndTextColor:[UIColor blackColor]];
    titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [view addSubview:titleLab];
    
    UIView *goodStyleButtonView =[self createGoodStyleButtonViewWithFrame:CGRectMake(titleLab.x, titleLab.y + titleLab.height + 20, titleLab.width, 22.5) AndData:infoArr AndAction:(SEL)action AndTarget:target];

    [view addSubview:goodStyleButtonView];

    [view setHeight:goodStyleButtonView.height + 52 + 25];

    return view;
}

- (UIView *)createGoodSizeSelectViewWithFrame:(CGRect)frame AndInfo:(NSArray *)infoArr AndAction:(SEL)action AndTarget:(id)target{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, frame.size.width - 40, 0.5)];
    [view addSubview:lineView];
    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(20, 20, frame.size.width - 40, 14) AndFontSize:14 AndTitle:@"尺码" AndTextColor:[UIColor blackColor]];
    titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [view addSubview:titleLab];
    
    UIView *goodSizeButtonView = [self createGoodSizeButtonViewWithFrame:CGRectMake(titleLab.x, titleLab.y + titleLab.height + 20, titleLab.width, 30) AndData:infoArr AndTarget:target AndAction:action];
    
    [view addSubview:goodSizeButtonView];
    
    [view setHeight:goodSizeButtonView.height + 52 + 25];
    

    
    return view;
}

- (UIView *)createGoodStyleButtonViewWithFrame:(CGRect)frame AndData:(NSArray *)infoArr AndAction:(SEL)action AndTarget:(id)target{
    UIView *buttonView = [[UIView alloc] initWithFrame:frame];
    
    int width = 0;
    int height = 0;
    for (int i = 0; i < infoArr.count; i++) {
        UIButton *button = [self createGoodStyleButtonWithOrigin:CGPointMake(width, height) AndText:infoArr[i][@"title"]];
        if (width + button.width > self.width - 40) {
            width = 0;
            height += 22.5 + 13;
            [buttonView setHeight:height + 22.5];
        }
        [button setOrigin:CGPointMake(width, height)];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        width += button.width + 13;
        [buttonView addSubview:button];
        if (i == 0) {
            [self setSelectedButton:button];
        }
        
    }
    
    return buttonView;

}

- (void)setSelectedButton:(UIButton *)button {
    [button setTitleColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1]  forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1].CGColor;

}

- (UIView *)createGoodSizeButtonViewWithFrame:(CGRect)frame AndData:(NSArray *)infoArr AndTarget:(id)target AndAction:(SEL)action{
    UIView *buttonView = [[UIView alloc] initWithFrame:frame];
    int width = 0;
    int height = 0;
    for (int i = 0; i < infoArr.count; i++) {
        UIButton *button = [self createGoodSizeButtonWithOrigin:CGPointMake(width, height) AndTitle:infoArr[i]];
        if (width + button.width > self.width - 40) {
            width = 0;
            height += 30 + 13;
            [buttonView setHeight:height + 30];
        }
        [button setOrigin:CGPointMake(width, height)];
        [buttonView addSubview:button];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        width += button.width + 13;
        if (i == 0) {
            [self setSelectedButton:button];
        }
    }
    
    return buttonView;
}


- (UIView *)createNumberSelectViewWithFrame:(CGRect)frame AndAddAction:(SEL)addAction AndSubAction:(SEL)subAction AndTarget:(id)target{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 29, 50, 14)];
    numberLab.text = @"数量";
    [view addSubview:numberLab];

    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, frame.size.width - 40, 0.5)];
    [view addSubview:lineView];
    
    UIButton *addBtn = [self createComputeBtnWithFrame:CGRectMake(frame.size.width - 20 - 38, 20, 38, 35) AndText:@"+"];
    [addBtn addTarget:target action:addAction forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    
    _numberLab = [self createBuyNumberLabelWithText:@"1"];
    [view addSubview:_numberLab];
    
    subBtn = [self createComputeBtnWithFrame:CGRectMake(_numberLab.x - 38, addBtn.y, 38, 35) AndText:@"-"];
    [subBtn addTarget:target action:subAction forControlEvents:UIControlEventTouchDown];
    [view addSubview:subBtn];
    
    return view;
}

- (UILabel *)createBuyNumberLabelWithText:(NSString *)text {
    UILabel *label = [TCComponent createLabelWithText:text AndFontSize:16 AndTextColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFrame:CGRectMake(self.width - 20 - 38 - 58, 20, 58, 35)];
    
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



- (UIButton *)createGoodStyleButtonWithOrigin:(CGPoint)point AndText:(NSString *)text {
    UIButton *button = [self createGoodSelectButtonWithFrame:CGRectMake(point.x, point.y, 0, 0) AndText:text];
    button.layer.cornerRadius = 5;
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button sizeToFit];
    [button setWidth:button.width + 20];
    
    return button;
}

- (UIButton *)createGoodSizeButtonWithOrigin:(CGPoint)origin AndTitle:(NSString *)title{
    UIButton *button = [self createGoodSelectButtonWithFrame:CGRectMake(origin.x, origin.y, 30, 30) AndText:title];
    button.layer.cornerRadius = button.height / 2;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    
    return button;
}

- (UIButton *)createGoodSelectButtonWithFrame:(CGRect)frame AndText:(NSString *)text{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    [button setTitle:text forState:UIControlStateNormal];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1].CGColor;
    [button setTitleColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1] forState:UIControlStateNormal];

    return button;
}



- (UIImageView *)createSelectGoodImgViewWithFrame:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.layer.cornerRadius = 5;
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 1.5;
    imageView.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1].CGColor;
    
    return imageView;
}


- (void)setGoodStyle:(NSString *)style {
    _selectedGoodStyleLab.text = style;
    [_selectedGoodStyleLab sizeToFit];
    [_selectedGoodSizeLab setX:_selectedGoodStyleLab.x + _selectedGoodStyleLab.width + 9];
}

- (void)setGoodSize:(NSString *)goodSize {
    _selectedGoodSizeLab.text = goodSize;
    [_selectedGoodSizeLab sizeToFit];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
