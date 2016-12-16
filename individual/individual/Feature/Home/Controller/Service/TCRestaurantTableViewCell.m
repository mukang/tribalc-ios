//
//  TCRestaurantTableViewCell.m
//  individual
//
//  Created by WYH on 16/11/6.
//  Copyright © 2016年 杭州部落公社科技有限公司. All rights reserved.
//

#import "TCRestaurantTableViewCell.h"

@implementation TCRestaurantTableViewCell  {
    UILabel *locationLab;
    UIView *locationLineType;
    UILabel *typeLab;
    UILabel *priceLab;
    UILabel *unitLab;
    UIImageView *roomImgView;
    UIImageView *reserveImgView;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        float cellWidth = [UIScreen mainScreen].bounds.size.width;
        
        [self initialImgView];
        
        _nameLab = [self createLabWithFrame:CGRectMake(_resImgView.origin.x + _resImgView.size.width + TCRealValue(17), _resImgView.origin.y + TCRealValue(2), cellWidth - _resImgView.origin.x - _resImgView.size.width - TCRealValue(17), TCRealValue(15)) AndFontSize:TCRealValue(14)];
        _nameLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:TCRealValue(14)];
        [self.contentView addSubview:_nameLab];
        
        locationLab = [self createLabWithFrame:CGRectMake(_nameLab.origin.x + TCRealValue(2), _nameLab.y + _nameLab.height + TCRealValue(11), _nameLab.width, TCRealValue(12)) AndFontSize:TCRealValue(12)];
        [self.contentView addSubview:locationLab];
        
        typeLab = [self createLabWithFrame:locationLab.frame AndFontSize:TCRealValue(12)];
        [self.contentView addSubview:typeLab];
        
        
        locationLineType = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TCRealValue(1), TCRealValue(11))];
        locationLineType.backgroundColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
        [self.contentView addSubview:locationLineType];
        
        [self createPrice];
        
        roomImgView = [self createImageViewWithFrame:CGRectMake(_nameLab.x + TCRealValue(5), priceLab.y + priceLab.width + TCRealValue(26), 0, 0) AndImageName:@"res_room"];
        [self.contentView addSubview:roomImgView];
        
        reserveImgView = [self createImageViewWithFrame:CGRectMake(roomImgView.x + roomImgView.width + TCRealValue(12), roomImgView.y, 0, 0) AndImageName:@"res_reserve"];
        [self.contentView addSubview:reserveImgView];
        
        [self initialRangeLab];

        
    }
    return self;
}

- (void)setLocation:(NSString *)location {
    if (!location) {
        locationLineType.hidden = YES;
    }
    locationLab.text = location;
    [locationLab sizeToFit];
    [locationLineType setOrigin:CGPointMake(locationLab.x + locationLab.width + TCRealValue(2), locationLab.y + TCRealValue(1))];
    [typeLab setOrigin:CGPointMake(locationLineType.x + locationLineType.width + TCRealValue(2), locationLab.y)];
}

- (void)setType:(NSString *)type {
    if (!type) {
        locationLineType.hidden = YES;
    }
    typeLab.text = type;
    [typeLab sizeToFit];
}

- (void)setPrice:(CGFloat)price {
    NSString *priceStr = [NSString stringWithFormat:@"%f", price];
    priceStr = [NSString stringWithFormat:@"%@", @(priceStr.floatValue)];
    priceLab.text = priceStr;
    [priceLab sizeToFit];
    [unitLab setX:priceLab.x + priceLab.width];
}

- (void)isSupportRoom:(BOOL)b {
    if (b == YES) {
        roomImgView.hidden = NO;
    }
    [self showRestaurantSupportView];
}

- (void)isSupportReserve:(BOOL)b {
    if (b == YES) {
        reserveImgView.hidden = NO;
    }
    [self showRestaurantSupportView];
}

- (void)showRestaurantSupportView {
    if (roomImgView.hidden == YES && reserveImgView.hidden == NO) {
//        reserveImgView.origin = roomImgView.origin;
        [reserveImgView setX:roomImgView.x];
    }
}

- (UIImageView *)createImageViewWithFrame:(CGRect)frame AndImageName:(NSString *)imgName {
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    UIImage *img = [UIImage imageNamed:imgName];
    imgView.image = img;
    [imgView sizeToFit];
    imgView.hidden = YES;
    return imgView;
}

- (void)createPrice {
    UILabel *markLab = [self createLabWithFrame:CGRectMake(_nameLab.x, TCRealValue(160) - TCRealValue(55) + 1, TCRealValue(19), TCRealValue(19)) AndFontSize:TCRealValue(19)];
    markLab.text = @"￥";
    markLab.font = [UIFont systemFontOfSize:TCRealValue(19)];
    [self.contentView addSubview:markLab];
    
    priceLab = [[UILabel alloc] init];
    priceLab.frame = CGRectMake(markLab.x + markLab.width, markLab.y - 1, 0, markLab.height);
    priceLab.font = markLab.font;
    [self.contentView addSubview:priceLab];
    
    unitLab = [self createLabWithFrame:CGRectMake(priceLab.x, priceLab.y + TCRealValue(19 - 12), TCRealValue(80), TCRealValue(12)) AndFontSize:TCRealValue(12)];
    unitLab.text = @"元/人";
    [self.contentView addSubview:unitLab];
    
}


- (void)initialRangeLab {
    _rangeLab = [self createLabWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - TCRealValue(80) - TCRealValue(20), roomImgView.y + TCRealValue(3), TCRealValue(80), TCRealValue(15)) AndFontSize:TCRealValue(12)];
    _rangeLab.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    _rangeLab.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_rangeLab];
}

- (void)initialImgView {
    
    _resImgView = [[UIImageView alloc] initWithFrame:CGRectMake(TCRealValue(20), TCRealValue(160) / 2 - TCRealValue(130) / 2, TCRealValue(175), TCRealValue(130))];
    [self.contentView addSubview:_resImgView];
}

- (UILabel *)createLabWithFrame:(CGRect)frame AndFontSize:(float)font {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont fontWithName:@"Arial" size:font];
    label.textColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    
    return label;
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
