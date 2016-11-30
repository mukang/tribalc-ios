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
        
        _nameLab = [self createLabWithFrame:CGRectMake(_resImgView.origin.x + _resImgView.size.width + 17, _resImgView.origin.y + 2, cellWidth - _resImgView.origin.x - _resImgView.size.width - 17, 15) AndFontSize:14];
        _nameLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [self.contentView addSubview:_nameLab];
        
        locationLab = [self createLabWithFrame:CGRectMake(_nameLab.origin.x + 2, _nameLab.y + _nameLab.height + 11, _nameLab.width, 12) AndFontSize:12];
        [self.contentView addSubview:locationLab];
        
        typeLab = [self createLabWithFrame:locationLab.frame AndFontSize:12];
        [self.contentView addSubview:typeLab];
        
        locationLineType = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 11)];
        locationLineType.backgroundColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
        [self.contentView addSubview:locationLineType];
        
        [self createPrice];
        
        roomImgView = [self createImageViewWithFrame:CGRectMake(_nameLab.x + 5, priceLab.y + priceLab.width + 26, 0, 0) AndImageName:@"res_room"];
        [self.contentView addSubview:roomImgView];
        
        reserveImgView = [self createImageViewWithFrame:CGRectMake(roomImgView.x + roomImgView.width + 12, roomImgView.y, 0, 0) AndImageName:@"res_reserve"];
        [self.contentView addSubview:reserveImgView];
        
        [self initialRangeLab];

        
    }
    return self;
}

- (void)setLocation:(NSString *)location {
    locationLab.text = location;
    [locationLab sizeToFit];
    [locationLineType setOrigin:CGPointMake(locationLab.x + locationLab.width + 2, locationLab.y + 1)];
    [typeLab setOrigin:CGPointMake(locationLineType.x + locationLineType.width + 2, locationLab.y)];
}

- (void)setType:(NSString *)type {
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
    UILabel *markLab = [self createLabWithFrame:CGRectMake(_nameLab.x, 160 - 55, 19, 19) AndFontSize:19];
    markLab.text = @"￥";
    markLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
    [self.contentView addSubview:markLab];
    
    priceLab = [[UILabel alloc] init];
    priceLab.frame = CGRectMake(markLab.x + markLab.width, markLab.y, 0, markLab.height);
    [self.contentView addSubview:priceLab];
    
    unitLab = [self createLabWithFrame:CGRectMake(priceLab.x, priceLab.y + 5, 80, 12) AndFontSize:12];
    unitLab.text = @"元/人";
    [self.contentView addSubview:unitLab];
    
}


- (void)initialRangeLab {
    _rangeLab = [self createLabWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 80 - 20, roomImgView.y + 3, 80, 15) AndFontSize:12];
    _rangeLab.textColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
    _rangeLab.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_rangeLab];
}

- (void)initialImgView {
    
    _resImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 175, 130)];
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
