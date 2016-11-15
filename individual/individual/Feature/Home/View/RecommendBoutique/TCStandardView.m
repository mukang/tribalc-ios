//
//  TCStandardView.m
//  individual
//
//  Created by WYH on 16/11/14.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCStandardView.h"

@implementation TCStandardView

- (instancetype)initWithData:(NSDictionary *)data AndTarget:(id)target AndStyleAction:(SEL)styleAction AndSizeAction:(SEL)sizeAction{
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        UIView *titleView = [self createTitleViewWithSize:CGSizeMake(self.width, 118) AndInfo:data];
        titleView.origin = CGPointMake(0, 200);
        [self addSubview:titleView];
        
        UIView *styleView = [self createStyleViewWithFrame:CGRectMake(titleView.x, titleView.y + titleView.height, self.width, 96) AndInfo:data[@"style"] AndAction:styleAction AndTarget:target];
        [self addSubview:styleView];
        
    
    }
    
    return self;
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
    
    UIView *lineView = [TCComponent createGrayLineWithFrame:CGRectMake(0, 0, frame.size.width, 0.5)];
    [view addSubview:lineView];
    
    UILabel *titleLab = [TCComponent createLabelWithFrame:CGRectMake(20, 20, frame.size.width - 40, 14) AndFontSize:14 AndTitle:@"款式" AndTextColor:[UIColor blackColor]];
    titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    [view addSubview:titleLab];
    
    UIView *buttonView =[self getStyleButtonViewWithFrame:CGRectMake(titleLab.x, titleLab.y + titleLab.height + 20, titleLab.width, 22.5) AndData:infoArr];

    [view addSubview:buttonView];

    [view setHeight:buttonView.height + 52 + 25];
    
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
        
    }
    
    return buttonView;

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
    UIButton *button = [[UIButton alloc] init];
    [button setOrigin:origin];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    
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
