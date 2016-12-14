//
//  TCShoppingCartTableViewCell.m
//  individual
//
//  Created by WYH on 16/11/5.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCShoppingCartTableViewCell.h"
#import "TCGoodDetail.h"
#import "TCImageURLSynthesizer.h"

@implementation TCShoppingCartTableViewCell {
    UILabel *countLab;
    UILabel *priceLab;
    UILabel *primaryLab;
    UIButton *secondaryStandardBtn;
    
    TCComputeView *computeView;
}

- (instancetype)initEditCellStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndSelectTag:(NSString *)tag AndGoodsId:(NSString *)goodsId{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selectTag = tag;
        
        self.backgroundColor = [UIColor whiteColor];
        float height = 139;
        float width = [UIScreen mainScreen].bounds.size.width;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _selectedBtn = [TCComponent createImageBtnWithFrame:CGRectMake(TCRealValue(20), height / 2 - 8, 16, 16) AndImageName:@"car_unselected"];
        [self.contentView addSubview:_selectedBtn];
        
        _leftImgView = [self getLeftImageViewWithFrame:CGRectMake(_selectedBtn.x + _selectedBtn.width + TCRealValue(20), height / 2 - TCRealValue(94) / 2, TCRealValue(94), TCRealValue(94))];
        [self.contentView addSubview:_leftImgView];

        _baseInfoView = [[TCShoppingCartBaseInfoView alloc] initEditViewWithFrame:CGRectMake(_leftImgView.x + _leftImgView.width, 0, width - _leftImgView.x - _leftImgView.width, height) AndSelectTag:tag AndGoodsId:goodsId];
        [self.contentView addSubview:_baseInfoView];
        
        
        UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, width - 40, 0.5)];
        [self.contentView addSubview:topLineView];


    }
    
    return self;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier AndSelectTag:(NSString *)tag AndGoodsId:(NSString *)goodsId {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _selectTag = tag;
        
        self.backgroundColor = [UIColor whiteColor];
        float height = 139;
        float width = [UIScreen mainScreen].bounds.size.width;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _selectedBtn = [TCComponent createImageBtnWithFrame:CGRectMake(20, height / 2 - 8, 16, 16) AndImageName:@"car_unselected"];
        [self.contentView addSubview:_selectedBtn];
        
        _leftImgView = [self getLeftImageViewWithFrame:CGRectMake(_selectedBtn.x + _selectedBtn.width + TCRealValue(20), height / 2 - TCRealValue(94) / 2, TCRealValue(94), TCRealValue(94))];
        [self.contentView addSubview:_leftImgView];
        
        _baseInfoView = [[TCShoppingCartBaseInfoView alloc] initNormalViewWithFrame:CGRectMake(_leftImgView.x + _leftImgView.width, 0, width - _leftImgView.x - _leftImgView.width, height) AndSelectTag:_selectTag AndGoodsId:goodsId];
        [self.contentView addSubview:_baseInfoView];
        
        UIView *topLineView = [TCComponent createGrayLineWithFrame:CGRectMake(20, 0, width - 40, 0.5)];
        [self.contentView addSubview:topLineView];
    }
    
    return self;
}

- (UIView *)getSlideButtonViewWithFrame:(CGRect)frame {
    UIView *slideView = [[UIView alloc] initWithFrame:frame];
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height / 2)];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [slideView addSubview:editBtn];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, editBtn.y + editBtn.height, frame.size.width, frame.size.height / 2)];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [slideView addSubview:deleteBtn];
    
    return slideView;
}

- (void)setCount:(NSInteger)count {
    NSString *countStr = [NSString stringWithFormat:@"X %li", (long)count];
    countLab.text = countStr;
    [countLab sizeToFit];
}



- (void)setPrice:(CGFloat)price {
    NSString *priceStr = [NSString stringWithFormat:@"%f", price];
    priceStr = [NSString stringWithFormat:@"￥%@", @(priceStr.floatValue)];
    priceLab.text = priceStr;
    [priceLab sizeToFit];
    priceLab.x = [UIScreen mainScreen].bounds.size.width - 20 - priceLab.width;
    
}

- (UIImageView *)getLeftImageViewWithFrame:(CGRect)frame {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.layer.borderWidth = 1;
    imgView.layer.borderColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1].CGColor;
    
    return imgView;
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
