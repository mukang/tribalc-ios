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
}

- (instancetype)initWithData:(NSDictionary *)data AndTarget:(id)target AndStyleAction:(SEL)styleAction AndSizeAction:(SEL)sizeAction{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        
        standardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        
        UIView *titleView = [self createTitleViewWithSize:CGSizeMake(self.width, 118) AndInfo:data];
        titleView.origin = CGPointMake(0, 0);
        [standardView addSubview:titleView];
        
        UIView *styleView = [self createStyleViewWithFrame:CGRectMake(titleView.x, titleView.y + titleView.height, self.width, 96) AndInfo:data[@"style"] AndAction:styleAction AndTarget:target];
        [standardView addSubview:styleView];
        
        UIView *sizeView = [self createSizeViewWithFrame:CGRectMake(styleView.x, styleView.y + styleView.height, self.width, 96) AndInfo:data[@"size"] AndAction:sizeAction AndTarget:target];
        [standardView addSubview:sizeView];
    
        UIView *computeView = [self createNumberViewWithFrame:CGRectMake(0, sizeView.y + sizeView.height, self.width, 89)];
        [standardView addSubview:computeView];
//        
//        [computeView setY:self.height - computeView.height];
//        [sizeView setY:computeView.y - sizeView.height];
//        [styleView setY:sizeView.y - styleView.height];
//        [titleView setY:styleView.y - titleView.height];
        
        UIView *bottomView = [self createBottomViewWithFrame:CGRectMake(0, computeView.y + computeView.height, self.width, 49)];
        [standardView addSubview:bottomView];
        
        [standardView setY:self.height - bottomView.height - bottomView.y];
        [standardView setHeight:bottomView.height + bottomView.x];
        [self addSubview:standardView];
    }
    
    return self;
}

- (UIView *)createBottomViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIButton *shopcarBtn = [TCComponent createButtonWithFrame:CGRectMake(0, 0, frame.size.width / 2, frame.size.height) AndTitle:@"加入购物车" AndFontSize:17];
    [shopcarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shopcarBtn.backgroundColor = [UIColor colorWithRed:112/255.0 green:206/255.0 blue:213/255.0 alpha:1];
    [view addSubview:shopcarBtn];
    
    UIButton *buyBtn = [TCComponent createButtonWithFrame:CGRectMake(frame.size.width / 2, 0, frame.size.width / 2, frame.size.height) AndTitle:@"立即购买" AndFontSize:17];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.backgroundColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1];
    [view addSubview:buyBtn];

    
    return view;
}

- (UIView *)createTitleViewWithSize:(CGSize)size AndInfo:(NSDictionary *)info {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    view.size = size;
    
    _titleImageView = [self createImgViewWithFrame:CGRectMake(20, -9, 115, 115)];
    _titleImageView.image = [UIImage imageNamed:info[@"style"][0][@"img"]];
    [view addSubview:_titleImageView];
    
    UILabel *moneyMarkLab = [TCComponent createLabelWithFrame:CGRectMake(_titleImageView.x + _titleImageView.width + 12, 20, 20, 20) AndFontSize:20 AndTitle:@"￥" AndTextColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1]];
    [view addSubview:moneyMarkLab];
    
    _priceLab = [TCComponent createLabelWithFrame:CGRectMake(moneyMarkLab.x + moneyMarkLab.width, moneyMarkLab.y, self.width - moneyMarkLab.x - moneyMarkLab.width, moneyMarkLab.height) AndFontSize:20 AndTitle:info[@"style"][0][@"price"] AndTextColor:moneyMarkLab.textColor];
    [view addSubview:_priceLab];
    
    NSString *inventoryStr = [NSString stringWithFormat:@"(剩余:%@件)", @"32"];
    _inventoryLab = [TCComponent createLabelWithFrame:CGRectMake(moneyMarkLab.x, moneyMarkLab.y + moneyMarkLab.height + 12, self.width - moneyMarkLab.x, 12) AndFontSize:12 AndTitle:inventoryStr AndTextColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1]];
    [view addSubview:_inventoryLab];
    
    UILabel *selectMarkLab = [TCComponent createLabelWithFrame:CGRectMake(moneyMarkLab.x, _inventoryLab.y + _inventoryLab.height + 13, _inventoryLab.width, 14) AndFontSize:14 AndTitle:@"已选择" AndTextColor:[UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1]];
    [view addSubview:selectMarkLab];
    
    _selectStyleLab = [TCComponent createLabelWithText:info[@"style"][0][@"title"] AndFontSize:14 AndTextColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1]];
    _selectStyleLab.backgroundColor = [UIColor blackColor];
    [_selectStyleLab setOrigin:CGPointMake(selectMarkLab.x + selectMarkLab.width + 9, selectMarkLab.y)];
    NSLog(@"%f", _selectStyleLab.frame.origin.x);
    [view addSubview:_selectStyleLab];
    
    _selectSizeLab = [TCComponent createLabelWithText:info[@"size"][0] AndFontSize:14 AndTextColor:_selectSizeLab.textColor];
    [_selectSizeLab setOrigin:CGPointMake(_selectStyleLab.x + _selectStyleLab.width + 9, _selectStyleLab.y)];
    [view addSubview:_selectSizeLab];
    
    
    
    return view;
}

- (UIView *)createStyleViewWithFrame:(CGRect)frame AndInfo:(NSArray *)infoArr AndAction:(SEL)Action AndTarget:(id)target{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, frame.size.width - 40, 0.5)];
    [view addSubview:lineView];
    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(20, 20, frame.size.width - 40, 14) AndFontSize:14 AndTitle:@"款式" AndTextColor:[UIColor blackColor]];
    titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [view addSubview:titleLab];
    
    UIView *styleButtonView =[self getStyleButtonViewWithFrame:CGRectMake(titleLab.x, titleLab.y + titleLab.height + 20, titleLab.width, 22.5) AndData:infoArr];

    [view addSubview:styleButtonView];

    [view setHeight:styleButtonView.height + 52 + 25];
    
    return view;
}

- (UIView *)createSizeViewWithFrame:(CGRect)frame AndInfo:(NSArray *)infoArr AndAction:(SEL)Action AndTarget:(id)target{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, frame.size.width - 40, 0.5)];
    [view addSubview:lineView];
    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(20, 20, frame.size.width - 40, 14) AndFontSize:14 AndTitle:@"款式" AndTextColor:[UIColor blackColor]];
    titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [view addSubview:titleLab];
    
    UIView *sizeButtonView = [self getSizeButtonViewWithFrame:CGRectMake(titleLab.x, titleLab.y + titleLab.height + 20, titleLab.width, 30) AndData:infoArr];
    
    [view addSubview:sizeButtonView];
    
    [view setHeight:sizeButtonView.height + 52 + 25];
    

    
    return view;
}

- (UIView *)getStyleButtonViewWithFrame:(CGRect)frame AndData:(NSArray *)infoArr{
    UIView *buttonView = [[UIView alloc] initWithFrame:frame];
    NSMutableArray *buttonArr = [[NSMutableArray alloc] init];
    int width = 0;
    int height = 0;
    for (int i = 0; i < infoArr.count; i++) {
        UIButton *widthBtn = [self getStyleButtonWithOrigin:CGPointMake(width, height) AndText:infoArr[i][@"title"]];
        if (width + widthBtn.width > self.width - 40) {
            width = 0;
            height += 22.5 + 13;
            [buttonView setHeight:height + 22.5];
        }
        buttonArr[i] = [self getStyleButtonWithOrigin:CGPointMake(width, height) AndText:infoArr[i][@"title"]];
        UIButton *btn = buttonArr[i];
        width += btn.width + 13;
        [buttonView addSubview:buttonArr[i]];
        if (i == 0) {
            [btn setTitleColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1]  forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1].CGColor;
        }
        
    }

    
    return buttonView;

}

- (UIView *)getSizeButtonViewWithFrame:(CGRect)frame AndData:(NSArray *)infoArr {
    UIView *buttonView = [[UIView alloc] initWithFrame:frame];
    NSMutableArray *buttonArr = [[NSMutableArray alloc] init];
    int width = 0;
    int height = 0;
    for (int i = 0; i < infoArr.count; i++) {
        UIButton *widthBtn = [self getSizeButtonWithOrigin:CGPointMake(0, 0) AndTitle:infoArr[i]];
        if (width + widthBtn.width > self.width - 40) {
            width = 0;
            height += 30 + 13;
            [buttonView setHeight:height + 30];
        }
        buttonArr[i] = [self getSizeButtonWithOrigin:CGPointMake(width, height) AndTitle:infoArr[i]];
        UIButton *btn = buttonArr[i];
        [buttonView addSubview:buttonArr[i]];
        width += btn.width + 13;
        if (i == 0) {
            [btn setTitleColor:[UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1]  forState:UIControlStateNormal];
            btn.layer.borderColor = [UIColor colorWithRed:81/255.0 green:199/255.0 blue:209/255.0 alpha:1].CGColor;
        }
    }
    
    return buttonView;
}

- (UIView *)createNumberViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *numberLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 29, 50, 14)];
    numberLab.text = @"数量";
    [view addSubview:numberLab];

    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, frame.size.width - 40, 0.5)];
    [view addSubview:lineView];
    
    UIButton *addBtn = [self getComputeBtnWithFrame:CGRectMake(frame.size.width - 20 - 38, 20, 38, 35) AndText:@"+"];
    [view addSubview:addBtn];
    
    _numberLab = [TCComponent createLabelWithText:@"132321321321" AndFontSize:16 AndTextColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1]];
    _numberLab.textAlignment = NSTextAlignmentCenter;
    [_numberLab setOrigin:CGPointMake(addBtn.x - _numberLab.width - 23, addBtn.y)];
    [_numberLab setHeight:addBtn.height];
    [view addSubview:_numberLab];
    
    subBtn = [self getComputeBtnWithFrame:CGRectMake(_numberLab.x - 38 - 23, addBtn.y, 38, 35) AndText:@"-"];
    [view addSubview:subBtn];
    
    return view;
}

- (UIButton *)getComputeBtnWithFrame:(CGRect)frame AndText:(NSString *)text {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [button setTitleColor:[UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:text forState:UIControlStateNormal];
    return button;
}


- (UIButton *)getStyleButtonWithOrigin:(CGPoint)point AndText:(NSString *)text {
    UIButton *button = [[UIButton alloc] init];
    [button setOrigin:point];
    [button setTitle:text forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1].CGColor;
    [button setTitleColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button sizeToFit];
    [button setWidth:button.width + 20];
    
    return button;
}

- (UIButton *)getSizeButtonWithOrigin:(CGPoint)origin AndTitle:(NSString *)title{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(origin.x, origin.y, 30, 30)];
    [button setOrigin:origin];
    [button setTitle:title forState:UIControlStateNormal];
    button.layer.borderWidth = 1;
    button.layer.borderColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1].CGColor;
    button.layer.cornerRadius = button.height / 2;
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitleColor:[UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1] forState:UIControlStateNormal];
    
    return button;
}

- (UIImageView *)createImgViewWithFrame:(CGRect)frame {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.layer.cornerRadius = 3;
    imageView.clipsToBounds = YES;
    imageView.layer.borderWidth = 1.5;
    imageView.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1].CGColor;
    
    return imageView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
