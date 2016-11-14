//
//  TCShoppingCartTableViewCell.m
//  individual
//
//  Created by WYH on 16/11/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCShoppingCartTableViewCell.h"

@implementation TCShoppingCartTableViewCell {
    UILabel *quantifier;
}


- (instancetype)initWithCellHeight:(float)cellHeihgt {
    self = [super init];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (cellHeihgt == 150.0) {
            [self initialCompleteView];
        } else {
            [self initialCompleteView];
            _typeAndName.origin = CGPointMake(_typeAndName.origin.x, _typeAndName.origin.y - 15);
            _shopName.origin = CGPointMake(_typeAndName.origin.x, _shopName.origin.y - 15);
            [self initialEditCount];
            quantifier.hidden = YES;
            _size.hidden = YES;
            _price.origin = CGPointMake(_price.origin.x, 210 - 50);
        }
        
        
    }
    
    return self;
}

- (void)initialCompleteView {
    float cellHeight = 150.0;
    _select = [[UIButton alloc] initWithFrame:CGRectMake(10, cellHeight / 2 - 9, 20, 20)];
    _select.layer.cornerRadius = 10;
    _select.layer.borderWidth = 1;
    _select.layer.borderColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1].CGColor;
    [_select addTarget:self action:@selector(touchSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_select];
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(_select.frame.origin.x + _select.frame.size.width + 10, 15, cellHeight - 33, cellHeight - 33)];
    [self.contentView addSubview:_imgView];
    
    [self initialTypeAndNameAndShopLabel];
    
    [self initialSizeLabel];
    
    [self initialQuantifier];
    
    _count = [self initialLabWithFrame:CGRectMake(quantifier.origin.x + quantifier.size.width + 5, _size.frame.origin.y, 60, _size.size.height)];
    _count.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_count];
    
    [self initialPriceLabel];

}

- (void)initialEditCount {
    _subBtn = [[UIButton alloc] initWithFrame:CGRectMake(_shopName.origin.x, _shopName.origin.y + _shopName.size.height + 15, 26, 18)];
    [_subBtn setTitle:@"-" forState:UIControlStateNormal];
    [_subBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _subBtn.backgroundColor = [UIColor colorWithRed:228/255.0 green:225/255.0 blue:229/255.0 alpha:1];
    [self.contentView addSubview:_subBtn];
   
    _count.frame = CGRectMake(_subBtn.origin.x + _subBtn.size.width, _subBtn.origin.y, _subBtn.size.width, _subBtn.size.height);
    _count.textAlignment = NSTextAlignmentCenter;
   
    _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(_count.origin.x + _count.size.width, _count.origin.y, _subBtn.size.width, _subBtn.size.height)];
    [_addBtn setTitle:@"+" forState:UIControlStateNormal];
    [_addBtn setTitleColor:_price.textColor forState:UIControlStateNormal];
    _addBtn.layer.borderWidth = 1;
    _addBtn.layer.borderColor = _size.backgroundColor.CGColor;
    [self.contentView addSubview:_addBtn];
}

- (void)initialEditSizeButton {
    
}


- (void)initialQuantifier {
    quantifier = [[UILabel alloc] initWithFrame:CGRectMake(_size.origin.x + _size.size.width + 8, _size.frame.origin.y, 18, _size.frame.size.height)];
    quantifier.text = @"X";
    quantifier.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:quantifier];
}

- (void)initialPriceLabel {
    _price = [self initialLabWithFrame:CGRectMake(_count.origin.x + _count.size.width, _count.origin.y + 3, [[UIScreen mainScreen] bounds].size.width - _count.frame.origin.x - _count.frame.size.width - 10, _count.frame.size.height)];
    _price.font = [UIFont systemFontOfSize:22];
    _price.textColor = [UIColor colorWithRed:63/255.0 green:171/255.0 blue:198/255.0 alpha:1];
    _price.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_price];
}

- (void)initialSizeLabel {
    _size = [self initialLabWithFrame:CGRectMake(_shopName.frame.origin.x, _shopName.frame.origin.y + _shopName.frame.size.height + 10, 36, 36)];
    _size.layer.cornerRadius = 18;
    _size.clipsToBounds = YES;
    _size.textColor = [UIColor whiteColor];
    _size.font = [UIFont systemFontOfSize:15];
    _size.textAlignment = NSTextAlignmentCenter;
    _size.backgroundColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:1];
    [self.contentView addSubview:_size];
}

- (void)initialTypeAndNameAndShopLabel {
    
    _typeAndName = [self initialLabWithFrame:CGRectMake(_imgView.frame.origin.x + _imgView.frame.size.width + 15, 24, self.frame.size.width - (_imgView.frame.origin.x + _imgView.frame.size.width + 15), 18)];
    [self.contentView addSubview:_typeAndName];
    
    _shopName = [self initialLabWithFrame:CGRectMake(_typeAndName.frame.origin.x, _typeAndName.frame.origin.y + _typeAndName.frame.size.height + 10, _typeAndName.frame.size.width, 18)];
    [self.contentView addSubview:_shopName];
    
    
}

- (UILabel *)initialLabWithFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:17];
    
    
    
    return label;
}


- (void)touchSelect:(id)sender {
    UIColor *color = _select.backgroundColor;
    if ([color isEqual:_size.backgroundColor]) {
        _select.backgroundColor = [UIColor clearColor];
    } else {
        _select.backgroundColor = _size.backgroundColor;
    }

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
