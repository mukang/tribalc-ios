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
        
        locationLineType = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 10)];
        locationLineType.backgroundColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1];
        [self.contentView addSubview:locationLineType];
        
        [self createPrice];
        
//        priceLab = [self createLabWithFrame:CGRectMake(_nameLab.origin.x, locationLab.origin.y + locationLab.height + 80, <#CGFloat width#>, <#CGFloat height#>) AndFontSize:<#(float)#>]
//        
//        _priceLab = [self createLabWithFrame:CGRectMake(_nameLab.origin.x, _resImgView.origin.y + _resImgView.size.height - 25, 100, 20) AndFontSize:19];
//        _priceLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
//        [self.contentView addSubview:_priceLab];
        
//        [self initialRangeLab];
//        
//        _privateRoomBtn = [self createRestaurantButtonWithFrame:CGRectMake(_locationAndTypeLab.origin.x, _locationAndTypeLab.origin.y + _locationAndTypeLab.size.height + 7, 47, 29) AndText:@"包间"];
//        [self.contentView addSubview:_privateRoomBtn];
//        
//        _reserveBtn = [self createRestaurantButtonWithFrame:CGRectMake(_privateRoomBtn.origin.x + _privateRoomBtn.size.width + 10, _privateRoomBtn.origin.y, _privateRoomBtn.size.width, _privateRoomBtn.size.height) AndText:@"订座"];
//        [self.contentView addSubview:_reserveBtn];
//        
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

- (void)setPrice:(NSString *)price {
    priceLab.text = price;
    [priceLab sizeToFit];
    [unitLab setX:priceLab.x + priceLab.width];
}

- (void)showRestaurantButton {
    if (_privateRoomBtn.hidden == YES && _reserveBtn.hidden == NO) {
        _reserveBtn.origin = _privateRoomBtn.origin;
    }
}

- (void)createPrice {
    UILabel *markLab = [self createLabWithFrame:CGRectMake(_nameLab.x, 160 - 65, 19, 19) AndFontSize:19];
    markLab.text = @"￥";
    markLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
    [self.contentView addSubview:markLab];
    
    priceLab = markLab;
    priceLab.frame = CGRectMake(markLab.x + markLab.width, markLab.y, 0, markLab.height);
    [self.contentView addSubview:priceLab];
    
    unitLab = [self createLabWithFrame:CGRectMake(priceLab.x, priceLab.y + 3.5, 80, 12) AndFontSize:12];
    unitLab.text = @"元/人";
    [self.contentView addSubview:unitLab];
    
}

//
//- (UIButton *)createRestaurantButtonWithFrame:(CGRect)frame AndText:(NSString *)text {
//    UIButton *button = [[UIButton alloc] initWithFrame:frame];
//    button.layer.cornerRadius = 3;
//    button.layer.borderWidth = 1;
//    button.layer.borderColor = _locationAndTypeLab.textColor.CGColor;
//    button.titleLabel.font = [UIFont systemFontOfSize:14];
//    [button setTitle:text forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    button.hidden = YES;
//    return button;
//    
//}
//
//- (void)initialRangeLab {
//    _rangeLab = [self createLabWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width - 80 - 12, _priceLab.origin.y, 80, 15) AndFontSize:14];
//    _rangeLab.textAlignment = NSTextAlignmentRight;
//    [self.contentView addSubview:_rangeLab];
//}

- (void)initialImgView {
    
    _resImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 175, 130)];
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
