//
//  TCGoodsToolsBar.m
//  individual
//
//  Created by 穆康 on 2017/9/4.
//  Copyright © 2017年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCGoodsToolsBar.h"

#import <TCCommonLibs/UIImage+Category.h>

@interface TCGoodsToolsBar ()

@property (weak, nonatomic) UIView *lineView;

@end

@implementation TCGoodsToolsBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TCSeparatorLineColor;
    [self addSubview:lineView];
    
    UIButton *shoppingCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shoppingCartButton setImage:[UIImage imageNamed:@"goods_shoppin_cart"] forState:UIControlStateNormal];
    [shoppingCartButton setTitle:@"购物车" forState:UIControlStateNormal];
    [shoppingCartButton setTitleColor:TCGrayColor forState:UIControlStateNormal];
    shoppingCartButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:shoppingCartButton];
    
    UIButton *addShoppingCartButton = [self creatButtonWithTitle:@"加入购物车"
                                                     normalImage:[UIImage imageWithColor:TCRGBColor(151, 171, 234)]
                                                highlightedImage:[UIImage imageWithColor:TCRGBColor(125, 151, 234)]];
    [self addSubview:addShoppingCartButton];
    
    UIButton *buyButton = [self creatButtonWithTitle:@"立即购买"
                                         normalImage:[UIImage imageWithColor:TCRGBColor(113, 130, 220)]
                                    highlightedImage:[UIImage imageWithColor:TCRGBColor(90, 111, 220)]];
    [self addSubview:buyButton];
    
    self.lineView = lineView;
    self.shoppingCartButton = shoppingCartButton;
    self.addShoppingCartButton = addShoppingCartButton;
    self.buyButton = buyButton;
}

- (void)setupConstraints {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    [self.shoppingCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.bottom.equalTo(self);
    }];
    [self.addShoppingCartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.equalTo(self.shoppingCartButton.mas_right);
        make.bottom.equalTo(self);
        make.width.equalTo(self.shoppingCartButton);
    }];
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom);
        make.left.equalTo(self.addShoppingCartButton.mas_right);
        make.right.bottom.equalTo(self);
        make.width.equalTo(self.shoppingCartButton);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat space = 2;
    CGSize imageViewSize = self.shoppingCartButton.imageView.size;
    CGSize labelSize = self.shoppingCartButton.titleLabel.size;
    
    self.shoppingCartButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, labelSize.height + space, -labelSize.width);
    self.shoppingCartButton.titleEdgeInsets = UIEdgeInsetsMake(imageViewSize.height + space, -imageViewSize.width, 0, 0);
    
}

- (UIButton *)creatButtonWithTitle:(NSString *)title normalImage:(UIImage *)normalImage highlightedImage:(UIImage *)highlightedImage {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    return button;
}

@end
