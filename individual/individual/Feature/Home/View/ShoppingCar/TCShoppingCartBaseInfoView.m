//
//  TCShoppingCartBaseInfoView.m
//  individual
//
//  Created by WYH on 16/12/8.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCShoppingCartBaseInfoView.h"
#import "TCComponent.h"
#import "TCComputeView.h"
#import "TCSelectStandardView.h"
#import "TCBuluoApi.h"
#import "TCStandardView.h"

@implementation TCShoppingCartBaseInfoView {
    TCComputeView *computeView;
    NSString *tag;
    NSString *goodsId;
    NSInteger repertory;
}

- (instancetype)initNormalViewWithFrame:(CGRect)frame AndSelectTag:(NSString *)selectTag AndGoodsId:(NSString *)goodId{
    self = [super initWithFrame:frame];
    if (self) {
        tag = selectTag;
        goodsId = goodId;
        
        [self fetchGoodDetailWithGoodId:goodsId];
        
        _titleLab = [self getTitleLabWithFrame:CGRectMake(13, 22.5 + 9, frame.size.width - 13 - 20, 14)];
        [self addSubview:_titleLab];
        
        _primaryStandardLab = [self getPrimaryStandardLabWithFrame:CGRectMake(_titleLab.x, _titleLab.y + _titleLab.height + 9, _titleLab.width, 12)];
        [self addSubview:_primaryStandardLab];
        
        _sendondaryStandardLab = [self getSecondaryStandardLabWithFrame:CGRectMake(_titleLab.x, _primaryStandardLab.y + _primaryStandardLab.height + 15.5, 47, 27)];
        
        _amountLab = [self getAmountLabWithFrame:CGRectMake(_sendondaryStandardLab.x + _sendondaryStandardLab.width + 8, _sendondaryStandardLab.y, 0, _sendondaryStandardLab.height)];
        [self addSubview:_amountLab];
        
        _priceLab = [self getPriceLabWithFrame:CGRectMake(self.width - 20, self.height - 28 - 12, 0, 14)];
        [self addSubview:_priceLab];
        
        
    }
    
    return self;
}




- (instancetype)initEditViewWithFrame:(CGRect)frame AndSelectTag:(NSString *)selectTag AndGoodsId:(NSString *)goodId{
    goodsId = goodId;
    tag = selectTag;
    self = [super initWithFrame:frame];
    if (self) {
        [self fetchGoodDetailWithGoodId:goodsId];
        
        _titleLab = [self getTitleLabWithFrame:CGRectMake(13, 22.5 + 9, frame.size.width - 13 - 20, 14)];
        [self addSubview:_titleLab];
        
        _primaryStandardLab = [self getPrimaryStandardLabWithFrame:CGRectMake(_titleLab.x, _titleLab.y + _titleLab.height + 9, _titleLab.width, 12)];
        [self addSubview:_primaryStandardLab];
        
        
        _sendondaryStandardLab = [self getSecondaryStandardLabWithFrame:CGRectMake(_titleLab.x, _primaryStandardLab.y + _primaryStandardLab.height + 15.5, 47, 27)];
        
        UIButton *selectStandardBtn = [self getStandardSelectBtnWithFrame:CGRectMake(_sendondaryStandardLab.x + _sendondaryStandardLab.width, _sendondaryStandardLab.y, 22, _sendondaryStandardLab.height)];
        [self addSubview:selectStandardBtn];
        
        computeView = [[TCComputeView alloc] initWithFrame:CGRectMake(self.width - 20 - 78, _sendondaryStandardLab.y + (_sendondaryStandardLab.height / 2 - 10), 78, 20)];
        [self addSubview:computeView];
        
        [computeView.addBtn addTarget:self action:@selector(touchAddAmountBtn:) forControlEvents:UIControlEventTouchUpInside];
        [computeView.subBtn addTarget:self action:@selector(touchSubAmountBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _amountLab = computeView.countLab;
        
        _priceLab = [self getPriceLabWithFrame:CGRectMake(self.width - 20, self.height - 28 - 12, 0, 14)];
        [self addSubview:_priceLab];
        

    }
    
    return self;
}


- (void)fetchGoodDetailWithGoodId:(NSString *)goodId {
    [[TCBuluoApi api] fetchGoodDetail:goodsId result:^(TCGoodDetail *goodDetail, NSError *error) {
        repertory = goodDetail.repertory;
    }];
}

- (UIButton *)getStandardSelectBtnWithFrame:(CGRect)frame {
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    UIImage *image = [UIImage imageNamed:@"car_select_standard"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width / 2 - 6, frame.size.height / 2 - 3, 12, 6)];
    imageView.image = image;
    
    [button addSubview:imageView];
    
    [button addTarget:self action:@selector(touchSelectStandardBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}


- (void)setupStandard:(NSString *)standard {
    UIImageView *sencondaryImgView = [self getSecondaryStandardBackViewWithFrame:_sendondaryStandardLab.frame];

    if ([standard containsString:@":"]) {
        if ([standard containsString:@"|"]) {
            NSArray *standardArr = [standard componentsSeparatedByString:@"|"];
            NSArray *primaryArr = [standardArr[0] componentsSeparatedByString:@":"];
            NSArray *secondaryArr = [standardArr[1] componentsSeparatedByString:@":"];
            _primaryStandardLab.text = [NSString stringWithFormat:@"%@ : %@", primaryArr[0], primaryArr[1]];
            [_primaryStandardLab sizeToFit];
            _sendondaryStandardLab.text = secondaryArr[1];
            [self addSubview:sencondaryImgView];
            [self addSubview:_sendondaryStandardLab];
        } else {
            NSArray *primaryArr = [standard componentsSeparatedByString:@":"];
            _primaryStandardLab.text = [NSString stringWithFormat:@"%@ : %@", primaryArr[0], primaryArr[1]];
            [_primaryStandardLab sizeToFit];
        }
    }
}

- (void)setupAmountLab:(NSInteger)amount {
    NSString *amountStr = [NSString stringWithFormat:@"X %li", (long)amount];
    _amountLab.text = amountStr;
    [_amountLab sizeToFit];
    _amountLab.height = _sendondaryStandardLab.height;
    
}

- (void)setupEditAmount:(NSInteger)amount {
    [computeView setCount:amount];
    float height = _amountLab.height;
    [_amountLab sizeToFit];
    _amountLab.size = CGSizeMake(26, height);
}

- (void)setupNormalPriceLab:(CGFloat)price {
    NSString *priceStr = [NSString stringWithFormat:@"￥ %@", @([NSString stringWithFormat:@"%f", price].floatValue)];
    _priceLab.text = priceStr;
    [_priceLab sizeToFit];
    _priceLab.frame = CGRectMake(self.width - _priceLab.width - 20, self.height - 28 - 14, _priceLab.width, 14);
    
}

- (void)setupEditPriceLab:(CGFloat)price {
    NSString *priceStr = [NSString stringWithFormat:@"￥ %@", @([NSString stringWithFormat:@"%f", price].floatValue)];
    _priceLab.text = priceStr;
    [_priceLab sizeToFit];
    _priceLab.frame = CGRectMake(self.width - _priceLab.width - 20, _primaryStandardLab.y - 4, _priceLab.width, 14);

}

- (UILabel *)getTitleLabWithFrame:(CGRect)frame {
    UILabel *label = [TCComponent createLabelWithFrame:frame AndFontSize:14 AndTitle:@""];
    label.font = [UIFont fontWithName:BOLD_FONT size:14];
    
    return label;
}


- (UILabel *)getPrimaryStandardLabWithFrame:(CGRect)frame {
    UILabel *label = [TCComponent createLabelWithFrame:frame AndFontSize:12 AndTitle:@""];
    label.textColor = TCRGBColor(154, 154, 154);
    
    return label;
}

- (UILabel *)getSecondaryStandardLabWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UIImageView *)getSecondaryStandardBackViewWithFrame:(CGRect)frame {
    UIImageView *backView = [[UIImageView alloc] initWithFrame:frame];
    backView.image = [UIImage imageNamed:@"car_second_button"];
    
    return backView;
}


- (UILabel *)getAmountLabWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = TCRGBColor(154, 154, 154);
    label.font = [UIFont fontWithName:BOLD_FONT size:12];
    
    return label;
}

- (UILabel *)getPriceLabWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:BOLD_FONT size:14];
    label.textColor = TCRGBColor(42, 42, 42);
    
    return label;
}

- (void)touchAddAmountBtn:(UIButton *)btn {
    
    NSString *addNumber = [NSString stringWithFormat:@"%ld", _amountLab.text.integerValue + 1];
    [self changeAmountWithNumber:addNumber];
}

- (void)touchSubAmountBtn:(UIButton *)btn {
    NSInteger amount = _amountLab.text.integerValue;
    if (amount <= 1) {
        [MBProgressHUD showHUDWithMessage:@"不能再减了"];
        return ;
    }
    NSString *subNumber = [NSString stringWithFormat:@"%ld", amount - 1];
    [self changeAmountWithNumber:subNumber];

}

- (void)touchSelectStandardBtn:(UIButton *)button {
    TCSelectStandardView *selectStandardView = [[TCSelectStandardView alloc] initWithGoodsId:goodsId AndSelectTag:tag];
    [[UIApplication sharedApplication].keyWindow addSubview:selectStandardView];
}

- (void)changeAmountWithNumber:(NSString *)number {
    NSString *notifiName = [NSString stringWithFormat:@"changeStandard%@", tag];
    NSDictionary *changeDic = @{ @"goodsId":goodsId , @"number":number, @"selectTag": tag };
    [[NSNotificationCenter defaultCenter] postNotificationName:notifiName object:changeDic];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellChangeAmount:) name:[NSString stringWithFormat:@"changeGoodAmount%@", tag] object:nil];
}


- (void)cellChangeAmount:(NSNotification *)notification {
    NSInteger amount = [[notification object] integerValue];
    [computeView setCount:amount];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[NSString stringWithFormat:@"changeGoodAmount%@", tag] object:nil];
}


@end
